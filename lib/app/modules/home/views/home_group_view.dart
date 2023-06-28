import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/modules/group/controllers/group_controller.dart';
import 'package:ckc_social_app/app/modules/home/controllers/home_controller.dart';
import 'package:ckc_social_app/app/modules/home/widget/card_background_widget.dart';
import 'package:ckc_social_app/app/modules/post/widget/facebook_card_post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../user/widget/user_friend_card_widget.dart';

class HomeGroupView extends StatefulWidget {
  @override
  _HomeGroupViewState createState() => _HomeGroupViewState();
}

class _HomeGroupViewState extends State<HomeGroupView> with TickerProviderStateMixin {
  //controller
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
    controller.groupController.onInitData();

    controller.subTabBarGroupWidget = {
      const Tab(text: 'Dành cho bạn'): ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 125,
            child: Obx(
              () {
                final groupData = controller.groupController.groupData;
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    const SizedBox(width: 10),
                    if (groupData.isNotEmpty)
                      ...Helper.listGenerateSeparated(
                        groupData.length,
                        generator: (index) => CardBackgroundWidget(
                          data: groupData[index],
                          width: 125,
                          height: 125,
                          onTap: () => controller.groupController.redirectToGroup(context, groupData[index]),
                        ),
                        separator: (index) => const SizedBox(width: 10),
                      ),
                    const SizedBox(width: 10),
                  ],
                );
              },
            ),
          ),

          //
          controller.groupController.fetchPostGroupController.obx((state) {
            return ListView.builder(
                itemCount: state!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, int index) {
                  return FacebookCardPostWidget(state[index]);
                });
          }),
        ],
      ),
      const Tab(text: 'Lời mời vào nhóm'): controller.groupController.inviteMyGroupData.obx((state) => ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: state!.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = state[index];
              return UserFriendCardWidget(
                title: item['groupName'],
                image: NetworkImage(item['avatarGroup']),
                action1: (
                  LocaleKeys.Accept.tr,
                  () => Get.find<GroupController>().call_acceptInviteToGroup(item['group_id']),
                ),
                action2: (
                  LocaleKeys.Cancel.tr,
                  () {},
                ),
              );
            },
          )),
    };

    controller.subTabBarGroupController = TabController(length: controller.subTabBarGroupWidget!.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller.groupController,
      builder: (groupController) => TabBarView(
        controller: controller.subTabBarGroupController,
        children: controller.subTabBarGroupWidget!.values.toList(),
      ),
    );
  }
}
