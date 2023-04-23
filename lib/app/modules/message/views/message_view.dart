import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/models/users_model.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/message/widget/chatcard_widget.dart';
import 'package:social_app/app/routes/app_pages.dart';
import 'package:social_app/app/widget/search_widget.dart';

import '../controllers/message_controller.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late final MessageController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<MessageController>();
    controller.onInitData();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MessageController>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0, //shadow
            automaticallyImplyLeading: false, //tat' cai' back tu dong
            leading: const Padding(
              padding: EdgeInsets.only(left: 15),
              child: CircleAvatar(radius: 25),
            ),
            title: const Text('Chats', style: TextStyle(color: Colors.black)),
            actions: [
              IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
              IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SearchWidget(
                  controller: TextEditingController(),
                  hintText: 'Search Anyone',
                  onTap: () {
                    context.push(Routes.MESSAGE_SEARCH(), extra: controller);
                    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                  },
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            buildListUser(
              onTapUserIndex: (index, user) {
                context.push(Routes.MESSAGE_DETAIL(user.id!), extra: {
                  'chatRoomId': controller.generateChatRoomId('${AuthenticationController.userAccount!.id!}', '${user.id!}'),
                  'user': user,
                  'controller': controller,
                });
              },
            ),
          ])),
        ],
      ),
    );
  }

  Widget buildListUser({void Function(int index, UsersModel user)? onTapUserIndex}) {
    return Selector(
        selector: (context, MessageController controller) => controller.friends,
        builder: (context, value, child) {
          return (value?.isEmpty ?? true)
              ? Column(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/search_2.svg',
                      width: 200,
                      height: 200,
                    ),
                    const Text('Not found'),
                  ],
                )
              : ListView.builder(
                  shrinkWrap: true, //tranh' loi~ view SingleChildScrollView-column
                  //ngan chan ListView no' cuon xuong' duoc, xai` cho SingleChildScrollView-column
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value!.length,
                  itemBuilder: (context, index) {
                    final item = value[index];
                    // if (LoginController.userLogin?.id == user.id) {
                    //   return const SizedBox.shrink();
                    // }
                    final user = UsersModel(
                      id: item['friendId'],
                      displayName: item['displayName'],
                      avatar: item['avatar'],
                    );
                    return ChatCard(
                      user: user,
                      onTap: () => onTapUserIndex != null ? onTapUserIndex(index, user) : null,
                    );
                  },
                );
        });
  }
}
