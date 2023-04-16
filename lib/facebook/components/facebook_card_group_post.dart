import 'package:flutter/material.dart';

class FacebookCardGroupPost extends StatelessWidget {
  final String profile_image;
  final String username;
  final String group_name;
  final String date_posted;
  final String description;
  final String media_path;
  final String total_reations;
  final String reaction_text;

  FacebookCardGroupPost(
      {required this.profile_image,
      required this.username,
      required this.group_name,
      required this.date_posted,
      required this.media_path,
      required this.total_reations,
      required this.reaction_text,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey, shape: BoxShape.circle, image: DecorationImage(image: AssetImage(profile_image), fit: BoxFit.fill)),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      username,
                                    ),
                                  ),
                                  Icon(
                                    Icons.home,
                                    color: Colors.grey,
                                  ),
                                  Expanded(
                                    child: Text(
                                      group_name,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  date_posted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                description,
              ),
            ),
            Container(
              height: 300,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage(media_path), fit: BoxFit.cover)),
            ),
            Container(
              height: 50,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: SizedBox(
                        width: double.infinity,
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, right: 8.0),
                        child: Text(
                          total_reations,
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      left: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 12.0),
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              image: DecorationImage(image: AssetImage('assets/emoji/emoji1.png'), fit: BoxFit.cover)),
                        ),
                      )),
                  Positioned(
                      left: 15,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 12.0),
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              image: DecorationImage(image: AssetImage('assets/emoji/emoji.jpg'), fit: BoxFit.cover)),
                        ),
                      )),
                  Positioned(
                      left: 28,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 12.0),
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              image: DecorationImage(image: AssetImage('assets/emoji/emoji2.png'), fit: BoxFit.cover)),
                        ),
                      )),
                  Positioned(
                      left: 65,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 15.0),
                          child: Text(
                            reaction_text,
                            style: TextStyle(fontSize: 13),
                          ))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1.0, left: 8.0, right: 8.0),
              child: Container(
                color: Colors.grey,
                height: 1,
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.thumb_down,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {}),
                          Text(
                            "Like",
                            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey[600]),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.home,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {}),
                          Text(
                            "Comment",
                            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey[600]),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.share_outlined,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {}),
                          Text(
                            "Share",
                            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey[600]),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
