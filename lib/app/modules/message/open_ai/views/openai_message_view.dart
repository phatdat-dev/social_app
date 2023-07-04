import 'package:ckc_social_app/app/core/utils/helper_widget.dart';
import 'package:ckc_social_app/app/custom/widget/textfield_comment_widget.dart';
import 'package:ckc_social_app/app/models/users_model.dart';
import 'package:ckc_social_app/app/modules/message/open_ai/controller/openai_controller.dart';
import 'package:ckc_social_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../authentication/controllers/authentication_controller.dart';
import '../../widget/video_play_widget.dart';

//code layout tham khao tu` google https://viblo.asia/p/flutter-viet-ung-dung-chat-voi-flutter-p1-GrLZD8GOZk0
class OpenAIMessageView extends StatefulWidget {
  const OpenAIMessageView({Key? key}) : super(key: key);

  @override
  State createState() => OpenAIMessageViewState();
}

class OpenAIMessageViewState extends State<OpenAIMessageView> {
  late final OpenAIController controller;
  late final UsersModel botUser;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final RxList<_ChatMessage> messages = RxList();

  @override
  void initState() {
    super.initState();
    controller = Get.find<OpenAIController>();
    botUser = UsersModel(
      id: 0,
      avatar: 'https://robohash.org/excepturiiuremolestiae.png',
      displayName: 'AI Bot GPT',
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _scrollController.dispose();
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
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(); //huy keyboard
    //textField sẽ clear chu~^
    _textController.clear();
    //dat lai trang thai' dang soan =false
    if (text.isNotEmpty) {
      //neu' textField ko rong~ thi` tao 1 widget tin nhan' moi'
      final mess = _ChatMessage(data: text, user: AuthenticationController.userAccount!, type: 'text');
      messages.add(mess);

      //call api goi bot
      controller.sendCompletion(text).then((value) {
        scrollToLastIndex();

        if (value != null) {
          value.choices?.forEach((element) {
            String text = element.text!;
            text = text.substring(2); //bỏ cái cái \n\n
            messages.add(
              _ChatMessage(
                data: text,
                user: botUser,
                type: 'text',
              ),
            );
          });
        }
      });
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
            Expanded(
                child: ListTile(
              leading: Stack(
                children: [
                  CircleAvatar(
                    //radius: 25,
                    backgroundImage: NetworkImage(botUser.avatar!),
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
                        color: true ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 3),
                      ),
                    ),
                  )
                ],
              ),
              title: Text(
                botUser.displayName!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text(
                'online',
                style: TextStyle(fontSize: 12),
              ),
            )),
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
              onPressed: () => Get.toNamed(Routes.OPENAI_MESSAGE_SETTING()),
            ),
            const SizedBox(width: 15 / 2),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                // Flexible dua theo widget, size cua thiet bi ma` thay doi?
                child: Obx(() => ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8.0),
                      //reverse: true, //tu duoi' len
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return _buildChatMessage(messages[index]);
                      },
                    )),
              ),
              // Divider(height: 1.0),
              TextFieldCommentWidget(
                textEditingController: _textController,
                onSendComment: (value) {
                  _handleSubmitted(value);
                },
                // onPickMedia: () => controller.onPickFileSend(type: FileType.image),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessage(_ChatMessage chatMessage) {
    //minh` nhan', xac' dinh no' thong qua thuoc tinh' gi` gi` do', o day cho dai random

    final bool isMySend = chatMessage.user.id == AuthenticationController.userAccount?.id;

    Widget renderText() {
      if (isMySend) {
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.blue),
              child: Text(chatMessage.data, style: const TextStyle(color: Colors.white))), //noi dung chat
        );
      }
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(backgroundImage: NetworkImage(chatMessage.user.avatar!)), //hinh anh avt
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chatMessage.user.displayName!), //ten
                Container(
                  //width: MediaQuery.of(context).size.width / (1.3),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30)), color: Colors.grey.withOpacity(0.4)),
                  child: Text(chatMessage.data), //noi dung chat
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
              child: CircleAvatar(backgroundImage: NetworkImage(chatMessage.user.avatar!)), //hinh anh avt
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chatMessage.user.displayName!), //ten
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
              child: CircleAvatar(backgroundImage: NetworkImage(chatMessage.user.avatar!)), //hinh anh avt
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chatMessage.user.displayName!), //ten
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
              child: CircleAvatar(backgroundImage: NetworkImage(chatMessage.user.avatar!)), //hinh anh avt
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chatMessage.user.displayName!), //ten
                videoBuilder(),
              ],
            ),
          ],
        ),
      );
    }

    switch (chatMessage.type) {
      case 'notify':
        return Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: Colors.grey.shade100),
            child: Text(
              chatMessage.data,
            ),
          ), //noi dung chat
        );

      case 'text':
        return renderText();
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            (chatMessage.data as List).length,
            (index) {
              final String item = chatMessage.data[index];
              if (item.isImageFileName) return renderImage(item);
              if (item.isVideoFileName) return renderVideo(item);

              return renderFile(item);
            },
          ),
        );
    }
  }
}

class _ChatMessage {
  final dynamic data; //String or List URL
  final String type;
  //
  final UsersModel user;
  const _ChatMessage({required this.data, required this.user, required this.type});
}
