import 'package:ckc_social_app/app/custom/widget/app_bar_icon_widget.dart';
import 'package:ckc_social_app/app/custom/widget/search_widget.dart';
import 'package:ckc_social_app/app/models/users_model.dart';
import 'package:ckc_social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:ckc_social_app/app/modules/message/widget/chatcard_widget.dart';
import 'package:ckc_social_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: CircleAvatar(radius: 25, backgroundImage: NetworkImage(AuthenticationController.userAccount?.avatar ?? '')),
            ),
            title: const Text('Chats', style: TextStyle(color: Colors.black)),
            actions: [
              AppBarIconWidget(icon: const Icon(Icons.smart_toy_outlined), onPressed: () => Get.toNamed(Routes.OPENAI_MESSAGE())),
              // AppBarIconWidget(icon: const Icon(Icons.camera_alt_outlined), onPressed: () => Get.toNamed(Routes.VIDEO_CALL())),
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
                  // onTap: () {
                  //   Get.toNamed(Routes.MESSAGE_SEARCH());
                  //   WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                  // },
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(height: 10),
            buildListUser(
              onTapUserIndex: controller.onCreateMessage,
            ),
            controller.listChatState.obx((state) => ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state!.length,
                  itemBuilder: (context, index) {
                    final item = state[index];
                    final user = UsersModel(
                      id: item['userId'],
                      displayName: item['conversation_name'],
                      avatar: item['conversation_avatar'],
                    );
                    return ChatCard(
                      user: user,
                      onTap: () {
                        controller.onCreateMessage(index, user);
                      },
                    );
                  },
                )),
          ])),
        ],
      ),
    );
  }

  Widget buildListUser({void Function(int index, UsersModel user)? onTapUserIndex}) {
    final defaultWidth = 30.0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 90,
      child: Obx(() {
        return ListView.separated(
          // shrinkWrap: true, //tranh' loi~ view SingleChildScrollView-column
          //ngan chan ListView no' cuon xuong' duoc, xai` cho SingleChildScrollView-column

          // physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: controller.listFriendOfUser.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final item = controller.listFriendOfUser[index];
            // if (LoginController.userLogin?.id == user.id) {
            //   return const SizedBox.shrink();
            // }
            return Column(
              children: [
                ChatCard(
                  user: item,
                  onTap: () => onTapUserIndex != null ? onTapUserIndex(index, item) : null,
                ).buildAvatar(defaultWidth),
                SizedBox(
                  width: defaultWidth * 2,
                  child: Text(
                    item.displayName ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
