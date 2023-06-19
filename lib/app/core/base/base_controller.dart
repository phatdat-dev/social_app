// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:get/get.dart';
import 'package:ckc_social_app/app/core/base/base_connect.dart';

abstract class BaseController extends GetxController {
  BaseConnect get apiCall => Get.find<BaseConnect>();

  Future<void> onInitData();

  @override
  void onInit() {
    super.onInit();
    onInitData();
  }
}

//? Base DataType for State --------------------------------------------

class MapDataState extends DataState<Map<String, dynamic>> {
  MapDataState(super.val);
}

class ListMapDataState extends DataState<List<Map<String, dynamic>>> {
  ListMapDataState(super.val);
}

//? đừng quan tâm đến cái này
class DataState<T> extends Value<T> {
  DataState(super.val);

  void run(Future<T> body, {String? errorMessage}) => append(() => () => body, errorMessage: errorMessage);

  @override
  String toJson() => jsonEncode(value);

  //remove @protected
  @override
  void change(T? newState, {RxStatus? status}) => super.change(newState, status: status);
}
