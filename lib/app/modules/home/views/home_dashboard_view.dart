import 'package:flutter/material.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/modules/home/views/create_post_view.dart';
import 'package:social_app/app/modules/home/widget/facebook_card_post_widget.dart';
import 'package:social_app/app/widget/animated_route.dart';
import 'package:social_app/app/widget/circle_avatar_widget.dart';
import 'package:social_app/facebook/models/model_story.dart';
import 'package:social_app/package/comment_tree/comment_tree.dart';

import '../widget/facebook_card_story_widget.dart';

class HomeDashBoardView extends StatefulWidget {
  HomeDashBoardView({Key? key}) : super(key: key);

  @override
  _HomeDashBoardViewState createState() => _HomeDashBoardViewState();
}

bool visible = false;

class _HomeDashBoardViewState extends State<HomeDashBoardView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadData() {
    Helper.readFileJson('assets/json/FacebookPost.json');
  }

  List<ModelStory> story_list = [
    ModelStory(image_Path: "assets/images/photo.jpg", user_name: "Add a story", profile_path: "assets/images/photo.jpg"),
    ModelStory(image_Path: "assets/images/china.jpg", user_name: "Wung Chang", profile_path: "assets/images/china.jpg"),
    ModelStory(image_Path: "assets/images/sunset.jpg", user_name: "Jakal", profile_path: "assets/images/sunset.jpg"),
    ModelStory(image_Path: "assets/images/pexel.jpeg", user_name: "Jakal", profile_path: "assets/images/pexel.jpeg")
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _buildInputStory(context),
        _buildListCardStory(),
        FutureBuilder(
            future: Helper.readFileJson('assets/json/FacebookPost.json'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                return ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, int index) {
                      return FacebookCardPostWidget(
                        image_path: data[index]['media_path'],
                        date: data[index]['date_posted'],
                        description: data[index]['title'],
                        reactions: data[index]['people_reacted'],
                        nums: data[index]['no_of_reactions'],
                        user_name: data[index]['user_name'],
                        profile_path: data[index]['profile_image'],
                        child: Builder(builder: (context) {
                          Widget contentComment(dynamic data) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'userName',
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          '${data.content}',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  DefaultTextStyle(
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 5),
                                          Text('33p', style: Theme.of(context).textTheme.bodySmall!),
                                          SizedBox(width: 24),
                                          Text('Like'),
                                          SizedBox(width: 24),
                                          Text('Reply'),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: CommentTreeWidget<Comment, Comment>(
                              root: Comment(avatar: 'null', userName: 'null', content: 'felangel made felangel/cubit_and_beyond public '),
                              replies: [
                                Comment(avatar: 'null', userName: 'null', content: 'A Dart template generator which helps teams'),
                                Comment(
                                    avatar: 'null',
                                    userName: 'null',
                                    content: 'A Dart template generator which helps teams generator which helps teams generator which helps teams'),
                                Comment(avatar: 'null', userName: 'null', content: 'A Dart template generator which helps teams'),
                                Comment(
                                    avatar: 'null',
                                    userName: 'null',
                                    content: 'A Dart template generator which helps teams generator which helps teams '),
                              ],
                              treeThemeData: TreeThemeData(lineColor: Colors.green[500]!, lineWidth: 1),
                              avatarRoot: (context, data) => PreferredSize(
                                child: CircleAvatarWidget(radius: 20),
                                preferredSize: Size.fromRadius(20),
                              ),
                              avatarChild: (context, data) => PreferredSize(
                                child: CircleAvatarWidget(radius: 14),
                                preferredSize: Size.fromRadius(14),
                              ),
                              contentRoot: (context, data) {
                                return contentComment(data);
                              },
                              contentChild: (context, data) {
                                return contentComment(data);
                              },
                            ),
                          );
                        }),
                        // child: Column(
                        //   children: <Widget>[
                        //     FacebookCardCommentWidget(
                        //         comment_username: data[index]['comments'][0]['cuser_name'],
                        //         comment_profile_pic: data[index]['comments'][0]['cprofile_image'],
                        //         comment_text: data[index]['comments'][0]['ctitle']),
                        //     FacebookCardCommentWidget(
                        //         comment_username: data[index]['comments'][1]['cuser_name'],
                        //         comment_profile_pic: data[index]['comments'][1]['cprofile_image'],
                        //         comment_text: data[index]['comments'][1]['ctitle']),
                        //   ],
                        // ),
                        // comment_visible: data[index]['comments_visible'],
                      );
                    });
              }
              return Center(child: CircularProgressIndicator());
            })
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
            separatorBuilder: (context, index) => SizedBox(width: 5),
            itemBuilder: (context, int index) {
              return FacebookCardStory(
                  avatarImage: story_list[index].profile_path,
                  backgroundImage: story_list[index].image_Path,
                  showAddButton: index == 0 ? visible = true : false,
                  user_name: index == 0 ? "Tạo tin của bạn" : story_list[index].user_name);
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
              Padding(
                padding: const EdgeInsets.all(10),
                child: CircleAvatarWidget(radius: 25),
              ),
              Expanded(
                child: OutlinedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(AnimatedRoute(CreatePostView()));
                    },
                    child: Text("Bạn đang nghĩ gì ?", style: TextStyle(color: Colors.black)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      alignment: Alignment.centerLeft,
                    )),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.photo_library_outlined, color: Colors.green))
            ],
          ),
        ],
      ),
    );
  }
}

class Comment {
  // ignore: constant_identifier_names
  static const TAG = 'Comment';

  String? avatar;
  String? userName;
  String? content;

  Comment({
    required this.avatar,
    required this.userName,
    required this.content,
  });
}
