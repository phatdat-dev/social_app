import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/app/core/config/theme_config.dart';
import 'package:social_app/app/core/constants/global_constant.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/routes/app_pages.dart';

import 'app/core/config/translation_service.dart';

// import 'firebase_options.dart';

part 'multi_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //
  SharedPreferences.getInstance().then((value) => Global.sharedPreferences = value);

  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
    // systemNavigationBarColor: Colors.blue, // navigation bar color
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConfig();

    return EasyLocalization(
      path: 'assets/translations', //
      supportedLocales: TranslationService.locales,
      fallbackLocale: TranslationService.fallbackLocale,
      child: MultiProvider(
        providers: providers,
        builder: (context, child) => MaterialApp.router(
          routerConfig: AppPages.router,
          title: "Title App",
          debugShowCheckedModeBanner: false,
          //theme
          theme: theme.lightTheme,
          darkTheme: theme.dartTheme,
          themeMode: ThemeMode.light,
          //language
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: [
            ...context.localizationDelegates,
            FormBuilderLocalizations.delegate,
          ],
          //
        ),
      ),
    );
  }
}
