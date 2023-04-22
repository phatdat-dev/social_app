import 'package:flutter/material.dart';

class FacebookCardGroup extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onTapCancel;
  final double padding;
  final String title;
  final String ImagePath;

  FacebookCardGroup({required this.onTap, required this.onTapCancel, required this.padding, required this.title, required this.ImagePath});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedPadding(
          duration: const Duration(seconds: 1),
          padding: EdgeInsets.all(padding),
          child: InkWell(
            splashColor: Colors.grey,
            onTap: onTap,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey, width: 1.5),
                  image: DecorationImage(image: AssetImage(ImagePath), fit: BoxFit.cover)),
            ),
          ),
        ),
        Expanded(
            child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.black),
        )),
      ],
    );
  }
}

enum padding { active, cancel }
