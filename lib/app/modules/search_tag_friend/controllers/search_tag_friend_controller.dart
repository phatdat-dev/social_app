import 'package:get/get.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/utils/helper.dart';
import 'package:social_app/app/models/users_model.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';

mixin SearchTagFriendController implements BaseController {
  RxList<BaseSelectedModel> listFriendOfUser = RxList.empty();
  RxList<Map<String, dynamic>> listImageUploadOfUser = RxList.empty();

  Future<void> call_fetchFriendByUserId([int? userId, int? limit]) async {
    apiCall
        .onRequest(
      ApiUrl.get_fetchFriendByUserId(userId ?? AuthenticationController.userAccount!.id!, limit),
      RequestMethod.GET,
    )
        .then((value) {
      final data;
      if (value is Map && value['data'] != null) {
        data = value['data'];
      } else {
        data = value;
      }
      listFriendOfUser.value = List.from(data) //api viet sida
          .map((item) => UsersModel(
                id: item['friendId'],
                displayName: item['displayName'],
                avatar: item['avatar'],
              ))
          .toList();
    });
  }

  Future<void> call_fetchImageUploadByUserId([int? userId, int? limit]) async {
    apiCall
        .onRequest(
      ApiUrl.get_fetchImageUpload(userId ?? AuthenticationController.userAccount!.id!, limit),
      RequestMethod.GET,
    )
        .then((value) {
      listImageUploadOfUser.value = Helper.convertToListMap(value);
    });
  }

  void onPresseSearchTagFriendDone() async {}

  Future<List> call_searchUsersAndGroups(String input, String getObjectList) async {
    //json {users: [], groups: [], posts: []}
    return await apiCall
        .onRequest(
          ApiUrl.get_searchUsersAndGroups(input),
          RequestMethod.GET,
          isShowLoading: false,
        )
        .then(
          (value) => value[getObjectList],
        );
  }
}
