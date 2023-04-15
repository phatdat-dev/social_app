import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Global {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static late final SharedPreferences sharedPreferences;
}
