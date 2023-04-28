
import 'package:flutter/material.dart';

class FacebookCardNotification extends StatelessWidget {
  final String ImageData;
  final String title;
  final String date;
  final Color? color;
  final String icon;

  FacebookCardNotification({
    required this.ImageData,
    required this.title,
    required this.date,
    this.color,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          color: Colors.grey, shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(ImageData), fit: BoxFit.cover)),
                    ),
                  ),
                  Positioned.fill(
                    bottom: 10,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.grey, shape: BoxShape.circle, image: DecorationImage(image: AssetImage(icon), fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          title,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          date,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.grey,
                  size: 30,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
