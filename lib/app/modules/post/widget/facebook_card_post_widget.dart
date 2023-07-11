// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:ckc_social_app/app/core/services/cloud_translation_service.dart';
import 'package:ckc_social_app/app/core/services/social_share_service.dart';
import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:ckc_social_app/app/modules/authentication/views/authentication_view.dart';
import 'package:ckc_social_app/app/modules/home/widget/comment_widget.dart';
import 'package:ckc_social_app/app/modules/post/controllers/post_controller.dart';
import 'package:ckc_social_app/app/modules/post/views/post_create_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../../core/services/firebase_service.dart';
import '../../../core/services/translation_service.dart';
import '../../../custom/other/tooltip_shapeborder_custom.dart';
import '../../../routes/app_pages.dart';

// ignore: must_be_immutable
class FacebookCardPostWidget extends StatefulWidget {
  Map<String, dynamic> postResponseModel;
  final bool isShowcontentOnly;

  FacebookCardPostWidget(this.postResponseModel, {super.key, this.isShowcontentOnly = false});

  @override
  State<FacebookCardPostWidget> createState() => _FacebookCardPostWidgetState();
}

class _FacebookCardPostWidgetState extends State<FacebookCardPostWidget> {
  final controller = Get.find<PostController>();

  @override
  void initState() {
    super.initState();
  }

