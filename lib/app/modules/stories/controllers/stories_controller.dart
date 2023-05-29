import 'dart:convert';

import 'package:get/get.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/utils/utils.dart';

import '../../../routes/app_pages.dart';

class StoriesController extends BaseController {
  final listStories = ListMapDataState([]);
  ({int index, Map<String, dynamic> data})? currentObject = null;

  @override
  Future<void> onInitData() async {
    call_fetchStories();
  }

  Future<void> call_fetchStories() async {
    await apiCall
        .onRequest(
      ApiUrl.get_stories(),
      RequestMethod.GET,
      isShowLoading: false,
    )
        .then((value) {
      listStories.change(Helper.convertToListMap(value), status: RxStatus.success());
    });
  }

  void redirectToStoriesView(({int index, Map<String, dynamic> data}) item) {
    currentObject = item;
    Get.toNamed(Routes.STORIES(item.data['id'].toString()));
  }
}

class ListMapDataState extends Value<List<Map<String, dynamic>>> {
  ListMapDataState(super.val);

  @override
  String toJson() => jsonEncode(value);

  //remove @protected
  @override
  void change(List<Map<String, dynamic>>? newState, {RxStatus? status}) => super.change(newState, status: status);
}
