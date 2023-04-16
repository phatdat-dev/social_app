import 'package:flutter/material.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/widget/app_bar_icon.dart';
import 'package:social_app/facebook/components/facebook_card_videos.dart';

class FacebookScreenVideos extends StatefulWidget {
  @override
  _FacebookScreenVideosState createState() => _FacebookScreenVideosState();
}

class _FacebookScreenVideosState extends State<FacebookScreenVideos> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        "Videos",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.black),
                      )),
                      AppBarIcon(iconData: Icons.person, onTap: () {}),
                      AppBarIcon(iconData: Icons.search, onTap: () {}),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey,
              ),
              Container(
                height: 50,
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Your Watchlist",
                            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                        top: 10,
                        left: 280,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              image: DecorationImage(image: AssetImage('assets/images/photo.jpg'), fit: BoxFit.cover)),
                        )),
                    Positioned(
                        top: 10,
                        left: 300,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              image: DecorationImage(image: AssetImage('assets/images/china.jpg'), fit: BoxFit.cover)),
                        )),
                    Positioned(
                        top: 10,
                        left: 320,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              image: DecorationImage(image: AssetImage('assets/images/car1.jpg'), fit: BoxFit.cover)),
                        )),
                  ],
                ),
              ),
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
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, int index) {
                          return FacebookCardVideos(
                              profile_image: data[index]['profile_image'],
                              user_name: data[index]['user_name'],
                              post_date: data[index]['date_posted'],
                              description: data[index]['title'],
                              post_des: data[index]['title'],
                              media_path: data[index]['media_path'],
                              num_reactions: data[index]['no_of_reactions'],
                              text_reaction: data[index]['people_reacted']);
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
