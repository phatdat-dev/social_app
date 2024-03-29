import 'dart:io';

import 'package:ckc_social_app/app/core/base/base_project.dart';
import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/modules/home/controllers/base_fetch_controller.dart';
import 'package:get/get.dart';

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

  Future<void> call_sharePost({
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

  Future<void> call_createPostData({
    required String content,
    required int privacy,
    int? groupId,
    List<String>? filesPath,
    List<String>? images, //image url https not file
    List<int>? tagsUserId,
    int? feelActivityId,
  }) async {
    final formData = FormData({
      'postContent': content,
      'privacy': privacy,
      'groupId': groupId,
      'files[]': filesPath?.map((path) => MultipartFile(File(path), filename: path)).toList(),
      'images': null,
      'tags[]': tagsUserId,
      'feelActivityId': feelActivityId,
    });

    await apiCall.onRequest(
      ApiUrl.post_createPost(),
      RequestMethod.POST,
      body: formData,
    );

    //refresh data
    call_fetchData();
  }

  //lúc tạo thì field khác, lúc edit thì field khác, api sida quá nên phải viết 2 hàm cho rõ nghĩa
  //không là có thể gộp lại (nếu có id thì update/không thì tạo)
  Future<void> call_updatePostData({
    required int postId,
    required String content,
    required int privacy,
    List<String>? filesPath,
    List<int>? removeFile,
  }) async {
    final formData = FormData({
      'postId': postId,
      'contentPost': content,
      'privacy': privacy,
      'files[]': filesPath?.map((path) => MultipartFile(File(path), filename: path)).toList(),
      'removeFile[]': removeFile,
    });

    await apiCall.onRequest(
      ApiUrl.post_updatePost(),
      RequestMethod.POST,
      body: formData,
    );
  }

  Future<void> call_deletePostData(int postId) async {
    await apiCall.onRequest(ApiUrl.post_deletePost(), RequestMethod.POST, body: {'postId': postId});
  }

  Future<void> call_likePost(int postId, [int reactionId = 1]) async {
    await apiCall.onRequest(ApiUrl.post_likePost(), RequestMethod.POST, body: {'postId': postId, 'reaction': reactionId}, isShowLoading: false);
  }

  Future<List<Map<String, dynamic>>> call_fetchCommentByPost(int postId) async {
    final result = await apiCall.onRequest(ApiUrl.get_fetchCommentByPost(postId), RequestMethod.GET);

    return Helper.convertToListMap(result);
  }

  Future<void> call_createCommentPost(int postId, String content, List<String> filesPath) async {
    final formData = FormData({
      'postId': postId,
      'commentContent': content,
      if (filesPath.isNotEmpty) 'file': MultipartFile(File(filesPath.first), filename: filesPath.first),
    });

    await apiCall.onRequest(ApiUrl.post_createCommentPost(), RequestMethod.POST, body: formData);
  }

  Future<void> call_replyComment(int postId, int commentId, String content, List<String> filesPath) async {
    final formData = FormData({
      'postId': postId,
      'commentId': commentId,
      'commentContent': content,
      if (filesPath.isNotEmpty) 'file': MultipartFile(File(filesPath.first), filename: filesPath.first),
    });

    await apiCall.onRequest(ApiUrl.post_replyComment(), RequestMethod.POST, body: formData);
  }

  Future<List<Map<String, dynamic>>> call_fetchReplyComment(int commentId) async {
    final result = await apiCall.onRequest(ApiUrl.get_fetchReplyComment(commentId), RequestMethod.GET);
    return Helper.convertToListMap(result);
  }

  Future<List<Map<String, dynamic>>> call_fetchHistoryEditPost(int postId) async {
    final result = await apiCall.onRequest(ApiUrl.get_fetchHistoryEditPost(postId), RequestMethod.GET);
    return Helper.convertToListMap(result);
  }

  Future<Map<String, dynamic>> call_fetchPostById(int postId) async {
    return await apiCall.onRequest(ApiUrl.get_fetchPostById(postId), RequestMethod.GET, isShowLoading: false);
  }

  Future<List<Map<String, dynamic>>> call_fetchFellAndActivityPosts() async {
    final result = await apiCall.onRequest(ApiUrl.get_fetchFellAndActivityPosts(), RequestMethod.GET);
    return Helper.convertToListMap(result);
  }

  Future<void> call_createReportPost(int type, int postId, String content) async {
    await apiCall.onRequest(ApiUrl.post_createReport(), RequestMethod.POST, body: {
      'objectType': type,
      'objectId': postId,
      'contentReport': content,
    });
  }
}
