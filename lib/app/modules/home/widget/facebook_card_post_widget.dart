import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_app/app/widget/circle_avatar_widget.dart';

class FacebookCardPostWidget extends StatelessWidget {
  final String image_path;
  final String profile_path;
  final String user_name;
  final String date;
  final String description;
  final String nums;
  final String reactions;
  final Widget? child;

  FacebookCardPostWidget({
    required this.image_path,
    required this.date,
    required this.description,
    required this.nums,
    required this.user_name,
    required this.profile_path,
    required this.reactions,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildHeaderPost(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Text.rich(TextSpan(
              children: [
                TextSpan(text: description),
                TextSpan(text: "\n#hasTag", style: TextStyle(color: Colors.blue.shade700)),
              ],
              style: TextStyle(fontSize: 16),
            )),
          ),
          Image.asset(
            image_path,
            fit: BoxFit.cover,
            width: double.infinity,
            // height: 300,
          ),
          _buildNumbericLikeComment(context),
          Divider(
            height: 0, //height spacing of divider
            thickness: 1, //thickness of divier line
            indent: 10,
            endIndent: 10,
          ),
          _buildButtonBar(),
          child ?? SizedBox.shrink(),
        ],
      ),
    );
  }

  Row _buildButtonBar() {
    bool like = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: StatefulBuilder(
              builder: (context, setState) => TextButton.icon(
                    onPressed: () {
                      setState(() {
                        like = !like;
                      });
                    },
                    icon: like
                        ? Icon(
                            MdiIcons.thumbUp,
                            color: Colors.blue,
                          )
                        : Icon(
                            MdiIcons.thumbUpOutline,
                            color: Colors.grey,
                          ),
                    label: Text(
                      "Like",
                      style: TextStyle(color: like ? Colors.blue : Colors.grey),
                    ),
                  )),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () {},
            icon: Icon(
              MdiIcons.commentOutline,
              color: Colors.grey,
            ),
            label: Text(
              "Comment",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () {},
            icon: Icon(
              MdiIcons.shareOutline,
              color: Colors.grey,
            ),
            label: Text(
              "Share",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumbericLikeComment(BuildContext context) {
    Widget circleIcon(String image) {
      return Container(
        margin: const EdgeInsets.only(left: 8.0, top: 12.0),
        height: 20,
        width: 20,
        decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
      );
    }

    return Container(
      height: 50,
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 8.0),
                child: Text(
                  nums,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          Positioned(
            left: 2,
            child: circleIcon('assets/emoji/emoji1.png'),
          ),
          Positioned(
            left: 15,
            child: circleIcon('assets/emoji/emoji.jpg'),
          ),
          Positioned(
            left: 28,
            child: circleIcon('assets/emoji/emoji2.png'),
          ),
          Positioned(
              left: 65,
              child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 15.0),
                  child: Text(
                    reactions,
                    style: Theme.of(context).textTheme.bodySmall,
                  ))),
        ],
      ),
    );
  }

  Padding _buildHeaderPost(BuildContext context) {
    final bool isUserPost = Random().nextBool();

    Container _buildAvatarGroup() {
      return Container(
        width: 55,
        height: 55,
        child: Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(profile_path),
                    fit: BoxFit.cover,
                  )),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatarWidget(radius: 15),
            )
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //neu bai viet nam` trong nhom' thi` co' hinh` cua nhom'+ hinh` cua nguoi` dang
          isUserPost
              ? CircleAvatarWidget(
                  radius: 25,
                  image: profile_path,
                )
              : _buildAvatarGroup(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 5),
                  Text(
                    user_name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text.rich(TextSpan(children: [
                    if (!isUserPost)
                      TextSpan(text: "UserName  · ", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
                    TextSpan(text: "${date} · ☘", style: Theme.of(context).textTheme.bodySmall),
                  ])),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {},
            icon: Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }
}
