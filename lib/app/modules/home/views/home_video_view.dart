import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/modules/home/widget/facebook_card_post_widget.dart';

class HomeVideoView extends StatefulWidget {
  const HomeVideoView({Key? key}) : super(key: key);

  @override
  HomeVideoViewState createState() => HomeVideoViewState();
}

class HomeVideoViewState extends State<HomeVideoView> with TickerProviderStateMixin {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();

    controller.subTabBarVideoWidget = {
      const Tab(text: 'Dành cho bạn'): ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          controller.postController.obx((state) => ListView.builder(
              itemCount: state!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, int index) {
                return FacebookCardPostWidget(state[index]);
              })),
        ],
      ),
      const Tab(text: 'Trực tiếp'): Container(
        width: 100,
        height: 100,
        color: Colors.red,
      ),
      const Tab(text: 'Chơi game'): Container(
        width: 100,
        height: 100,
        color: Colors.red,
      ),
      const Tab(text: 'Đang theo dõi'): Container(
        width: 100,
        height: 100,
        color: Colors.red,
      ),
    };

    controller.subTabBarGroupWidget = {
      const Tab(text: 'Dành cho bạn'): ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          controller.postController.obx((state) => ListView.builder(
              itemCount: state!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, int index) {
                return FacebookCardPostWidget(state[index]);
              })),
        ],
      ),
      const Tab(text: 'Nhóm của bạn'): Container(
        width: 100,
        height: 100,
        child: const Text('Nhóm của bạn widget'),
      ),
    };

    controller.subTabBarVideoController = TabController(length: controller.subTabBarVideoWidget!.length, vsync: this);
    controller.subTabBarGroupController = TabController(length: controller.subTabBarGroupWidget!.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller.subTabBarVideoController,
      children: controller.subTabBarVideoWidget!.values.toList(),
    );
  }
}
