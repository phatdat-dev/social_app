import 'package:flutter/material.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/facebook/components/facebook_button_notify.dart';
import 'package:social_app/facebook/components/facebook_card_notification.dart';

import '../../app/widget/app_bar_icon.dart';

class FacebookScreenNotify extends StatefulWidget {
  FacebookScreenNotify({Key? key}) : super(key: key);

  @override
  _FacebookScreenNotifyState createState() => _FacebookScreenNotifyState();
}

class _FacebookScreenNotifyState extends State<FacebookScreenNotify> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      "Notification",
                      style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                    )),
                    AppBarIcon(iconData: Icons.search, onTap: () {}),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "People you May Know",
                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage('assets/images/china.jpg'), fit: BoxFit.cover)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Wung Chang",
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  "15 Mutual friends",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  FacebookButtonNotify(width: 100, text: "Add Friends", color: Colors.blue, tcolor: Colors.white, onPress: () {}),
                                  FacebookButtonNotify(width: 100, text: "Remove", color: Colors.grey, tcolor: Colors.black, onPress: () {})
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              FacebookButtonNotify(width: double.infinity, text: "See All", color: Colors.grey, tcolor: Colors.black, onPress: () {}),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 22, right: 22),
                child: Container(
                  color: Colors.grey,
                  height: 1,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Earlier",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              Center(
                child: Container(
                  height: 500,
                  child: FutureBuilder(
                      future: Helper.readFileJson("assets/json/notification.json"),
                      builder: (context, AsyncSnapshot snapshot) {
                        var mydata = snapshot.data;
                        return ListView.builder(
                            itemCount: mydata == null ? 0 : mydata.length,
                            itemBuilder: (context, int index) {
                              return FacebookCardNotification(
                                color: mydata[index]['status'] == "unread" ? Colors.blue : Colors.white,
                                ImageData: mydata[index]['profile_image'],
                                title: mydata[index]['notification_message'],
                                date: mydata[index]['notification_time'],
                                icon: mydata[index]['notication_type'] == "page" ? 'assets/images/page.jpg' : 'assets/images/fb.png',
                              );
                            });
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
