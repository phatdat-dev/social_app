import 'package:dio/dio.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/modules/home/controllers/base_fetch_controller.dart';

class PostController extends BaseController with BaseFetchController {
  @override
  String get apiUrl => ApiUrl.get_fetchPost();

  @override
  Future<void> onInitData() async {}

  Future<void> call_createPostData({
    required String content,
    required int privacy,
    int? groupId,
    List<String>? filesPath,
    List<String>? images, //image url https not file
  }) async {
    final formData = FormData.fromMap({
      'postContent': content,
      'privacy': privacy,
      'groupId': groupId,
      'files[]': filesPath?.map((path) => MultipartFile.fromFileSync(path)).toList(),
      'images': null,
    });

    await apiCall.onRequest(
      ApiUrl.post_createPostt(),
      RequestMethod.POST,
      body: formData,
    );
  }

  Future<void> call_likePost(int postId) async {
    await apiCall.onRequest(ApiUrl.post_likePost(), RequestMethod.POST, body: {'postId': postId}, isShowLoading: false);
  }
}