  void showBottomSheetSharePost(BuildContext context) {
    final createPostViewWidget = PostCreateView();

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
                                ? () => controller
                                        .call_sharePost(
                                      postId: widget.postResponseModel['id'],
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
                              final urlShare =
                                  "${Get.find<FireBaseService>().getBaseURLWeb()}/posts/view-post-detail/${widget.postResponseModel['id']}";
                              Printt.white(urlShare);
                              socialShare.onShare(
                                type: item,
                                urlShare: urlShare, //url this post website
                                text: '',
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

  void showBottomSheetIsWith(BuildContext context, Map<String, dynamic> postResponseModel) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (context) {
          final listTag = postResponseModel['tag'] as List;
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: context.height / 2,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: listTag.length,
                itemBuilder: (context, index) {
                  final itemUser = listTag.elementAt(index)['user'];
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(Routes.USER("${itemUser['id']}"));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(itemUser['avatar']),
                    ),
                    title: Text(itemUser['displayName']),
                  );
                },
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
          if (widget.postResponseModel['parent_post'] == null) ...[
            _buildPostCard(
              context: context,
              isExpandedNotifier: isExpandedNotifier,
              postResponseModel: widget.postResponseModel,
            ),
            if (widget.isShowcontentOnly == false) ..._buildBottom(context: context, isExpandedNotifier: isExpandedNotifier),
          ]
          //nếu bài viết được chia sẽ và có parent_post
          else ...[
            _buildHeaderPost(context, widget.postResponseModel),
            _buildPostContentString(
              context: context,
              postResponseModel: widget.postResponseModel,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _buildPostCard(
                context: context,
                isExpandedNotifier: isExpandedNotifier,
                postResponseModel: widget.postResponseModel['parent_post'],
              ),
            ),
            if (widget.isShowcontentOnly == false) ..._buildBottom(context: context, isExpandedNotifier: isExpandedNotifier),
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
            ValueNotifier<List<Map<String, dynamic>>?> commentsOfPostDataResponse = ValueNotifier(null);

            void loadComment() =>
                controller.call_fetchCommentByPost(widget.postResponseModel['id']).then((value) => commentsOfPostDataResponse.value = value);
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
                        controller.call_createCommentPost(widget.postResponseModel['id'], text.text, text.files).then((value) {
                          loadComment();
                        });
                      },
                      onReplyComment: (text, comment) {
                        int commentId = comment['id'];
                        if (comment['parent_comment'] != null) commentId = comment['parent_comment'];
                        controller.call_replyComment(widget.postResponseModel['id'], commentId, text.text, text.files).then((value) {
                          loadComment();
                        });
                      },
                      onLoadMoreComment: (comment) async {
                        final result = Helper.convertToListMap(await controller.call_fetchReplyComment(comment['id']));
                        comment['replies'] = result;
                        commentsOfPostDataResponse.notifyListeners();
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
              // TextSpan(text: '\n#hasTag', style: TextStyle(color: Colors.blue.shade700)),
            ],
            style: const TextStyle(fontSize: 16),
          )),
          GestureDetector(
            onTap: () async {
              final cloudTranslationService = CloudTranslationService();
              final text = await cloudTranslationService.translate(
                text: postResponseModel['post_content'],
                to: TranslationService.locale.languageCode,
              );
              postResponseModel['post_content'] = text;

              controller.refresh();
            },
            child: Text('Translate Text >', style: TextStyle(color: Colors.blue.shade700)),
          ),
        ]),
      );

  Row _buildButtonBar(ValueNotifier<bool> isExpandedNotifier) {
    bool like = widget.postResponseModel['isLike'] != null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              final typeIdMyUserReaction = (widget.postResponseModel['like'] as List)
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
                onReactionChanged: (value, isChecked) async {
                  await controller.call_likePost(widget.postResponseModel['id'], value!);
                  final result = await controller.call_fetchPostById(widget.postResponseModel['id']);
                  widget.postResponseModel = result;
                  setState(() {});
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
    final groupReactions = (widget.postResponseModel['like'] as List).groupListsBy((element) => element['type']);
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
                  '${widget.postResponseModel['totalComment']} · ${widget.postResponseModel['totalShare']}',
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
                    '${widget.postResponseModel['totalLike']}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ))),
        ],
      ),
    );
  }

  Padding _buildHeaderPost(BuildContext context, Map<String, dynamic> postResponseModel) {
    bool isGroupPost = postResponseModel['group_id'] != null;

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
                  backgroundImage: NetworkImage(postResponseModel['avatarUser']!), //! api sida
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
          isGroupPost
              ? _buildAvatarGroup()
              : InkWell(
                  onTap: () => Get.toNamed(Routes.USER("${postResponseModel['user_id']}")),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(postResponseModel['avatarUser']!), //! api sida
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
                      text: (isGroupPost) ? postResponseModel['groupName'] : postResponseModel['displayName']!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    //nếu có field Icon thì thêm "Đang cảm thấy...."
                    if (postResponseModel['iconName'] != null) ...[
                      const TextSpan(text: ' đang cảm thấy'),
                      TextSpan(
                        text: ' ${postResponseModel['iconName']}',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                    if ((postResponseModel['tag'] as List?)?.isNotEmpty ?? false)
                      WidgetSpan(
                          child: GestureDetector(
                        onTap: () => showBottomSheetIsWith(context, postResponseModel),
                        child: Text.rich(TextSpan(children: [
                          const TextSpan(text: ' cùng với'),
                          TextSpan(
                            text: ' ${(postResponseModel['tag'] as List).length} người khác',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ])),
                      )),
                    if (postResponseModel['parent_post'] != null) const TextSpan(text: ' shared a post')
                  ])),
                  const SizedBox(height: 5),
                  Text.rich(
                    TextSpan(
                      children: [
                        if (isGroupPost)
                          TextSpan(
                              text: '${postResponseModel['displayName']}  · ',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: '${DateTime.tryParse(postResponseModel['created_at'])?.timeAgoSinceDate()} · ☘',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          if (widget.isShowcontentOnly == false)
            Builder(builder: (context) {
              final Map<
                  String,
                  ({
                    Color? iconColor,
                    Icon icon,
                    VoidCallback onTap,
                  })> builderAction = {
                // LocaleKeys.PrivacyUpdate: (
                //   iconColor: Colors.blue,
                //   icon: const Icon(Icons.privacy_tip_outlined),
                //   onTap: () {},
                // ),
                if (postResponseModel['user_id'] == AuthenticationController.userAccount!.id) ...{
                  LocaleKeys.ViewEditHistory: (
                    iconColor: Colors.green,
                    icon: const Icon(Icons.history_outlined),
                    onTap: () => Get.toNamed(Routes.POST_HISTORY(postResponseModel['id'].toString())),
                  ),
                  LocaleKeys.EditPost: (
                    iconColor: Colors.amber,
                    icon: const Icon(Icons.edit_outlined),
                    onTap: () => Get.toNamed(Routes.POST_CREATE(), arguments: postResponseModel),
                  ),
                  LocaleKeys.DeletePost: (
                    iconColor: Colors.red,
                    icon: const Icon(Icons.delete_outline),
                    onTap: () => controller.call_deletePostData(postResponseModel['id']).then((value) {
                          //off dialog
                          HelperWidget.showSnackBar(message: 'Success');
                          controller.state!.remove(postResponseModel);
                          controller.refresh();
                        }),
                  ),
                } else
                  LocaleKeys.ReportPost: (
                    iconColor: null,
                    icon: const Icon(Icons.report_outlined),
                    onTap: () => Get.toNamed(Routes.POST_REPORT(postResponseModel['id'])),
                  ),
              };
              return PopupMenuButton(
                //vị trí khi show menu
                offset: const Offset(0, 25),
                shape: const TooltipShapeBorderCustom(),
                //xài child + padding để nó nằm ở góc
                padding: EdgeInsets.zero,
                child: const Icon(Icons.more_horiz),
                onSelected: (value) => builderAction[value]!.onTap(),
                itemBuilder: (context) => builderAction.entries
                    .map((e) => PopupMenuItem(
                          padding: EdgeInsets.zero,
                          value: e.key,
                          child: ListTile(
                            iconColor: e.value.iconColor,
                            leading: e.value.icon,
                            title: Text(e.key.tr),
                          ),
                        ))
                    .toList(),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildMediaPost({
    required BuildContext context,
    required Map<String, dynamic> postResponseModel,
  }) {
    final List<Map<String, dynamic>> listMedia = Helper.convertToListMap(postResponseModel['mediafile'] ?? []);

    void showDialogImage() {
      showDialog(
          //barrierDismissible: false,
          context: context,
          builder: (context) => PageView.builder(
                itemCount: listMedia.length,
                itemBuilder: (context, index) {
                  final url = listMedia[index]['media_file_name']!;
                  return Stack(
                    children: [
                      InteractiveViewer(
                        maxScale: 10,
                        child: Center(
                          child: Image.network(
                            url,
                            // fit: BoxFit.fill,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          child: BackButton(),
                        ),
                      ),
                    ],
                  );
                },
              ));
    }

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
      VideoPlayerController videoPlayerController = VideoPlayerController.network(url);
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

    if (listMedia.isEmpty) return const SizedBox.shrink();

    if (listMedia.length == 1) return GestureDetector(onTap: () => showDialogImage(), child: buildMedia(listMedia.first['media_file_name']!));

    if (listMedia.length == 2) {
      return GestureDetector(
        onTap: () => showDialogImage(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildMedia(listMedia.first['media_file_name']!),
            buildMedia(listMedia.last['media_file_name']!),
          ],
        ),
      );
    }

//imageUrl.length >= 3
    else {
      return GestureDetector(
        onTap: () => showDialogImage(),
        child: Column(
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
        ),
      );
    }
  }
}
