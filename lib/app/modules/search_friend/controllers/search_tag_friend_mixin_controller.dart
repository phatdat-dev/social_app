import 'package:ckc_social_app/app/core/base/base_project.dart';
import 'package:ckc_social_app/app/core/utils/helper.dart';
import 'package:ckc_social_app/app/models/users_model.dart';
import 'package:ckc_social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:get/get.dart';

mixin SearchTagFriendMixinController implements BaseController {
  //co thoi gian chuyen may cai nay` thanh` bien' Value<T>
  RxList<UsersModel> listFriendOfUser = RxList.empty();
  RxList<UsersModel> listFriendSuggest = RxList.empty();
  RxList<Map<String, dynamic>> listFriendRequest = RxList.empty();

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
          .where((item) => item['status'] == 1)
          .map((item) => UsersModel(
                id: item['friendId'],
                displayName: item['displayName'],
                avatar: item['avatar'],
                status: item['status'].toString(),
              ))
          .toList();
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

  Future<void> call_fetchFriendsSuggestion() async {
    apiCall
        .onRequest(
      ApiUrl.get_fetchFriendsSuggestion(),
      RequestMethod.GET,
      baseModel: UsersModel(),
    )
        .then((value) {
      listFriendSuggest.value = value;
    });
  }

  Future<void> call_fetchFriendsRequest() async {
    apiCall
        .onRequest(
      ApiUrl.get_fetchFriendRequest(),
      RequestMethod.POST,
    )
        .then((value) {
      listFriendRequest.value = Helper.convertToListMap(value);
    });
  }

  Future<void> call_fetchFriendToInviteGroup(int groupId) async {
    await apiCall
        .onRequest(
      ApiUrl.get_fetchFriendToInviteGroup(groupId),
      RequestMethod.GET,
    )
        .then((value) {
      listFriendOfUser.value = Helper.convertToListMap(value)
          .where((item) => item['status'] == 1)
          .map((item) => UsersModel(
                id: item['friendId'],
                displayName: item['displayName'],
                avatar: item['avatar'],
                status: item['status'].toString(),
              ))
          .toList();
    });
  }
}
