import 'package:flutter/material.dart';

class FacebookCardStory extends StatelessWidget {
  final String avatarImage;
  final String backgroundImage;
  final VoidCallback? onPressAdd;
  final String user_name;

  FacebookCardStory({
    required this.avatarImage,
    required this.backgroundImage,
    this.onPressAdd,
    required this.user_name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: 100,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(image: NetworkImage(backgroundImage), fit: BoxFit.cover),
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
                        image: DecorationImage(image: NetworkImage(avatarImage), fit: BoxFit.cover)),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    user_name,
                    style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: onPressAdd != null,
              child: Padding(
                padding: const EdgeInsets.all(3.5),
                child: RawMaterialButton(
                  onPressed: onPressAdd,
                  shape: const CircleBorder(),
                  fillColor: Colors.white,
                  constraints: const BoxConstraints.tightFor(width: 42.0, height: 42.0),
                  child: const Icon(
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
