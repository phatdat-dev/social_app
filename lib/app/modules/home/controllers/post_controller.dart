import 'dart:io';

import 'package:get/get.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/modules/home/controllers/base_fetch_controller.dart';

class PostController extends BaseFetchController {
  final Map<String, String> rectionsGif = {
    'Like': 'assets/emoji/1_like.gif',
    'Love': 'assets/emoji/2_love.gif',
    'Sad': 'assets/emoji/3_sad.gif',
    'Haha': 'assets/emoji/4_haha.gif',
    'Yay': 'assets/emoji/5_yay.gif',
    'Wow': 'assets/emoji/6_wow.gif',
    'Angry': 'assets/emoji/7_angry.gif',
  };

  @override
  String get apiUrl => ApiUrl.get_fetchPost();

  Future<void> call_createPostData({
    required String content,
    required int privacy,
    int? groupId,
    List<String>? filesPath,
    List<String>? images, //image url https not file
  }) async {
    final formData = FormData({
      'postContent': content,
      'privacy': privacy,
      'groupId': groupId,
      'files[]': filesPath?.map((path) => MultipartFile(File(path), filename: path)).toList(),
      'images': null,
    });

    await apiCall.onRequest(
      ApiUrl.post_createPostt(),
      RequestMethod.POST,
      body: formData,
    );
  }

  Future<void> call_likePost(int postId, [int reactionId = 1]) async {
    await apiCall.onRequest(ApiUrl.post_likePost(), RequestMethod.POST, body: {'postId': postId, 'reaction': reactionId}, isShowLoading: false);
  }

  Future<void> sharePost({
    required int postId,
    required String content,
    required int privacy,
  }) async {
    await apiCall.onRequest(ApiUrl.post_sharePostToProfile(), RequestMethod.POST, body: {
      'postId': postId,
      'postContent': content,
      'privacy': privacy,
    });
  }

  Future<List<Map<String, dynamic>>> call_fetchCommentByPost(int postId) async {
    final result = await apiCall.onRequest(ApiUrl.post_fetchCommentByPost(), RequestMethod.POST, body: {
      'postId': postId,
    });

    return Helper.convertToListMap(result);
  }

  Future<void> call_createCommentPost(int postId, String content) async {
    await apiCall.onRequest(ApiUrl.post_createCommentPost(), RequestMethod.POST, body: {
      'postId': postId,
      'commentContent': content,
    });
  }

  Future<void> call_replyComment(int postId, int commentId, String content) async {
    await apiCall.onRequest(ApiUrl.post_replyComment(), RequestMethod.POST, body: {
      'postId': postId,
      'commentId': commentId,
      'commentContent': content,
    });
  }
}
