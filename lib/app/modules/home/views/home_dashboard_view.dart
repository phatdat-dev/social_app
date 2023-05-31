import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/modules/home/widget/facebook_card_post_widget.dart';
import 'package:social_app/app/modules/home/widget/input_story_widget.dart';

import '../../../core/utils/utils.dart';
import '../../stories/widget/facebook_card_story_widget.dart';

class HomeDashBoardView extends StatefulWidget {
  HomeDashBoardView({Key? key}) : super(key: key);

  @override
  _HomeDashBoardViewState createState() => _HomeDashBoardViewState();
}

class _HomeDashBoardViewState extends State<HomeDashBoardView> {
  late final HomeController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const InputStoryWidget(),
        _buildListCardStory(),
        GetBuilder(
          init: controller.postController,
          builder: (postController) => postController.obx((state) {
            return ListView.builder(
                itemCount: state!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, int index) {
                  return FacebookCardPostWidget(state[index]);
                });
          }),
        ),
      ],
    );
  }

  Widget _buildListCardStory() {
    return Card(
      child: SizedBox(
        height: 200,
        child: GetBuilder(
          init: controller.storiesController,
          builder: (storiesController) => ListView(
            addAutomaticKeepAlives: true,
            scrollDirection: Axis.horizontal,
            children: [
              FacebookCardStory(
                avatarImage: AuthenticationController.userAccount!.avatar!,
                backgroundImage: AuthenticationController.userAccount!.avatar!,
                onPressAdd: storiesController.createStories,
                user_name: LocaleKeys.CreateYourStories.tr,
              ),
              const SizedBox(width: 5),
              storiesController.listStories.obx(
                (state) => ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state!.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 5),
                    itemBuilder: (context, index) {
                      final item = state[index];
                      return GestureDetector(
                        onTap: () => storiesController.redirectToStoriesView((index: index, data: item)),
                        child: FacebookCardStory(
                          avatarImage: item['avatar'],
                          backgroundImage: item['file_name_story'],
                          user_name: item['userName'],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
