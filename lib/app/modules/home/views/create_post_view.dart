import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/core/services/picker_service.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/models/response/privacy_model.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/group/controllers/group_controller.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/modules/search_tag_friend/views/search_tag_friend_view.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class CreatePostView<T extends HomeController> extends GetView<T> {
  CreatePostView({super.key, this.postResponseModel}) {
    txtController = TextEditingController(text: postResponseModel?['post_content']);
    currentPrivacy = ValueNotifier(PrivacyModel.from(postResponseModel?['privacy'] ?? 0)); //private
  }

  late ValueNotifier<PrivacyModel> currentPrivacy;
  late final TextEditingController txtController;
  GroupController? groupController = null;
  final Map<String, dynamic>? postResponseModel;

  // đáng lý ra phải viết trong controller > nhưng pass qua 1 nùi giá trị thì mắc công
  // nên viết ổ đây luôn, mốt rảnh refactor code
  void onSubmit() {
    final pickerService = Get.find<PickerService>();
    //nếu postResponseModel không có data => đang tạo
    if (postResponseModel == null) {
      controller.postController
          .call_createPostData(
        content: txtController.text,
        privacy: currentPrivacy.value.privacyId!, //get dropdown privacy
        groupId: groupController?.currentGroup['id'] ?? null,
        filesPath: pickerService.files,
        // images: [],
      )
          .then((value) {
        HelperWidget.showSnackBar(message: 'Create Success');
        Get.back();
      });
    }
    //nếu postResponseModel có data => đang edit
    else {
      controller.postController
          .call_updatePostData(
        postId: postResponseModel!['id'],
        content: txtController.text,
        privacy: currentPrivacy.value.privacyId!, //get dropdown privacy
        filesPath: pickerService.files,
        removeFile: postResponseModel!['removeFile'],
      )
          .then((value) {
        postResponseModel!.remove('removeFile');
        HelperWidget.showSnackBar(message: 'Update Success');
        Get.back();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<GroupController>()) groupController = Get.find<GroupController?>();
    //  = Get.find<GroupController?>();
    final String title =
        groupController?.currentGroup['group_name'] ?? (postResponseModel == null) ? LocaleKeys.CreatePost.tr : LocaleKeys.EditPost.tr;

    return GestureDetector(
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: GetBuilder<PickerService>(
        init: PickerService(),
        builder: (pickerService) {
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: AnimatedBuilder(
                    animation: txtController,
                    builder: (context, child) {
                      final bool allowPost = txtController.text.isNotEmpty || (pickerService.files.isNotEmpty);
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: allowPost ? null : Colors.grey.shade200,
                        ),
                        onPressed: allowPost ? onSubmit : null,
                        child: Text('Đăng', style: TextStyle(color: allowPost ? null : Colors.grey)),
                      );
                    },
                  ),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              shrinkWrap: true,
              // controller: scrollController,
              physics: const BouncingScrollPhysics(),
              children: [
                buildHeader(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: buildTextField(),
                ),

                const Divider(
                  indent: 20,
                  endIndent: 20,
                  thickness: 1,
                ),
                //show image when push complete

                Builder(builder: (context) {
                  final RxList<({int id, String path})>? fileAttachments = (postResponseModel?['mediafile'] as List?)
                      ?.map((e) => (id: int.parse("${e['id']}"), path: e['media_file_name'].toString()))
                      .toList()
                      .obs;

                  return Obx(() {
                    final filesPicker = pickerService.files.map((e) => (id: null, path: e)).toList();
                    if (filesPicker.isEmpty && postResponseModel == null) return const SizedBox.shrink();

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ..._buildFileAttachments(
                          filesPicker,
                          onDelete: (index) => pickerService.files.removeAt(index),
                        ),
                        if (fileAttachments != null)
                          ..._buildFileAttachments(
                            fileAttachments,
                            onDelete: (index) {
                              final fileOfIndex = fileAttachments.removeAt(index);

                              postResponseModel?.update('removeFile', (value) {
                                (value as List).add(fileOfIndex.id);
                                return value;
                              }, ifAbsent: () {
                                return [fileOfIndex.id];
                              });
                            },
                          ),
                      ],
                    );
                  });
                }),
              ],
            ),
            bottomSheet: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Builder(builder: (context) {
                final List<Widget> children = [
                  InkWell(
                    onTap: () async {
                      pickerService.pickMultiFile(FileType.media);
                    },
                    customBorder: const StadiumBorder(),
                    child: const Icon(
                      Icons.photo_library_outlined,
                      color: Colors.green,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchTagFriendView<T>(title: LocaleKeys.TagAFriend.tr)));
                    },
                    customBorder: const StadiumBorder(),
                    child: const Icon(
                      Icons.loyalty_outlined,
                      color: Colors.blue,
                    ),
                  ),
                  const Icon(
                    Icons.tag_faces,
                    color: Colors.amber,
                  ),
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.red,
                  ),
                  const Icon(Icons.more_outlined),
                ];
                return IconTheme(
                    data: const IconThemeData(size: 30),
                    child: Row(
                      children: children.map((e) => Expanded(child: e)).toList(),
                    ));
              }),
            ),
          );
        },
      ),
    );
  }

  Scrollbar buildTextField() {
    return Scrollbar(
      child: TextFormField(
        maxLines: null,
        minLines: null,
        expands: true,
        // scrollController: scrollController,
        scrollPhysics: const BouncingScrollPhysics(),
        controller: txtController,
        decoration: InputDecoration(
          // filled: true,
          // fillColor: ,
          border: InputBorder.none,
          hintText: LocaleKeys.WhatOnYourMind.tr,
          hintStyle: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  ListTile buildHeader() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      // minVerticalPadding: 10,
      // visualDensity: VisualDensity.compact,
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(AuthenticationController.userAccount!.avatar!),
      ),

      title: Text(AuthenticationController.userAccount!.displayName!, style: const TextStyle(fontWeight: FontWeight.bold)),
      // isThreeLine: true,
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
              valueListenable: currentPrivacy,
              builder: (context, value, child) => InkWell(
                    onTap: () => showBottomSheetPrivacy(context),
                    borderRadius: BorderRadius.circular(5),
                    child: Ink(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconTheme(
                          data: const IconThemeData(size: 18, color: Colors.grey),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(child: Icon(value.privacyIcon)),
                                const WidgetSpan(child: SizedBox(width: 5)),
                                TextSpan(text: value.privacyPostName),
                                const WidgetSpan(child: SizedBox(width: 5)),
                                const WidgetSpan(child: Icon(Icons.arrow_drop_down)),
                              ],
                            ),
                          )),
                    ),
                  )),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(5),
            child: Ink(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const IconTheme(
                  data: IconThemeData(size: 18, color: Colors.grey),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(child: Icon(Icons.add)),
                        WidgetSpan(child: SizedBox(width: 5)),
                        TextSpan(text: 'Album'),
                        WidgetSpan(child: SizedBox(width: 5)),
                        WidgetSpan(child: Icon(Icons.arrow_drop_down)),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void showBottomSheetPrivacy(BuildContext context) {
    showModalBottomSheet<PrivacyModel>(
        context: context,
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        isScrollControlled: true,
        builder: (context) {
          final List<PrivacyModel> listPrivacy = PrivacyModel.listPrivacy;
          //Radio nó sẽ so sánh vùng nhớ, nên phải lấy groupValue từ danh sách vùng nhớ
          PrivacyModel selectedPrivacy = listPrivacy[currentPrivacy.value.privacyId!];
          return SizedBox(
            // height: MediaQuery.of(context).size.height * 0.5,
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LocaleKeys.WhoCanSeeYourPost.tr,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        LocaleKeys.SelectTheAudienceForThisPost.tr,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                StatefulBuilder(
                  builder: (context, setState) => Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: listPrivacy
                        .mapIndexed((index, e) => RadioListTile(
                              value: e,
                              groupValue: selectedPrivacy,
                              dense: false,
                              activeColor: Theme.of(context).colorScheme.primary,
                              controlAffinity: ListTileControlAffinity.trailing,
                              secondary: Icon(e.privacyIcon),
                              title: Text(e.privacyPostName!),
                              subtitle: Text(e.privacyPostDescription!),
                              onChanged: (value) => setState(() => selectedPrivacy = value!),
                            ))
                        .toList(),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(selectedPrivacy),
                      child: const Text('OK'),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).then((selectedPrivacy) {
      if (selectedPrivacy != null) {
        currentPrivacy.value = selectedPrivacy;
      }
    });
  }

  List<Widget> _buildFileAttachments(List<({int? id, String path})> filesPicker, {required ValueChanged<int> onDelete}) {
    return List.generate(
      filesPicker.length,
      (index) {
        final bool isImageFile = filesPicker[index].path.isImageFileName;
        final bool isVideoFile = filesPicker[index].path.isVideoFileName;
        final bool isURL = filesPicker[index].path.contains('http');

        if (isImageFile) {
          return Stack(
            children: [
              kIsWeb || isURL
                  ? Image.network(filesPicker[index].path)
                  : Image.file(
                      File(filesPicker[index].path),
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) =>
                          const Center(child: Text('This image type is not supported')),
                    ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Material(
                    elevation: 1,
                    shape: const CircleBorder(),
                    child: CloseButton(onPressed: () => onDelete(index)),
                  ),
                ),
              ),
            ],
          );
        }
        if (isVideoFile) {
          VideoPlayerController videoPlayerController = VideoPlayerController.file(File(filesPicker[index].path));

          return FutureBuilder(
            future: videoPlayerController.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: Chewie(
                    controller: ChewieController(videoPlayerController: videoPlayerController),
                  ),
                );
              }
              return const CircularProgressIndicator();
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
