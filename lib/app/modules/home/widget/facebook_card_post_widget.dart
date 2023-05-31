import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_app/app/core/services/cloud_translation_service.dart';
import 'package:social_app/app/core/services/social_share_service.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/authentication/views/authentication_view.dart';
import 'package:social_app/app/modules/home/controllers/post_controller.dart';
import 'package:social_app/app/modules/home/views/create_post_view.dart';
import 'package:social_app/app/modules/home/widget/comment_widget.dart';
import 'package:video_player/video_player.dart';

import '../../../routes/app_pages.dart';

// ignore: must_be_immutable
class FacebookCardPostWidget extends StatelessWidget {
  final Map<String, dynamic> postResponseModel;
  late bool? isGroupPost;

  FacebookCardPostWidget(this.postResponseModel, {this.isGroupPost}) {
    if (isGroupPost == null) {
      isGroupPost = postResponseModel['group_id'] != null;
    }
  }

  void showBottomSheetSharePost(BuildContext context) {
    final createPostViewWidget = CreatePostView();
    final postController = Get.find<PostController>();

    showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    createPostViewWidget.buildHeader(),
                    SizedBox(
                      height: 200,
                      child: createPostViewWidget.buildTextField(),
                    ),
                    const Divider(),
                    SizedBox(
                      width: double.infinity,
                      child: AnimatedBuilder(
                        animation: createPostViewWidget.txtController,
                        builder: (context, child) {
                          final bool allowPost = createPostViewWidget.txtController.text.isNotEmpty;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: allowPost ? null : Colors.grey.shade200,
                            ),
                            onPressed: allowPost
                                ? () => postController
                                        .sharePost(
                                      postId: postResponseModel['id'],
                                      content: createPostViewWidget.txtController.text,
                                      privacy: createPostViewWidget.currentPrivacy.value.privacyId!, //get dropdown privacy
                                    )
                                        .then((value) {
                                      HelperWidget.showSnackBar(message: 'Share Success');
                                      Navigator.pop(context);
                                    })
                                : null,
                            child: Text('Đăng', style: TextStyle(color: allowPost ? null : Colors.grey)),
                          );
                        },
                      ),
                    ),
                    const Center(child: OrDivider()),
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: SocialShareType.values.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final item = SocialShareType.values[index];
                          return InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              final socialShare = Get.find<SocialShareService>();
                              socialShare.onShare(
                                type: item,
                                urlShare: 'https://www.youtube.com/watch?v=bWehAFTFc9o', //url this post website
                                text: 'zzzzzzz',
                              );
                            },
                            child: Ink(
                              width: 50,
                              height: 50,
                              decoration: ShapeDecoration(
                                shape: const CircleBorder(),
                                image: DecorationImage(image: NetworkImage(item.icon), fit: BoxFit.cover),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isExpandedNotifier = ValueNotifier(false);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (postResponseModel['parent_post'] == null) ...[
            _buildPostCard(
              context: context,
              isExpandedNotifier: isExpandedNotifier,
              postResponseModel: postResponseModel,
            ),
            ..._buildBottom(context: context, isExpandedNotifier: isExpandedNotifier),
          ]
          //nếu bài viết được chia sẽ và có parent_post
          else ...[
            _buildHeaderPost(context, postResponseModel),
            _buildPostContentString(
              context: context,
              postResponseModel: postResponseModel,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _buildPostCard(
                context: context,
                isExpandedNotifier: isExpandedNotifier,
                postResponseModel: postResponseModel['parent_post'],
              ),
            ),
            ..._buildBottom(context: context, isExpandedNotifier: isExpandedNotifier),
          ]
        ],
      ),
    );
  }

  Widget _buildPostCard({
    required BuildContext context,
    required ValueNotifier<bool> isExpandedNotifier,
    required Map<String, dynamic> postResponseModel,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildHeaderPost(context, postResponseModel),
        _buildPostContentString(
          context: context,
          postResponseModel: postResponseModel,
        ),
        _buildMediaPost(
          context: context,
          postResponseModel: postResponseModel,
        ),
      ],
    );
  }

  List<Widget> _buildBottom({
    required BuildContext context,
    required ValueNotifier<bool> isExpandedNotifier,
  }) {
    return [
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
          builder: (context, value, child) {
            final postController = Get.find<PostController>();
            ValueNotifier<List<Map<String, dynamic>>?> commentsOfPostDataResponse = ValueNotifier(null);

            void loadComment() =>
                postController.call_fetchCommentByPost(postResponseModel['id']).then((value) => commentsOfPostDataResponse.value = value);
            if (value) {
              loadComment();
            }

            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              firstChild: const SizedBox.shrink(),
              secondChild: ValueListenableBuilder(
                  valueListenable: commentsOfPostDataResponse,
                  builder: (context, data, child) {
                    if (data == null) return const Center(child: CircularProgressIndicator());
                    return CommentWidget(
                      data: data,
                      onSendComment: (text) {
                        postController.call_createCommentPost(postResponseModel['id'], text).then((value) {
                          loadComment();
                        });
                      },
                      onReplyComment: (text, comment) {
                        int commentId = comment['id'];
                        if (comment['parent_comment'] != null) commentId = comment['parent_comment'];
                        postController.call_replyComment(postResponseModel['id'], commentId, text).then((value) {
                          loadComment();
                        });
                      },
                    );
                  }),
              crossFadeState: value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            );
          }),
    ];
  }

  Widget _buildPostContentString({required BuildContext context, required Map<String, dynamic> postResponseModel}) => Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text.rich(TextSpan(
            children: [
              TextSpan(text: postResponseModel['post_content']),
              TextSpan(text: '\n#hasTag', style: TextStyle(color: Colors.blue.shade700)),
            ],
            style: const TextStyle(fontSize: 16),
          )),
          GestureDetector(
            onTap: () async {
              final cloudTranslationService = CloudTranslationService();
              final text = await cloudTranslationService.translate(text: postResponseModel['post_content']);
              postResponseModel['post_content'] = text;

              // ignore: invalid_use_of_protected_member
              Get.find<PostController>().refresh();
            },
            child: Text('Translate Text >', style: TextStyle(color: Colors.blue.shade700)),
          ),
        ]),
      );

  Row _buildButtonBar(ValueNotifier<bool> isExpandedNotifier) {
    bool like = postResponseModel['isLike'] ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              final controller = Get.find<PostController>();

              final typeIdMyUserReaction = (postResponseModel['like'] as List)
                  .firstWhereOrNull((userReaction) => userReaction['user_id'] == AuthenticationController.userAccount!.id)?['type'] as int?;

              final listReactions = controller.rectionsGif.entries
                  .mapIndexed(
                    (index, e) => Reaction<int>(
                      value: index + 1,
                      title: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
                        decoration: const ShapeDecoration(shape: StadiumBorder(), color: Colors.pink),
                        child: Text(e.key.tr, style: const TextStyle(color: Colors.white)),
                      ),
                      previewIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
                        child: Image.asset(e.value, height: 40),
                      ),
                      icon: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(e.value, height: 25),
                            const SizedBox(width: 10),
                            Text(
                              e.key.tr,
                              style: TextStyle(color: like ? Colors.blue : Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList();

              return ReactionButtonToggle<int>(
                onReactionChanged: (value, isChecked) {
                  Get.find<PostController>().call_likePost(postResponseModel['id'], value!);
                },
                initialReaction: listReactions[(typeIdMyUserReaction ?? 1) - 1],
                reactions: listReactions,
              );
            },
          ),
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
            label: Text(
              LocaleKeys.Comment.tr,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Expanded(
          child: Builder(
              builder: (context) => TextButton.icon(
                    onPressed: () => showBottomSheetSharePost(context),
                    icon: const Icon(
                      MdiIcons.shareOutline,
                      color: Colors.grey,
                    ),
                    label: Text(
                      LocaleKeys.Share.tr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )),
        ),
      ],
    );
  }

  Widget _buildNumbericLikeComment(BuildContext context) {
    final controller = Get.find<PostController>();

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

    String getAssetRectionsGif(int index) => controller.rectionsGif.entries.elementAt(index - 1).value;

    //return Map<int,List<Map<String,dynamic>>>
    final groupReactions = (postResponseModel['like'] as List).groupListsBy((element) => element['type']);
    // sort by value.length
    final sortValueByLength = groupReactions.entries.sorted((a, b) => b.value.length.compareTo(a.value.length)).take(3).toList();
    final top3ReactionsId = Map.fromEntries(sortValueByLength).keys.take(3);

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
          ...top3ReactionsId
              .mapIndexed((index, e) => Positioned(
                    left: 2 + (index * 13),
                    child: circleIcon(getAssetRectionsGif(e)),
                  ))
              .toList(),
          //
          Positioned(
              left: 65,
              child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 15.0),
                  child: Text(
                    '${postResponseModel['totalLike']}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ))),
        ],
      ),
    );
  }

  Padding _buildHeaderPost(BuildContext context, Map<String, dynamic> postResponseModel) {
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
                    image: NetworkImage(postResponseModel['groupAvatar']!),
                    fit: BoxFit.cover,
                  )),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: InkWell(
                onTap: () => Get.toNamed(Routes.USER("${postResponseModel['user_id']}")),
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(postResponseModel['avatarUser']!),
                ),
              ),
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
          isGroupPost!
              ? _buildAvatarGroup()
              : InkWell(
                  onTap: () => Get.toNamed(Routes.USER("${postResponseModel['user_id']}")),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(postResponseModel['avatarUser']!),
                  ),
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 5),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: (isGroupPost!) ? postResponseModel['groupName'] : postResponseModel['displayName']!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (postResponseModel['parent_post'] != null) const TextSpan(text: ' shared a post')
                  ])),
                  const SizedBox(height: 5),
                  Text.rich(
                    TextSpan(
                      children: [
                        if (isGroupPost!)
                          TextSpan(
                              text: '${postResponseModel['displayName']}  · ',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: '${DateTime.tryParse(postResponseModel['created_at'])?.timeAgoSinceDate()} · ☘',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
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

  Widget _buildMediaPost({
    required BuildContext context,
    required Map<String, dynamic> postResponseModel,
  }) {
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
}
