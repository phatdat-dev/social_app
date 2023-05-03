part of 'firebase_service.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final localNotification = FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel get androidNotifiChannel => const AndroidNotificationChannel(
        'notify_social_app',
        'my_default_notification_channel_id',
        description: 'Cái này là channel mặc định cho app',
        enableLights: true,
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
        //sound: RawResourceAndroidNotificationSound('social_app_notification_sound'),
        // sound: UriAndroidNotificationSound('assets/sound/gmc_notification_sound.mp3')
      );

  Future<void> notificationServiceInitialize() async {
    await _initLocalNotification();

    await _requestPermissionApp();

    getDeviceFirebaseToken();

    firebaseMessagingForegroundHandler();
  }

  Future<void> _initLocalNotification() async {
    // ở android, tạo channel cho notification
    await localNotification
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotifiChannel);
    //

    //setting notification
    final settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      // iOS: DarwinInitializationSettings(),
    );

    //add setting
    localNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) async {
        //bắt sự kiện click vào notification đẩy nó vào stream
        Printt.white('onDidReceiveNotificationResponse ${details.payload}');
      },
      onDidReceiveBackgroundNotificationResponse: (details) {
        Printt.white('onDidReceiveBackgroundNotificationResponse ${details.payload}');
      },
    );
  }

  // gửi yêu cầu đến người dùng cấp quyền cho app
  Future<void> _requestPermissionApp() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
  }

  Future<String?> getDeviceFirebaseToken() async {
    final token = await _messaging.getToken();
    Printt.cyan('TOKEN DEVICE: $token');
    return token;
  }

  Future<void> showNotification({int? id, String? title, String? body, String? payload}) async {
    return localNotification.show(
      id!,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidNotifiChannel.id,
          androidNotifiChannel.name,
          channelDescription: androidNotifiChannel.description,
          enableLights: androidNotifiChannel.enableLights,
          importance: androidNotifiChannel.importance,
          enableVibration: androidNotifiChannel.enableVibration,
          playSound: androidNotifiChannel.playSound,
          priority: Priority.max,
          sound: androidNotifiChannel.sound,
          icon: '@mipmap/ic_launcher',
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ),
        // iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  void firebaseMessagingForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        Printt.white('show notification');
        showNotification(
          id: message.notification?.android.hashCode ?? message.notification?.apple.hashCode ?? 0,
          body: message.data['body'],
          title: message.data['title'],
          payload: message.data['payload'],
        );
      }
    });
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    Printt.white('Handling a background messagee: ${message.messageId}');
  }
}
