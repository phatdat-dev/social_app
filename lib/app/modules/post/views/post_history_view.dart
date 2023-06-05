import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/modules/post/controllers/post_controller.dart';
import 'package:social_app/generated/locales.g.dart';

import '../widget/facebook_card_post_widget.dart';

class PostHistoryView extends GetView<PostController> {
  const PostHistoryView({super.key, required this.postId});
  final int postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.PostEditHistory.tr)),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder(
            future: controller.call_fetchHistoryEditPost(postId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final state = snapshot.data!;
                return ListView.builder(
                  itemCount: state.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, int index) => FacebookCardPostWidget(state[index], isShowcontentOnly: true),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
