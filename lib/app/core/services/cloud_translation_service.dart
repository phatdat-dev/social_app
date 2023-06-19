import 'dart:async';

import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ckc_social_app/app/core/base/base_connect.dart';
import 'package:ckc_social_app/app/core/utils/utils.dart';

import '../../custom/widget/loadding_widget.dart';

const _projectId = 'myanime-a7b0f';
const _token =
    'ya29.a0AWY7Cklqn-ysVYImFKB_HjAbtt6bzy5cSQgZppovFh-kDI4pZBaDcVnsU_7IVfRdfVbt_iCwxeHMJ7vLN0STk-BrBRDWkl_k9uLJYg1NUjmxbepjPO-Ryky49vh7uIHSu6bIpXl6TbkczatEt4QiyE5cUFy6bYMERb9pFAaCgYKAc0SARASFQG1tDrpVTPb3eoHZWZbJF_Anml_jg0173';

class CloudTranslationService {
  final _apiCall = _CloudTranslationApi();

  Future<String> translate({
    required String text,
    String from = 'en',
    String to = 'vi',
  }) async {
    final response = await _apiCall.onRequest(
      '/language/translate/v2',
      RequestMethod.POST,
      body: {
        'q': text,
        'source': from,
        'target': to,
      },
    );

    return response['data']['translations'][0]['translatedText'];
  }
}

class _CloudTranslationApi extends BaseConnect {
  _CloudTranslationApi() {
    httpClient.baseUrl = 'https://translation.googleapis.com';
    httpClient.timeout = Duration(seconds: timeOutSecond);
    httpClient.addRequestModifier(requestInterceptor);
    httpClient.addResponseModifier(responseInterceptor);
  }

  @override
  void onInit() {}

  @override
  FutureOr<Request> requestInterceptor(Request request) async {
    request.headers['Authorization'] = 'Bearer $_token';

    request.headers['Accept'] = 'application/json, text/plain, */*';
    request.headers['Charset'] = 'utf-8';
    //Thêm cái này mới chạy
    request.headers['x-goog-user-project'] = _projectId;

    // tự động mở loadding khi Request
    if (isShowLoading) Loadding.show();
    Printt.yellow('${request.method}:  ${request.url.toString()}                           ------------request');
    return request;
  }

  @override
  void handleErrorStatus(Response response) {
    final message = 'CODE (${response.statusCode}):\n${response.statusText}';
    HelperWidget.showToast(message);
    Printt.red(message);
  }
}
