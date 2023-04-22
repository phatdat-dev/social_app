import 'package:flutter/material.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/facebook/components/facebook_button_group.dart';
import 'package:social_app/facebook/components/facebook_card_group.dart';
import 'package:social_app/facebook/components/facebook_card_group_post.dart';
import 'package:social_app/facebook/models/model_group.dart';

import '../../app/widget/app_bar_icon.dart';

class FacebookScreenGroups extends StatefulWidget {
  @override
  _FacebookScreenGroupsState createState() => _FacebookScreenGroupsState();
}

class _FacebookScreenGroupsState extends State<FacebookScreenGroups> {
  List<ModelGroup> groups = [
    ModelGroup(image_path: 'assets/images/china.jpg', title: 'Farming Group'),
    ModelGroup(image_path: 'assets/images/page.jpg', title: 'Cool Page'),
    ModelGroup(image_path: 'assets/images/pexel.jpeg', title: 'Pexel Page'),
    ModelGroup(image_path: 'assets/images/sunset.jpg', title: 'Nature Page'),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double pd = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Expanded(
                          child: Text(
                        'Groups',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.black),
                      )),
                      AppBarIcon(iconData: Icons.search, onTap: () {}),
                    ],
                  ),
                  Container(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        FacebookButtonGroup(onPress: () {}, icon: Icons.person, text: 'Your Groups'),
                        FacebookButtonGroup(onPress: () {}, icon: Icons.discord, text: 'Doscover'),
                        FacebookButtonGroup(onPress: () {}, icon: Icons.add, text: 'Create'),
                        FacebookButtonGroup(onPress: () {}, icon: Icons.settings, text: 'Settings'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: groups.length,
                        itemBuilder: (context, int index) {
                          return FacebookCardGroup(
                              onTap: () {}, onTapCancel: () {}, padding: 20, title: groups[index].title, ImagePath: groups[index].image_path);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: FutureBuilder(
                  future: Helper.readFileJson('assets/json/group.json'),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: const Center(
                          child: Text('Loading...'),
                        ),
                      );
                    }
                    var data = snapshot.data;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, int index) {
                        return FacebookCardGroupPost(
                          profile_image: data[index]['profile_image'],
                          username: data[index]['username'],
                          group_name: data[index]['group_name'],
                          date_posted: data[index]['date_posted'],
                          media_path: data[index]['media_path'],
                          total_reations: data[index]['total_reations'],
                          reaction_text: data[index]['reaction_text'],
                          description: data[index]['description'],
                        );
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

enum padding { active, cancel }
