import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Global {
  static late final SharedPreferences sharedPreferences;
  static MaterialColor? colorSchemeSeed = null;
}
