import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:social_app/app/core/constants/global_constant.dart';
import 'package:social_app/app/core/constants/storage_constant.dart';

class TranslationService {
  // fallbackLocale là locale default nếu locale được set không nằm trong những Locale support
  static const fallbackLocale = Locale('en', 'US');
  // các Locale được support
  static const locales = [
    Locale('en', 'US'),
    Locale('vi', 'VN'),
    Locale('ja', 'JP'),
  ];

  // function change language
  static void changeLocale(Locale localeee) {
    Global.navigatorKey.currentContext!.setLocale(localeee);
    Global.sharedPreferences.setString(StorageConstants.langCode, localeee.languageCode);
  }

  static Locale getLocaleFromLanguage() {
    final langCode = Global.sharedPreferences.getString(StorageConstants.langCode);
    final context = Global.navigatorKey.currentContext!;

    if (langCode == null) return context.deviceLocale;

    for (int i = 0; i < locales.length; i++) {
      if (langCode == locales[i].languageCode) return locales[i];
    }

    return context.deviceLocale;
  }
}
