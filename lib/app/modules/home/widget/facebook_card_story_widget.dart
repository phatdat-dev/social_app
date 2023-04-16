import 'package:flutter/material.dart';

class FacebookCardStory extends StatelessWidget {
  final String avatarImage;
  final String backgroundImage;
  final bool showAddButton;
  final String user_name;

  FacebookCardStory({required this.avatarImage, required this.backgroundImage, required this.showAddButton, required this.user_name});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: 100,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 2),
                        image: DecorationImage(image: AssetImage(avatarImage), fit: BoxFit.cover)),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    user_name,
                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: showAddButton,
              child: Padding(
                padding: const EdgeInsets.all(3.5),
                child: RawMaterialButton(
                  onPressed: () {},
                  shape: CircleBorder(),
                  fillColor: Colors.white,
                  constraints: BoxConstraints.tightFor(width: 42.0, height: 42.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
