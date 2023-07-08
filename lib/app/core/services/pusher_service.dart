import 'package:get/get.dart';
import 'package:pusher_client/pusher_client.dart';

import '../../modules/authentication/controllers/authentication_controller.dart';
import 'firebase_service.dart';

typedef PusherEventCallBack = void Function(PusherEvent? event);

class PusherService extends GetxService {
  //constants
  final String PUSHER_APP_ID = '1612731';
  final String PUSHER_APP_KEY = '4eea52e19a1b86509eb3';
  final String PUSHER_APP_SECRET = '0346f6c3041e02ee5a93';
  final String PUSHER_APP_CLUSTER = 'mt1';
//
  final Map<String, Set<String>> currentSubscribeChannel = {};
//
  late final PusherClient pusher;
  late final PusherOptions options;

//
  @override
  void onInit() {
    super.onInit();
    options = PusherOptions(
      // host: 'example.com',
      // wsPort: 6001,
      cluster: 'ap1',
      encrypted: true,
      auth: PusherAuth(
        Get.find<FireBaseService>().getBaseURLServer(),
        headers: {
          'Authorization': 'Bearer ${AuthenticationController.userAccount?.token}',
        },
      ),
    );

    pusher = PusherClient(PUSHER_APP_KEY, options);
  }

  void subscribeChannel({
    required String channalName,
    required String bindEventName,
    required PusherEventCallBack onEvent,
  }) {
    Channel channel = pusher.subscribe(channalName);
    channel.bind(bindEventName, onEvent);
    //
    currentSubscribeChannel.update(channalName, (value) => value..add(bindEventName), ifAbsent: () => {bindEventName});
  }
}
