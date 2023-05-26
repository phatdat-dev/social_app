import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/custom/other/animated_route_custom.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/home/views/create_post_view.dart';
import 'package:social_app/app/routes/app_pages.dart';

import '../../../core/utils/utils.dart';

class InputStoryWidget extends StatelessWidget {
  const InputStoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      // width: double.infinity,
      // color: Theme.of(context).colorScheme.inversePrimary,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () => Get.toNamed(Routes.USER('${AuthenticationController.userAccount!.id!}')),
                  child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        AuthenticationController.userAccount!.avatar!,
                      )),
                ),
              ),
              Expanded(
                child: OutlinedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(AnimatedRouteCustom(CreatePostView()));
                    },
                    child: Text(
                      LocaleKeys.WhatOnYourMind.tr,
                      style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      alignment: Alignment.centerLeft,
                    )),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.photo_library_outlined, color: Colors.green))
            ],
          ),
        ],
      ),
    );
  }
}
