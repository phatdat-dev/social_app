import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/utils/utils.dart';

import '../../../core/services/picker_service.dart';
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
      ApiUrl.get_fetchStories(),
      RequestMethod.GET,
      isShowLoading: false,
    )
        .then((value) {
      //chổ này api viết tào lao quá nên mắc công phải sửa lại
      value = (value as List).map((e) => e['stories']).expand((e) => e).toList();
      listStories.change(Helper.convertToListMap(value), status: RxStatus.success());
    });
  }

  void redirectToStoriesView(({int index, Map<String, dynamic> data}) item) {
    currentObject = item;
    Get.toNamed(Routes.STORIES(item.data['id'].toString()));
  }

  void createStories() async {
    final pickerService = PickerService();
    await pickerService.pickMultiFile(FileType.image);
    if (pickerService.files == null || pickerService.files!.isEmpty) return;

    await call_createStories(
      type: 'image',
      filesPath: pickerService.files,
    );
    call_fetchStories();
  }

  Future<void> call_createStories({
    required String type,
    List<String>? filesPath,
  }) async {
    await apiCall.onRequest(
      ApiUrl.get_createStories(),
      RequestMethod.POST,
      body: FormData({
        'file[]': filesPath?.map((path) => MultipartFile(File(path), filename: path)).toList(),
        'type': type, //image, video
      }),
    );
    HelperWidget.showSnackBar(message: 'Create stories success');
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
