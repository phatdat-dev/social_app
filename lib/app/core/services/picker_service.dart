import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class PickerService extends GetxController {
  PickerService() {
    Printt.white('Create Service: ${runtimeType}');
  }
  RxList<String> files = <String>[].obs;

  Future<List<String>?> pickMultiFile(FileType type, {bool allowMultiple = true}) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: type,
    );

    if (result != null) {
      // files = result.paths.map((path) => File(path!)).toList();
      files.value = result.paths.map((e) => e!).toList();
      Printt.white(files);

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
