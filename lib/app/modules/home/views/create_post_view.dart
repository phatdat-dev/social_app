import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/services/picker_service.dart';
import 'package:social_app/app/core/utils/extension/string_extension.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/modules/home/views/search_tag_friend_view.dart';
import 'package:social_app/app/widget/circle_avatar_widget.dart';
import 'package:video_player/video_player.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HomeController>();
    final txtController = TextEditingController();

    return GestureDetector(
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: ChangeNotifierProvider.value(
          value: PickerService(),
          builder: (context, child) {
            var filesPicker = context.select((PickerService pickerService) => pickerService.files);
            return Scaffold(
              appBar: AppBar(
                title: const Text('Tạo bài viết'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: AnimatedBuilder(
                      animation: txtController,
                      builder: (context, child) {
                        final bool allowPost = txtController.text.isNotEmpty || (filesPicker?.isNotEmpty ?? false);
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: allowPost ? null : Colors.grey.shade200,
                          ),
                          onPressed: () {},
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
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    // minVerticalPadding: 10,
                    // visualDensity: VisualDensity.compact,
                    leading: const CircleAvatarWidget(radius: 25),
                    title: const Text('Username Here', style: TextStyle(fontWeight: FontWeight.bold)),
                    // isThreeLine: true,
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                      WidgetSpan(child: Icon(Icons.public)),
                                      WidgetSpan(child: SizedBox(width: 5)),
                                      TextSpan(text: 'Public'),
                                      WidgetSpan(child: SizedBox(width: 5)),
                                      WidgetSpan(child: Icon(Icons.arrow_drop_down)),
                                    ],
                                  ),
                                )),
                          ),
                        ),
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
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: Scrollbar(
                      child: TextFormField(
                        maxLines: null,
                        minLines: null,
                        expands: true,
                        // scrollController: scrollController,
                        scrollPhysics: const BouncingScrollPhysics(),
                        controller: txtController,
                        decoration: const InputDecoration(
                          // filled: true,
                          // fillColor: ,
                          border: InputBorder.none,
                          hintText: 'What\'s on your Mind?',
                          hintStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),

                  const Divider(
                    indent: 20,
                    endIndent: 20,
                    thickness: 1,
                  ),
                  //show image when push complete

                  Builder(
                    builder: (context) {
                      if (filesPicker == null) return const SizedBox.shrink();

                      return StatefulBuilder(
                          builder: (context, setState) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  filesPicker.length,
                                  (index) {
                                    final bool isImageFile = filesPicker[index].path.isImageFileName;
                                    final bool isVideoFile = filesPicker[index].path.isVideoFileName;

                                    if (isImageFile) {
                                      return Stack(
                                        children: [
                                          kIsWeb
                                              ? Image.network(filesPicker[index].path)
                                              : Image.file(
                                                  filesPicker[index],
                                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) =>
                                                      const Center(child: Text('This image type is not supported')),
                                                ),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Material(
                                                elevation: 1,
                                                shape: const CircleBorder(),
                                                child: CloseButton(
                                                  onPressed: () {
                                                    filesPicker.removeAt(index);
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    if (isVideoFile) {
                                      VideoPlayerController videoPlayerController = VideoPlayerController.file(filesPicker[index]);

                                      return Stack(
                                        children: [
                                          FutureBuilder(
                                            future: videoPlayerController.initialize(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.done) {
                                                return AspectRatio(
                                                  aspectRatio: videoPlayerController.value.aspectRatio,
                                                  child: VideoPlayer(videoPlayerController),
                                                );
                                              }
                                              return const CircularProgressIndicator();
                                            },
                                          ),
                                          //play button
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Material(
                                                elevation: 1,
                                                shape: const CircleBorder(),
                                                child: StatefulBuilder(
                                                  builder: (context, setState) => IconButton(
                                                    icon: Icon(videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow),
                                                    onPressed: () {
                                                      setState(() {
                                                        videoPlayerController.value.isPlaying
                                                            ? videoPlayerController.pause()
                                                            : videoPlayerController.play();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Material(
                                                elevation: 1,
                                                shape: const CircleBorder(),
                                                child: CloseButton(
                                                  onPressed: () {
                                                    filesPicker.removeAt(index);
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ));
                    },
                  )
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
                        context.read<PickerService>().pickMultiFile(FileType.media);
                      },
                      customBorder: const StadiumBorder(),
                      child: const Icon(
                        Icons.photo_library_outlined,
                        color: Colors.green,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchTagFriendView()));
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
          }),
    );
  }
}
