
import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/core/utils/helper.dart';
import 'package:social_app/app/modules/home/controllers/base_fetch_controller.dart';

import '../../../core/base/base_project.dart';

class GroupController extends BaseController with BaseFetchController {
  @override
  String get apiUrl => ApiUrl.get_fetchPostGroup();

  /// group of user
  List<Map<String, dynamic>>? groupData = null;

  @override
  Future<void> onInitData() async {
    resetRequest();
    call_fetchGroupJoined();
    call_fetchData();
  }

  Future<void> call_fetchGroupJoined() async {
    await apiCall
        .onRequest(
      ApiUrl.get_fetchGroupJoined(),
      RequestMethod.GET,
    )
        .then((value) {
      //
      final data = List.from(value).map((e) => Helper.convertToListMap(e['groups'])).reduce((value, element) => value + element).toList();
      groupData = data;
      notifyListeners();
    });
  }
}
