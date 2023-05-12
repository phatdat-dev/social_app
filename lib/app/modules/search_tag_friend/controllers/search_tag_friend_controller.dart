import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/models/users_model.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';

mixin  SearchTagFriendController implements BaseController {
  List<BaseSelectedModel>? listTagFriend = null;

  Future<void> call_fetchFriendByUserId() async {
    apiCall
        .onRequest(
      ApiUrl.get_fetchFriendByUserId(
        AuthenticationController.userAccount!.id!,
      ),
      RequestMethod.GET,
    )
        .then((value) {
      listTagFriend = List.from(value['data'])
          .map((item) => UsersModel(
                id: item['friendId'],
                displayName: item['displayName'],
                avatar: item['avatar'],
              ))
          .toList();
      notifyListeners();
    });
  }

  void onPresseSearchTagFriendDone() async {}
}
