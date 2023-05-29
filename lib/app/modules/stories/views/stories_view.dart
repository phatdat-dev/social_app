import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/modules/stories/controllers/stories_controller.dart';

class StoriesView extends GetView<StoriesController> {
  const StoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.currentObject!.data['userName']),
      ),
      body: SafeArea(
        child: Stack(children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Printt.white('left');
                },
                child: Container(
                  color: Colors.red,
                  width: size.width / 2,
                  // height: size.height,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Printt.white('right');
                },
                child: Container(
                  color: Colors.green,
                  width: size.width / 2,
                  // height: size.height,
                ),
              ),
            ),
          ),
          InteractiveViewer(
            maxScale: 10,
            child: Center(
              child: Image.network(
                controller.currentObject!.data['file_name_story'],
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
