import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/services/firebase_service.dart';
import 'package:social_app/app/core/utils/extension/app_extension.dart';
import 'package:social_app/app/custom/widget/app_bar_icon_widget.dart';
import 'package:social_app/app/custom/widget/search_widget.dart';
import 'package:social_app/app/models/users_model.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/message/widget/chatcard_widget.dart';
import 'package:social_app/app/routes/app_pages.dart';

import '../controllers/message_controller.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState<T extends MessageController> extends State<MessageView> {
  late final T controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<T>();
    controller.onInitData();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<T>();
    return Scaffold(
      key: controller.key,
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
              AppBarIconWidget(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
              AppBarIconWidget(
                icon: const Icon(Icons.group_add_outlined, color: Colors.green),
                onPressed: () => controller.onCreateNewGroupMessage<T>(context),
              ),
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
                controller.currentChatRoom = controller.currentChatRoom.copyWith({
                  'chatRoomId': controller.generateChatRoomId(['${AuthenticationController.userAccount!.id!}', '${user.id!}']),
                  'user': user,
                });
                context.push(Routes.MESSAGE_DETAIL(user.id!.toString()), extra: controller);
              },
            ),
            StreamBuilder(
                stream: context.read<FireBaseService>().call_getGroupChatOfUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final groupList = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: groupList.length,
                      itemBuilder: (context, index) {
                        final item = groupList[index];
                        return ChatCard(
                          user: AuthenticationController.userAccount!.copyWith(
                            displayName: item['name'],
                          ),
                          onTap: () {
                            controller.currentChatRoom = controller.currentChatRoom.copyWith({
                              'chatRoomId': item['id'],
                              'user': UsersModel(
                                id: 0,
                                displayName: 'asdasd',
                              ),
                            });
                            context.push(Routes.MESSAGE_DETAIL(item['id']), extra: controller);
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }),
          ])),
        ],
      ),
    );
  }

  Widget buildListUser({void Function(int index, UsersModel user)? onTapUserIndex}) {
    return Selector(
        selector: (context, MessageController controller) => controller.listTagFriend,
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
                    final item = value[index] as UsersModel;
                    // if (LoginController.userLogin?.id == user.id) {
                    //   return const SizedBox.shrink();
                    // }
                    return ChatCard(
                      user: item,
                      onTap: () => onTapUserIndex != null ? onTapUserIndex(index, item) : null,
                    );
                  },
                );
        });
  }
}
