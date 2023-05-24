// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:social_app/app/core/base/base_connect.dart';

abstract class BaseController extends GetxController {
  BaseConnect get apiCall => Get.find<BaseConnect>();

  Future<void> onInitData();

  @override
  void onInit() {
    super.onInit();
    onInitData();
  }
}
