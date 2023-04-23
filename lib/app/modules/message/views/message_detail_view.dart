import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/services/firebase_service.dart';
import 'package:social_app/app/models/users_model.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/message/controllers/message_controller.dart';
import 'package:social_app/app/widget/textfield_comment_widget.dart';

//code layout tham khao tu` google https://viblo.asia/p/flutter-viet-ung-dung-chat-voi-flutter-p1-GrLZD8GOZk0
class MessageDetailView extends StatefulWidget {
  final UsersModel user;
  final String chatRoomId;
  const MessageDetailView(this.chatRoomId, this.user, {Key? key}) : super(key: key);

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
    controller = context.read<MessageController>();
    fireBaseService = context.read<FireBaseService>();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    //textField sẽ clear chu~^
    _textController.clear();
    //dat lai trang thai' dang soan =false
    if (text.isNotEmpty) {
      //neu' textField ko rong~ thi` gui tin nhan den fireStore
      //them vao` danh sach tin nhan' o phan tu? dau` tien
      fireBaseService.call_sendMessage(chatRoomId: widget.chatRoomId, type: 'text', data: text);
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
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: fireBaseService.call_getUser('${widget.user.id}'),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data?.data() != null) {
                  final bool isOnline = snapshot.data!['status'] == 'Online';
                  return ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          //radius: 25,
                          backgroundImage: NetworkImage(widget.user.avatar!),
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
                        )
                      ],
                    ),
                    title: Text(
                      widget.user.displayName!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "${snapshot.data!['status']}", //Online/Offline
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
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
              onPressed: () {},
            ),
            const SizedBox(width: 15 / 2),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                // Flexible dua theo widget, size cua thiet bi ma` thay doi?
                child: StreamBuilder(
                  stream: fireBaseService.call_getChatRoom(widget.chatRoomId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8.0),
                        //reverse: true, //tu duoi' len
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return _buildChatMessage(docs[index]);
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              // Divider(height: 1.0),
              TextFieldCommentWidget(
                textEditingController: _textController,
                onSendComment: (value) {
                  _handleSubmitted(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessage(QueryDocumentSnapshot<Map<String, dynamic>> messageData) {
    //minh` nhan', xac' dinh no' thong qua thuoc tinh' gi` gi` do', o day cho dai random

    final bool? isMySend = messageData.data()['user']?['id'] == AuthenticationController.userAccount!.id;
    switch (messageData['type']) {
      case 'notify':
        return Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: Colors.grey.shade100),
            child: Text(
              messageData['data'],
            ),
          ), //noi dung chat
        );
      // case 'image':
      //   break;
      // case 'video':
      //   break;
      // case 'file':
      //   break;
      default:
        if (isMySend ?? false) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.blue),
                child: Text(messageData['data'], style: const TextStyle(color: Colors.white))), //noi dung chat
          );
        }
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(backgroundImage: NetworkImage(messageData['user']['avatar'])), //hinh anh avt
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(messageData['user']['displayName']), //ten
                  Container(
                    //width: MediaQuery.of(context).size.width / (1.3),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    margin: const EdgeInsets.only(top: 5.0),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30)), color: Colors.grey.withOpacity(0.4)),
                    child: Text(messageData['data']), //noi dung chat
                  ),
                ],
              ),
            ],
          ),
        );
    }
  }
}
