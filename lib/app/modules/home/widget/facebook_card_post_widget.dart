import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/package/comment_tree/comment_tree.dart';
import 'package:video_player/video_player.dart';

class FacebookCardPostWidget extends StatelessWidget {
  final Map<String, dynamic> postResponseModel;

  FacebookCardPostWidget(this.postResponseModel);

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isExpandedNotifier = ValueNotifier(false);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildHeaderPost(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Text.rich(TextSpan(
              children: [
                TextSpan(text: postResponseModel['postContent']),
                TextSpan(text: '\n#hasTag', style: TextStyle(color: Colors.blue.shade700)),
              ],
              style: const TextStyle(fontSize: 16),
            )),
          ),
          _buildMediaPost(context),
          _buildNumbericLikeComment(context),
          const Divider(
            height: 0, //height spacing of divider
            thickness: 1, //thickness of divier line
            indent: 10,
            endIndent: 10,
          ),
          _buildButtonBar(isExpandedNotifier),
          ValueListenableBuilder(
              valueListenable: isExpandedNotifier,
              builder: (context, value, child) => AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    firstChild: const SizedBox.shrink(),
                    secondChild: _buildComment(context),
                    crossFadeState: value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  )),
        ],
      ),
    );
  }

  Row _buildButtonBar(ValueNotifier<bool> isExpandedNotifier) {
    bool like = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: StatefulBuilder(
              builder: (context, setState) => TextButton.icon(
                    onPressed: () {
                      setState(() {
                        like = !like;
                      });
                    },
                    icon: like
                        ? const Icon(
                            MdiIcons.thumbUp,
                            color: Colors.blue,
                          )
                        : const Icon(
                            MdiIcons.thumbUpOutline,
                            color: Colors.grey,
                          ),
                    label: Text(
                      'Like',
                      style: TextStyle(color: like ? Colors.blue : Colors.grey),
                    ),
                  )),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              isExpandedNotifier.value = !isExpandedNotifier.value;
            },
            icon: const Icon(
              MdiIcons.commentOutline,
              color: Colors.grey,
            ),
            label: const Text(
              'Comment',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              MdiIcons.shareOutline,
              color: Colors.grey,
            ),
            label: const Text(
              'Share',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumbericLikeComment(BuildContext context) {
    Widget circleIcon(String image) {
      return Container(
        margin: const EdgeInsets.only(left: 8.0, top: 12.0),
        height: 20,
        width: 20,
        decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
      );
    }

    return Container(
      height: 50,
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 8.0),
                child: Text(
                  '${postResponseModel['totalComment']} · ${postResponseModel['totalShare']}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          Positioned(
            left: 2,
            child: circleIcon('assets/emoji/emoji1.png'),
          ),
          Positioned(
            left: 15,
            child: circleIcon('assets/emoji/emoji.jpg'),
          ),
          Positioned(
            left: 28,
            child: circleIcon('assets/emoji/emoji2.png'),
          ),
          Positioned(
              left: 65,
              child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 15.0),
                  child: Text(
                    '${postResponseModel['totalLike']} likes',
                    style: Theme.of(context).textTheme.bodySmall,
                  ))),
        ],
      ),
    );
  }

  Padding _buildHeaderPost(BuildContext context) {
    final bool isUserPost = Random().nextBool();

    Container _buildAvatarGroup() {
      return Container(
        width: 55,
        height: 55,
        child: Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(postResponseModel['avatarUser']!),
                    fit: BoxFit.cover,
                  )),
            ),
            const Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(radius: 15),
            )
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //neu bai viet nam` trong nhom' thi` co' hinh` cua nhom'+ hinh` cua nguoi` dang
          isUserPost
              ? CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(postResponseModel['avatarUser']!),
                )
              : _buildAvatarGroup(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 5),
                  Text(
                    postResponseModel['displayName']!,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text.rich(TextSpan(children: [
                    if (!isUserPost)
                      TextSpan(
                          text: '${postResponseModel['displayName']}  · ',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
                    TextSpan(text: '${postResponseModel['createdAt']} · ☘', style: Theme.of(context).textTheme.bodySmall),
                  ])),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPost(BuildContext context) {
    Widget buildImage(String url) {
      return url.contains('http')
          ? FadeInImage.assetNetwork(
              placeholder: 'assets/images/Img_error.png',
              image: url,
              width: double.infinity,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 200),
              fadeOutDuration: const Duration(milliseconds: 180),
              // height: 300,
            )
          : Image.asset(
              url,
              fit: BoxFit.cover,
              width: double.infinity,
            );
    }

    Widget buildVideo(String url) {
      VideoPlayerController videoPlayerController =
          VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
      return Stack(
        children: [
          FutureBuilder(
            future: videoPlayerController.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
          //play button
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Material(
                elevation: 1,
                shape: const CircleBorder(),
                child: StatefulBuilder(
                  builder: (context, setState) => IconButton(
                    icon: Icon(videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () {
                      setState(() {
                        videoPlayerController.value.isPlaying ? videoPlayerController.pause() : videoPlayerController.play();
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget buildMedia(String url) {
      final bool isImageFile = url.isImageFileName;
      final bool isVideoFile = url.isVideoFileName;
      if (isImageFile) return buildImage(url);
      if (isVideoFile) return buildVideo(url);
      return const SizedBox.shrink();
    }

    final List<Map<String, dynamic>> listMedia = Helper.convertToListMap(postResponseModel['mediafile'] ?? []);

    if (listMedia.isEmpty) return const SizedBox.shrink();

    if (listMedia.length == 1) return buildMedia(listMedia.first['media_file_name']!);

    if (listMedia.length == 2) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildMedia(listMedia.first['media_file_name']!),
          buildMedia(listMedia.last['media_file_name']!),
        ],
      );
    }

//imageUrl.length >= 3
    else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildMedia(listMedia.first['media_file_name']!),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 150,
                  child: buildMedia(listMedia[1]['media_file_name']!),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 150,
                      child: buildMedia(listMedia[2]['media_file_name']!),
                    ),
                    Container(
                      height: 150,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          child: Text('+${listMedia.length - 2}'),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildComment(BuildContext context) {
    Widget contentComment(dynamic data) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'userName',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${data.content}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    const SizedBox(width: 5),
                    Text('33p', style: Theme.of(context).textTheme.bodySmall!),
                    const SizedBox(width: 24),
                    const Text('Like'),
                    const SizedBox(width: 24),
                    const Text('Reply'),
                  ],
                ),
              ),
            )
          ],
        );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CommentTreeWidget<Comment, Comment>(
        root: Comment(avatar: 'null', userName: 'null', content: 'felangel made felangel/cubit_and_beyond public '),
        replies: [
          Comment(avatar: 'null', userName: 'null', content: 'A Dart template generator which helps teams'),
          Comment(
              avatar: 'null',
              userName: 'null',
              content: 'A Dart template generator which helps teams generator which helps teams generator which helps teams'),
          Comment(avatar: 'null', userName: 'null', content: 'A Dart template generator which helps teams'),
          Comment(avatar: 'null', userName: 'null', content: 'A Dart template generator which helps teams generator which helps teams '),
        ],
        treeThemeData: TreeThemeData(lineColor: Colors.green[500]!, lineWidth: 1),
        avatarRoot: (context, data) => const PreferredSize(
          child: CircleAvatar(radius: 20),
          preferredSize: Size.fromRadius(20),
        ),
        avatarChild: (context, data) => const PreferredSize(
          child: CircleAvatar(radius: 14),
          preferredSize: Size.fromRadius(14),
        ),
        contentRoot: (context, data) {
          return contentComment(data);
        },
        contentChild: (context, data) {
          return contentComment(data);
        },
      ),
    );
  }
}

class Comment {
  // ignore: constant_identifier_names
  static const TAG = 'Comment';

  String? avatar;
  String? userName;
  String? content;

  Comment({
    required this.avatar,
    required this.userName,
    required this.content,
  });
}
