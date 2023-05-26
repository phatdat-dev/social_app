import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/modules/home/widget/facebook_card_post_widget.dart';
import 'package:social_app/app/modules/home/widget/input_story_widget.dart';

import '../widget/facebook_card_story_widget.dart';

class HomeDashBoardView extends StatefulWidget {
  HomeDashBoardView({Key? key}) : super(key: key);

  @override
  _HomeDashBoardViewState createState() => _HomeDashBoardViewState();
}

bool visible = false;

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

  void loadData() {
    Helper.readFileJson('assets/json/FacebookPost.json');
  }

  List<ModelStory> story_list = [
    ModelStory(image_Path: 'assets/images/photo.jpg', user_name: 'Add a story', profile_path: 'assets/images/photo.jpg'),
    ModelStory(image_Path: 'assets/images/china.jpg', user_name: 'Wung Chang', profile_path: 'assets/images/china.jpg'),
    ModelStory(image_Path: 'assets/images/sunset.jpg', user_name: 'Jakal', profile_path: 'assets/images/sunset.jpg'),
    ModelStory(image_Path: 'assets/images/pexel.jpeg', user_name: 'Jakal', profile_path: 'assets/images/pexel.jpeg')
  ];

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
        child: ListView.separated(
            addAutomaticKeepAlives: true,
            scrollDirection: Axis.horizontal,
            itemCount: story_list.length,
            separatorBuilder: (context, index) => const SizedBox(width: 5),
            itemBuilder: (context, index) {
              return FacebookCardStory(
                avatarImage: story_list[index].profile_path,
                backgroundImage: story_list[index].image_Path,
                showAddButton: index == 0 ? visible = true : false,
                user_name: index == 0 ? LocaleKeys.CreateYourStories.tr : story_list[index].user_name,
              );
            }),
      ),
    );
  }
}

class ModelStory {
  final String image_Path;
  final String user_name;
  final String profile_path;

  ModelStory({
    required this.image_Path,
    required this.user_name,
    required this.profile_path,
  });
}
