import 'dart:ui';

import 'package:ckc_social_app/app/modules/stories/controllers/stories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoriesView extends GetView<StoriesController> {
  const StoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.currentObject!.data['displayName']),
      ),
      body: SafeArea(
        child: PageView.builder(
          itemCount: (controller.currentObject!.data['stories'] as List).length,
          itemBuilder: (context, index) {
            final item = (controller.currentObject!.data['stories'] as List)[index];
            return Stack(children: [
              //Blur Image
              //https://protocoderspoint.com/image-blur-background-flutter/
              SizedBox.expand(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 50,
                    sigmaY: 50,
                  ),
                  child: Image.network(
                    item['file_name_story'],
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              InteractiveViewer(
                maxScale: 10,
                child: Center(
                  child: Image.network(
                    item['file_name_story'],
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
