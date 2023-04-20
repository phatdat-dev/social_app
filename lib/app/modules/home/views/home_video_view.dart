import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/utils/utils.dart';
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
    controller = context.read<HomeController>();

    controller.subTabBarVideoWidget = {
      Tab(text: "Dành cho bạn"): ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          FutureBuilder(
              future: Helper.readFileJson('assets/json/video.json'),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                var data = snapshot.data;
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, int index) {
                      return FacebookCardPostWidget(
                        profile_path: data[index]['profile_image'],
                        user_name: data[index]['user_name'],
                        date: data[index]['date_posted'],
                        description: data[index]['title'],
                        imageUrl: [data[index]['media_path']],
                        reactions: data[index]['people_reacted'],
                        nums: data[index]['no_of_reactions'],
                      );
                    });
              })
        ],
      ),
      Tab(text: "Trực tiếp"): Container(
        width: 100,
        height: 100,
        color: Colors.red,
      ),
      Tab(text: "Chơi game"): Container(
        width: 100,
        height: 100,
        color: Colors.red,
      ),
      Tab(text: "Đang theo dõi"): Container(
        width: 100,
        height: 100,
        color: Colors.red,
      ),
    };

    controller.subTabBarVideoController = TabController(length: controller.subTabBarVideoWidget!.length, vsync: this);
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
