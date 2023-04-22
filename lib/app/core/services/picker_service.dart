import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:social_app/app/core/utils/utils.dart';

class PickerService with ChangeNotifier {
  PickerService() {
    Printt.white('Create Service: ${runtimeType}');
  }
  List<File>? files = null;

  Future<List<File>?> pickMultiFile(FileType type) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: type,
    );

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      Printt.white(files);
      notifyListeners();

      return files;

      // final List<MultipartFile> multipartFiles = files.map((e) => MultipartFile.fromFileSync(e.path)).toList();
      // final Map<String, dynamic> data = {
      //   "files": multipartFiles,
      // };
      // apiCall.onRequest(ApiUrl.uploadFile(), RequestMethod.POST, data: data).then((value) {
      //   print(value);
      // });
    }
    return null;
  }
}
