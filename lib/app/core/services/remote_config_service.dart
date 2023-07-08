part of 'firebase_service.dart';

/// flutter_local_notifications: ^14.0.0+1
mixin RemoteConfigService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> remoteConfigServiceInitialize() async {
    await Future.wait([
      remoteConfig.ensureInitialized(),
      remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      ),
      remoteConfig.fetchAndActivate(),
    ]);

    // Listen for future fetch events.
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();

      // Use the new config values here.
      if (event.updatedKeys.contains('base_url_app')) {
        handleRemoteConfigBaseURL();
      }
    });
  }

  String getBaseURL() => remoteConfig.getString('base_url_app');
  String getOpenAISecretKey() => remoteConfig.getString('OpenAI_Secret_Key');

  void handleRemoteConfigBaseURL() {
    //update lai URL
    Printt.cyan('--NEW BASE URL--');
    Get.find<BaseConnect>().httpClient.baseUrl = getBaseURL();
  }

  Map<String, dynamic> getAgoraTestingKey() => jsonDecode(remoteConfig.getString('Agora_Testing_Key'));
}
