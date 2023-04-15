// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:social_app/app/core/base/base_connect.dart';
import 'package:social_app/app/core/utils/utils.dart';

abstract class BaseController with ChangeNotifier {
  BaseController() {
    Printt.white("Create Controller: ${runtimeType}");
  }
  final apiCall = BaseConnect.instance;
  GlobalKey key = GlobalKey();

  Future<void> onInitData();
}
