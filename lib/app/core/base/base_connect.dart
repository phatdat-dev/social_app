import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/app/core/base/base_model.dart';
import 'package:social_app/app/core/utils/helper_widget.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/widget/loadding_widget.dart';

import '../constants/app_constant.dart';

enum RequestMethod { GET, POST, PUT, DELETE }

class BaseConnect {
  //create instance
  static final BaseConnect _instance = BaseConnect._internal();
  factory BaseConnect() => _instance;
  static BaseConnect get instance => _instance;

  //create dio
  late final Dio dio;
  int get requestAgainSecond => 10; //neu request loi~ thi` se tu dong goi call api sau khoang thoi gian nao` do'
  int get timeOutSecond => 60;
  bool isShowLoading = true;

  //instance iniit dio
  BaseConnect._internal() {
    dio = Dio(BaseOptions(
      // Cấu hình đường path để call api, thành phần gồm
      // - options.path: đường dẫn cụ thể API. Ví dụ: "user/user-info"
      baseUrl: 'http://192.168.1.4:8080',
      // baseUrl: 'http://116.106.23.233:8080',

      // Đoạn này dùng để config timeout api từ phía client, tránh việc call 1 API
      // bị lỗi trả response quá lâu.
      sendTimeout: Duration(seconds: timeOutSecond),
      // connectTimeout = Duration(seconds: timeOutSecond);
      // receiveTimeout = Duration(seconds: timeOutSecond);

      // Gắn access_token vào header, gửi kèm access_token trong header mỗi khi call API
      headers: {
        // "Authorization": "Bearer ${AuthenticationController.userAccount?.token}", //setup Sau
        'Accept': 'application/json, text/plain, */*',
        // "Content-Type":"application/json;charset=UTF-8",
        'Charset': 'utf-8',
      },

      // contentType: "application/json;charset=UTF-8"
      // headers['Content-Type'] = 'application/json;charset=UTF-8';
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          //debug
          if (isShowLoading) Loadding.show();
          Printt.yellow('${options.method}:  ${options.uri.toString()}                           ------------request');

          //add token
          if (AuthenticationController.userAccount != null) {
            options.headers['Authorization'] = 'Bearer ${AuthenticationController.userAccount?.token}';
          }

          return handler.next(options);
        },
        onResponse: (Response response, handler) {
          Loadding.dismiss();

          return handler.next(response);
        },
        onError: (DioError error, handler) async {
          Loadding.dismiss();
          Printt.red(error.error ?? error.message);
          handleErrorStatus(error.response!);
          return handler.next(error);
        },
      ),
    );
  }

  FutureOr<T> onTimeout<T>() {
    throw TimeoutException(
        'Không có phản hồi từ máy chủ trong ${dio.options.sendTimeout?.inSeconds} giây, yêu cầu có thể đã được gửi đi, xin hãy kiểm tra lại');
  }

  void handleErrorStatus(Response response) {
    switch (response.statusCode) {
      case 400:
      case 404:
      case 500:
        //
        final Map<String, dynamic> errorMessage = response.data!;
        // ignore: prefer_interpolation_to_compose_strings

        String message = '';
        if (errorMessage.containsKey('error') || errorMessage.containsKey('message')) {
          if (errorMessage['error'] is Map) {
            //cho nay` bat' loi~ OpenAI
            message = errorMessage['error']['message'];
          } else {
            message = (errorMessage['message'] ?? errorMessage['error']).toString();
          }
        } else {
          errorMessage.forEach((key, value) {
            if (value is List)
              message += value.join('\n') + '\n';
            else
              message += value.toString();
          });
        }
        HelperWidget.showToast('CODE (${response.statusCode}):\n$message');
        Printt.red(message);
        break;
      case 401:
        //401: Print token expired
        String message = 'CODE (${response.statusCode}):\n${response.statusMessage}';
        HelperWidget.showToast(message);
        Printt.red(message);
        //Remove token
        Global.sharedPreferences.remove(StorageConstants.userAccount);
        AuthenticationController.userAccount = null;
        Global.navigatorKey.currentContext!.go('/authentication');
        break;
      default:
        break;
    }
  }

  // -------------------------

  void onError(Object error) {
    print('has error, request again after ${requestAgainSecond}s ----- \x1B[31m${error.toString()}\x1B[0m');
  }

  Future<dynamic> onRequest<T extends BaseModel>(
    String url,
    RequestMethod method, {
    dynamic body,
    BaseModel<T>? baseModel, //muon tra ve kieu du lieu nao` ?, neu null thi` tra? ve` Response
    Map<String, dynamic>? queryParam,
    bool? isShowLoading,
  }) async {
    try {
      this.isShowLoading = isShowLoading ??= true;

      if (body is List<BaseModel>) {
        //cho no' theo kieu? nhu vay` [{},{},{}...]
        body = body.map((e) => e.toJson()).toList();
      } else if (body != null && body is BaseModel) {
        body = body.toJson();
      }

      //xuat' cai da~ gui~ len sv

      if (body is FormData) {
        Printt.green(jsonEncode(Map.fromEntries(body.fields)));
      } else {
        Printt.green(jsonEncode(body));
      }

      final res = await dio
          .request(
            url,
            data: body,
            options: Options(
              method: method.name,
              // contentType: Headers.jsonContentType,
              // responseType: ResponseType.json,
            ),
            queryParameters: queryParam?.map((key, value) => MapEntry(key, value.toString())),
          )
          .timeout(dio.options.sendTimeout!, onTimeout: onTimeout)
          .then((value) {
        //response
        Printt.magenta(jsonEncode(value.data));

        //decoder
        if (baseModel == null) return value.data; //return Response<dynamic>
        if (value.data is List) return (value.data as List).map((e) => baseModel.fromJson(e)).toList();
        return baseModel.fromJson(value.data);
      });

      return res;
    } on TimeoutException catch (_) {
      HelperWidget.showToast(_.message!);
      // catch timeout here..
    } catch (e) {
      // onError(e);
      //tu dng goi lai api sau khoang thoi gian nao` do'
      // return await Future.delayed(
      //     Duration(seconds: requestAgainSecond),
      //     () => onRequest(
      //           url,
      //           method,
      //           body: body,
      //           baseModel: baseModel,
      //           queryParam: queryParam,
      //           isShowLoading: isShowLoading,
      //         ));
    }
    return null;
  }
}
