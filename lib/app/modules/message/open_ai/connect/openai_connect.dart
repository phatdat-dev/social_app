import 'dart:async';

import 'package:get/get_connect/http/src/request/request.dart';

import '../../../../core/base/base_connect.dart';
import '../../../../core/utils/utils.dart';
import '../../../../custom/widget/loadding_widget.dart';

//https://beta.openai.com/docs/api-reference/completions
class OpenAiConnect extends BaseConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'https://api.openai.com/v1';
    httpClient.timeout = Duration(seconds: timeOutSecond);
    // httpClient.addAuthenticator(authInterceptor);
    httpClient.addRequestModifier(requestInterceptor);
    httpClient.addResponseModifier(responseInterceptor);
  }

  @override
  FutureOr<Request> requestInterceptor(Request request) async {
    request.headers['Authorization'] = 'Bearer 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'; //3 tháng xài

    request.headers['Accept'] = 'application/json, text/plain, */*';
    request.headers['Charset'] = 'utf-8';
    request.headers['Access-Control-Allow-Origin'] = '*';

    if (isShowLoading) Loadding.show();
    Printt.yellow('${request.method}:  ${request.url.toString()}                           ------------request');
    return request;
  }
}
