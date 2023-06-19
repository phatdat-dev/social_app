import 'dart:convert';

import 'package:get/get.dart';
import 'package:ckc_social_app/app/core/services/pusher_service.dart';
import 'package:ckc_social_app/app/modules/authentication/controllers/authentication_controller.dart';

import '../../../core/base/base_project.dart';
import '../../../core/utils/utils.dart';

class NotificationController extends BaseController {
  final listNotification = ListMapDataState([]);

  @override
  Future<void> onInitData() async {
    call_fetchNotification();

    handleNotification();
  }

  Future<void> call_fetchNotification() async {
    listNotification.run(
      apiCall
          .onRequest(
            ApiUrl.get_fetchNotification(),
            RequestMethod.GET,
            isShowLoading: false,
          )
          .then((value) => Helper.convertToListMap(value)),
    );
  }

  void handleNotification() {
    final pusherService = Get.find<PusherService>();
    pusherService.subscribeChannel(
      channalName: 'notif-' + '${AuthenticationController.userAccount!.id!}',
      bindEventName: 'my-event',
      onEvent: (event) {
        // Printt.white(jsonDecode(event!.data!));
        listNotification.update((value) => value!.insert(0, jsonDecode(event!.data!)['notif']));
      },
    );
  }
}
