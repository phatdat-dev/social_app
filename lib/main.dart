import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/app/core/config/theme_config.dart';
import 'package:social_app/app/core/constants/global_constant.dart';
import 'package:social_app/app/core/services/firebase_service.dart';
import 'package:social_app/app/routes/app_pages.dart';

import 'app/core/base/base_project.dart';
import 'app/core/constants/app_constant.dart';
import 'app/core/services/translation_service.dart';
import 'firebase_options.dart';

// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //if is Mobile
  if (GetPlatform.isMobile) {
    FirebaseMessaging.onBackgroundMessage(NotificationService.firebaseMessagingBackgroundHandler);
  }
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //
  Global.sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
    // systemNavigationBarColor: Colors.blue, // navigation bar color
  ));
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeConfig = ThemeConfig();
    return GetMaterialApp(
      title: 'Social App',
      // tắt cái banner ở appBar
      debugShowCheckedModeBanner: false,
      // luôn show cái log của GetX
      enableLog: true,
      //routing
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(FireBaseService())
          ..notificationServiceInitialize()
          ..remoteConfigServiceInitialize();
        Get.lazyPut(() => BaseConnect(), fenix: true);
      }),
      //theme
      theme: themeConfig.lightTheme,
      darkTheme: themeConfig.dartTheme,
      themeMode: ThemeMode.light,
      //language
      locale: TranslationService.locale, //Get.deviceLocale
      translations: TranslationService(),
      fallbackLocale: TranslationService.fallbackLocale, //Locale('vi', 'VN')
      //ngon ngu he thong'
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
      supportedLocales: TranslationService.locales,
      //

      // builder: EasyLoading.init(),
    );
  }
}
