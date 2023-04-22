import 'package:flutter/material.dart';
import 'package:social_app/app/models/users_model.dart';

//code layout tham khao tu` google https://viblo.asia/p/flutter-viet-ung-dung-chat-voi-flutter-p1-GrLZD8GOZk0
class MessageDetailView extends StatefulWidget {
  final UsersModel user;
  const MessageDetailView(this.user, {Key? key}) : super(key: key);

  @override
  State createState() => MessageDetailViewState();
}

class MessageDetailViewState extends State<MessageDetailView> {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false; //dang nhap chu~=false
  late List<ChatMessage> messages;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messages = [
      ChatMessage(
          user: widget.user, textedBefore: false, chatString: "Hello my name is${widget.user.firstName!}${widget.user.lastName!}", mySend: false),
      ChatMessage(user: widget.user, textedBefore: true, chatString: '${widget.user.dateOfBirth} Old', mySend: false),
      ChatMessage(user: widget.user, textedBefore: true, chatString: '${widget.user.address} my address', mySend: false),
      ChatMessage(user: widget.user, textedBefore: true, chatString: 'company is ${widget.user.liveIn!} ', mySend: false),
      ChatMessage(user: widget.user, textedBefore: true, chatString: 'Nice to meet you', mySend: false),
      ChatMessage(user: widget.user, textedBefore: false, chatString: 'Hello Nice to meet you too', mySend: true),
      ChatMessage(
          user: widget.user,
          textedBefore: false,
          chatString:
              'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          mySend: true),
      ChatMessage(user: widget.user, textedBefore: false, chatString: '1234567890', mySend: true),
      ChatMessage(user: widget.user, textedBefore: false, chatString: 'Funny', mySend: false),
    ];
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
    //textField sẽ clear chu~
    _textController.clear();
    //dat lai trang thai' dang soan =false
    if (text.isNotEmpty) {
      //neu' textField ko rong~ thi` tao 1 widget tin nhan' moi'
      final mess = ChatMessage(chatString: text, mySend: true, user: widget.user, textedBefore: false);
      //them vao` danh sach tin nhan' o phan tu? dau` tien
      setState(() {
        //neu la` them tu duoi' len
        //messages.insert(0, mess);
        messages.add(mess);
        _isComposing = false;
      });
    }
  }

  @override //new
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
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
                widget.user.firstName! + widget.user.lastName!,
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
        body: Column(
          children: [
            Flexible(
              // Flexible dua theo widget, size cua thiet bi ma` thay doi?
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                //reverse: true, //tu duoi' len
                itemCount: messages.length,
                itemBuilder: (context, index) => messages[index],
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
    ));
  }
}

class ChatMessage extends StatelessWidget {
  final String chatString;
  final bool mySend;
  //
  final UsersModel user;
  final bool textedBefore; //thuong` thuong` kophai nhu v, cach' nay` la` che' lai.
  const ChatMessage({Key? key, required this.chatString, required this.mySend, required this.textedBefore, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //minh` nhan', xac' dinh no' thong qua thuoc tinh' gi` gi` do', o day cho dai random
    if (mySend) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.blue),
            child: Text(chatString, style: const TextStyle(color: Colors.white))), //noi dung chat
      );
    }
    //ng`khac' nhan'
    if (textedBefore) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 55),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30)), color: Colors.grey.withOpacity(0.4)),
            child: Text(chatString), //noi dung chat
          ),
        ],
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(backgroundImage: NetworkImage(user.avatar!)), //hinh anh avt
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.firstName! + user.lastName!), //ten
              Container(
                //width: MediaQuery.of(context).size.width / (1.3),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                margin: const EdgeInsets.only(top: 5.0),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30)), color: Colors.grey.withOpacity(0.4)),
                child: Text(chatString), //noi dung chat
              ),
            ],
          ),
        ],
      ),
    );
  }
}
