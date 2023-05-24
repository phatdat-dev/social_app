import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social_app/app/core/services/firebase_service.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/custom/widget/app_bar_icon_widget.dart';
import 'package:social_app/app/custom/widget/search_widget.dart';
import 'package:social_app/app/models/users_model.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/message/widget/chatcard_widget.dart';
import 'package:social_app/app/routes/app_pages.dart';

import '../controllers/message_controller.dart';

class MessageView<T extends MessageController> extends GetView<T> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
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
                    Get.toNamed(Routes.MESSAGE_SEARCH());
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
                Get.toNamed(Routes.MESSAGE_DETAIL(user.id!.toString()));
              },
            ),
            StreamBuilder(
                stream: Get.find<FireBaseService>().call_getGroupChatOfUser(),
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
                            Get.toNamed(Routes.MESSAGE_DETAIL(item['id']));
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
    return Obx(() {
      return (controller.listFriendOfUser.isEmpty)
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
              itemCount: controller.listFriendOfUser.length,
              itemBuilder: (context, index) {
                final item = controller.listFriendOfUser[index] as UsersModel;
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
