import 'package:flutter/material.dart';
import 'package:social_app/facebook/components/facebook_button_group.dart';

class FacebookScreenPages extends StatefulWidget {
  @override
  _FacebookScreenPagesState createState() => _FacebookScreenPagesState();
}

class _FacebookScreenPagesState extends State<FacebookScreenPages> {
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
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Pages",
              style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                FacebookButtonGroup(onPress: () {}, icon: Icons.add_circle_outline, text: "Create"),
                FacebookButtonGroup(onPress: () {}, icon: Icons.home, text: "Discover"),
                FacebookButtonGroup(onPress: () {}, icon: Icons.home, text: "Discover"),
                FacebookButtonGroup(onPress: () {}, icon: Icons.home, text: "Liked Pades"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Your Pages",
              style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle, border: Border.all(color: Colors.grey, width: 1)),
                    child: Center(
                      child: Text(
                        "C",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Column(children: <Widget>[
                  Text("Cool Teens",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(),
                  )
                ])
              ],
            ),
          ),
        ],
      ),
    );
  }
}
