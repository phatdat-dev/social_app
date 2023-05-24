import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/modules/home/widget/card_background_widget.dart';
import 'package:social_app/app/modules/home/widget/facebook_card_post_widget.dart';

class HomeGroupView extends StatefulWidget {
  @override
  _HomeGroupViewState createState() => _HomeGroupViewState();
}

class _HomeGroupViewState extends State<HomeGroupView> {
  //controller
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
    controller.groupController.onInitData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller.groupController,
      builder: (groupController) => ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 125,
            child: Obx(
              () {
                final groupData = groupController.groupData;
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
          groupController.fetchPostGroupController.obx((state) {
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
    );
  }
}
