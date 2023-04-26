import 'package:dio/dio.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/models/response/post_response_model.dart';

abstract class PostController implements BaseController {
  Map<String, dynamic> request = {
    'page': 1,
  };
  List<PostResponseModel>? postData = null;
  bool postDataIsMaximum = false;

  Future<void> call_fetchPostData() async {
    apiCall
        .onRequest(
      ApiUrl.get_fetchPost(),
      RequestMethod.GET,
      queryParam: request,
      isShowLoading: false,
    )
        .then((value) {
      final data = List.from(value['data']).map((e) => PostResponseModel().fromJson(e)).toList();
      if (postData == null) {
        postData = data;
      } else {
        if (data.isEmpty)
          postDataIsMaximum = true;
        else
          postData = [...postData!, ...data]; //ko xai` .addAll vi` notifyListeners se k rebuild
      }
      notifyListeners();
    });
  }

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
      'files': filesPath?.map((path) => MultipartFile.fromFileSync(path)).toList(),
      'images': null,
    });

    await apiCall.onRequest(
      ApiUrl.post_createPostt(),
      RequestMethod.POST,
      body: formData,
    );
  }
}
