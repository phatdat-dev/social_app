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
  }

  String getBaseURL() => remoteConfig.getString('base_url_app');
}
