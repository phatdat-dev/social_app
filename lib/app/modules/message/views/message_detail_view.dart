import 'package:ckc_social_app/app/core/services/firebase_service.dart';
import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/custom/widget/textfield_comment_widget.dart';
import 'package:ckc_social_app/app/models/users_model.dart';
import 'package:ckc_social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:ckc_social_app/app/modules/message/controllers/message_controller.dart';
import 'package:ckc_social_app/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/picker_service.dart';
import '../../post/views/post_create_view.dart';
import '../widget/video_play_widget.dart';

//code layout tham khao tu` google https://viblo.asia/p/flutter-viet-ung-dung-chat-voi-flutter-p1-GrLZD8GOZk0
class MessageDetailView extends StatefulWidget {
  const MessageDetailView({Key? key}) : super(key: key);

  @override
  State createState() => MessageDetailViewState();
}

class MessageDetailViewState extends State<MessageDetailView> {
  late final MessageController controller;
  late final FireBaseService fireBaseService;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<MessageController>();
    //báo lỗi khi
    assert(!(controller.currentChatRoom['chatRoomId'] == null));
    assert(!(controller.currentChatRoom['user'] == null));
    fireBaseService = Get.find<FireBaseService>();
    //
    controller.call_fetchMessageCurrentUser();
    controller.handleMessage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void scrollToLastIndex([VoidCallback? callback]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      callback?.call();
    });
  }

  //ham` khi nhan' gui~
  void _handleSubmitted(String text) async {
    //textField sẽ clear chu~^
    _textController.clear();
    //dat lai trang thai' dang soan =false
    if (text.isNotEmpty) {
      //neu' textField ko rong~ thi` gui tin nhan den fireStore
      //them vao` danh sach tin nhan' o phan tu? dau` tien
      final pickerService = Get.find<PickerService>();
      controller.call_sendMessage(text, pickerService.files);
    }
  }

  @override //new
  Widget build(BuildContext context) {
    return GestureDetector(
      //huy keyboard khi bam ngoai man hinh
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 75,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary, //change your color here
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          //backgroundColor: Colors.amber,
          elevation: 0, //shadow
          title: Row(children: [
            const BackButton(),
            Expanded(child: Builder(builder: (context) {
              final user = (controller.currentChatRoom['user'] as UsersModel);
              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: fireBaseService.call_getUser('${user.id}'),
                builder: (context, snapshot) {
                  final data = snapshot.data?.data();

                  if (snapshot.hasData && data != null && data.isNotEmpty) {
                    final bool isOnline = data['onlineStatus'] == 'Online';
                    return buildLeadingAvatar(user: user, isOnline: isOnline);
                  }
                  return buildLeadingAvatar(user: user);
                },
              );
            })),
          ]),
          actions: [
            IconButton(
              icon: const Icon(Icons.local_phone),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                Get.toNamed(Routes.MESSAGE_SETTING_PROFILE(controller.currentChatRoom['chatRoomId']));
              },
            ),
            const SizedBox(width: 15 / 2),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                // Flexible dua theo widget, size cua thiet bi ma` thay doi?
                child: controller.listMessageState.obx(
                  (state) {
                    scrollToLastIndex();
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8.0),
                      //reverse: true, //tu duoi' len
                      itemCount: state!.length,
                      itemBuilder: (context, index) {
                        return _buildChatMessage(state[index]);
                      },
                    );
                  },
                ),
              ),
              // Divider(height: 1.0),
              GetBuilder(
                init: PickerService(),
                builder: (pickerService) => Column(
                  children: [
                    Obx(
                      () {
                        final filesPicker = pickerService.files.map((e) => (id: null, path: e)).toList();
                        if (filesPicker.isEmpty) return const SizedBox.shrink();

                        return SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: PostCreateView.buildFileAttachments(
                              filesPicker,
                              onDelete: (index) => pickerService.files.removeAt(index),
                              iconSize: 3,
                            ),
                          ),
                        );
                      },
                    ),
                    TextFieldCommentWidget(
                      textEditingController: _textController,
                      onSendComment: (value) {
                        _handleSubmitted(value);
                      },
                      onPickMedia: () => pickerService.pickMultiFile(FileType.media),
                      // onPickFile: () => controller.onPickFileSend(type: FileType.any),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessage(Map<String, dynamic> message) {
    //minh` nhan', xac' dinh no' thong qua thuoc tinh' gi` gi` do', o day cho dai random

    final bool isMySend = message['user_id'] == AuthenticationController.userAccount!.id;
    if (message['media_file'] != null && (message['media_file'] is List) && (message['media_file'] as List).isNotEmpty) {
    } else {
      message['type'] = 'text';
    }

    Widget renderText() {
      if (isMySend) {
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.blue),
              child: Text(message['content'], style: const TextStyle(color: Colors.white))), //noi dung chat
        );
      }
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(backgroundImage: NetworkImage(message['avatar'])), //hinh anh avt
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message['userName']), //! api (đáng lý ra là displayName)
                Container(
                  //width: MediaQuery.of(context).size.width / (1.3),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30)), color: Colors.grey.withOpacity(0.4)),
                  child: Text(message['content']), //noi dung chat
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget renderImage(String url) {
      if (isMySend) {
        return Align(
          alignment: Alignment.centerRight,
          child: HelperWidget.buildImage(url), //noi dung chat
        );
      }
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(backgroundImage: NetworkImage(message['avatar'])), //hinh anh avt
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message['userName']), //ten
                HelperWidget.buildImage(url),
              ],
            ),
          ],
        ),
      );
    }

    Widget renderFile(String url) {
      if (isMySend) {
        return Align(
          alignment: Alignment.centerRight,
          child: HelperWidget.buildFile(url), //noi dung chat
        );
      }
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(backgroundImage: NetworkImage(message['avatar'])), //hinh anh avt
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message['userName']), //ten
                HelperWidget.buildFile(url),
              ],
            ),
          ],
        ),
      );
    }

    Widget renderVideo(String url) {
      Widget videoBuilder() => Container(
            width: 200,
            height: 200,
            color: Colors.black,
            alignment: Alignment.center,
            child: Material(
              elevation: 1,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPlayWidget(url))),
              ),
            ),
          );

      if (isMySend) {
        return Align(
          alignment: Alignment.centerRight,
          child: videoBuilder(),
        );
      }
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(backgroundImage: NetworkImage(message['avatar'])), //hinh anh avt
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message['userName']), //ten
                videoBuilder(),
              ],
            ),
          ],
        ),
      );
    }

    switch (message['type']) {
      case 'notify':
        return Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: Colors.grey.shade100),
            child: Text(
              message['content'],
            ),
          ), //noi dung chat
        );

      case 'text':
        return renderText();
      default:
        //with content = List Image URl
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
              (message['media_file'] as List).length,
              (index) {
                final String item = (message['media_file'] as List)[index]['media_file_name'];
                if (item.isImageFileName) return renderImage(item);
                if (item.isVideoFileName) return renderVideo(item);

                return renderFile(item);
              },
            ),
            renderText(),
          ],
        );
    }
  }

  Widget buildLeadingAvatar({
    required UsersModel user,
    bool isOnline = false,
  }) =>
      ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              //radius: 25,
              backgroundImage: NetworkImage(user.avatar!),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  //neu dang hoat dong thi` them cai bo tron` nho? nho?
                  // ignore: dead_code
                  color: isOnline ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 3),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          user.displayName!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          isOnline ? 'Online' : 'Offline',
          style: const TextStyle(fontSize: 12),
        ),
      );
}
