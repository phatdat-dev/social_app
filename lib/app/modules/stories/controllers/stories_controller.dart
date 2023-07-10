import 'dart:io';

import 'package:ckc_social_app/app/core/base/base_project.dart';
import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

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
    listStories.run(apiCall
        .onRequest(
          ApiUrl.get_fetchStories(),
          RequestMethod.GET,
          isShowLoading: false,
        )
        .then(
          (value) => Helper.convertToListMap(value),
        ));
  }

  void redirectToStoriesView(({int index, Map<String, dynamic> data}) item) {
    currentObject = item;
    Get.toNamed(Routes.STORIES(item.data['user_id'].toString()));
  }

  void createStories() async {
    final pickerService = PickerService();
    await pickerService.pickMultiFile(FileType.image);
    if (pickerService.files.isEmpty) return;

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
