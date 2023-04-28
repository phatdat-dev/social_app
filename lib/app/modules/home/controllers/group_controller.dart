import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/core/utils/helper.dart';

import '../../../core/base/base_project.dart';

abstract class GroupController implements BaseController {
  List<Map<String, dynamic>>? groupData = null;

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
    });
  }
}
