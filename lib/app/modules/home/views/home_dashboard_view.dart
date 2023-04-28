import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/modules/home/views/create_post_view.dart';
import 'package:social_app/app/modules/home/widget/facebook_card_post_widget.dart';
import 'package:social_app/app/widget/animated_route.dart';
import 'package:social_app/facebook/models/model_story.dart';

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
    controller = context.read<HomeController>();
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
        _buildInputStory(context),
        _buildListCardStory(),
        Selector<HomeController, List<Map<String, dynamic>>?>(
          selector: (_, controller) => controller.postData,
          builder: (context, data, child) {
            if (data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, int index) {
                  return FacebookCardPostWidget(data[index]);
                });
          },
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
            itemBuilder: (context, int index) {
              return FacebookCardStory(
                  avatarImage: story_list[index].profile_path,
                  backgroundImage: story_list[index].image_Path,
                  showAddButton: index == 0 ? visible = true : false,
                  user_name: index == 0 ? 'Tạo tin của bạn' : story_list[index].user_name);
            }),
      ),
    );
  }

  Widget _buildInputStory(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      // width: double.infinity,
      // color: Theme.of(context).colorScheme.inversePrimary,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(radius: 25),
              ),
              Expanded(
                child: OutlinedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(AnimatedRoute(const CreatePostView()));
                    },
                    child: const Text('Bạn đang nghĩ gì ?', style: TextStyle(color: Colors.black)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      alignment: Alignment.centerLeft,
                    )),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.photo_library_outlined, color: Colors.green))
            ],
          ),
        ],
      ),
    );
  }
}
