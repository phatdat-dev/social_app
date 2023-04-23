import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/models/users_model.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/message/controllers/message_controller.dart';

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
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false; //dang nhap chu~=false
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = context.read<MessageController>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildTextInput() => Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          //duong vien`cua textbox
          //border: Border.all(width: 1.0, color: Colors.black38),
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  //neu' co' du lieu trong text thi` nut gui~ se~ dc hien
                  if (!_isComposing) setState(() => _isComposing = text.isNotEmpty);
                  if (text.isEmpty) setState(() => _isComposing = false);
                },
                keyboardType: TextInputType.multiline, //co the dc nhieu` dong`
                maxLines: 10, //do dai` toi' da =10
                minLines: 1,
                decoration: const InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            //neu' textfield ko rong~ thi` dc phep nhan' nut, ngc lai thi` nhan' ko dc
            IconButton(
                icon: Icon(
                  Icons.send,
                  color: _isComposing ? Theme.of(context).colorScheme.primary : Colors.grey,
                ),
                onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null),
          ],
        ),
      );

  Widget _buildTextComposer() {
    //bottom chat Text o duoi man hinh`
    return IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.primary),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(padding: const EdgeInsets.only(bottom: 15), icon: const Icon(Icons.more_vert), onPressed: () {}),
            IconButton(padding: const EdgeInsets.only(bottom: 15), icon: const Icon(Icons.attach_file), onPressed: () {}),
            IconButton(padding: const EdgeInsets.only(bottom: 15), icon: const Icon(Icons.mic), onPressed: () {}),
            Expanded(child: _buildTextInput()),
            IconButton(padding: const EdgeInsets.only(bottom: 15), icon: const Icon(Icons.thumb_up), onPressed: () {}),
          ],
        ));
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
      controller.call_sendMessage(widget.chatRoomId, text);
    }
  }

  @override //new
  Widget build(BuildContext context) {
    return GestureDetector(
      //huy keyboard khi bam ngoai man hinh
      onTap: () => FocusScope.of(context).unfocus(),
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
                        color: true ? Colors.green : Colors.grey,
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
              subtitle: const Text(
                'online',
                style: TextStyle(fontSize: 12),
              ),
            ))
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: controller.call_getChatRoom(widget.chatRoomId),
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
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                child: SafeArea(
                  bottom: true,
                  //bottom chat Text o duoi man hinh`
                  child: _buildTextComposer(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessage(QueryDocumentSnapshot messageData) {
    //minh` nhan', xac' dinh no' thong qua thuoc tinh' gi` gi` do', o day cho dai random
    final bool isMySend = messageData['user']['id'] == AuthenticationController.userAccount!.id;
    if (isMySend) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.blue),
            child: Text(messageData['message'], style: const TextStyle(color: Colors.white))), //noi dung chat
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
                child: Text(messageData['message']), //noi dung chat
              ),
            ],
          ),
        ],
      ),
    );
  }
}
