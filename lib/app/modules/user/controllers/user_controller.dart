import 'dart:io';

import 'package:ckc_social_app/app/core/base/base_project.dart';
import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:get/get.dart';

import '../../../models/users_model.dart';
import '../../search_tag_friend/controllers/search_tag_friend_controller.dart';

enum Relationship {
  Nothing(3, 'Không'),
  Single(0, 'Độc thân'),
  Dating(1, 'Hẹn Hò'),
  Married(2, 'Đã kết hôn');

  final int value;
  final String title;
  const Relationship(this.value, this.title);
}

class UserController extends BaseController with SearchTagFriendController, StateMixin<UsersModel?> {
  final int userId;
  UserController(this.userId);

  @override
  Future<void> onInitData() async {
    call_profileUser(userId).then((value) => change(value, status: RxStatus.success()));
    call_fetchFriendByUserId(userId, 6);
    call_fetchImageUploadByUserId(userId, 3);
  }

  Future<void> onInitDataUserFriend() async {
    call_fetchFriendByUserId(); //listFriendOfUser
    call_fetchFriendsSuggestion(); //listFriendSuggest
    call_fetchFriendsRequest(); //listFriendRequest
  }

  Future<UsersModel?> call_profileUser(int userId) async {
    return await apiCall.onRequest(
      ApiUrl.get_profileUser(userId),
      RequestMethod.GET,
      baseModel: UsersModel(),
    );
  }

  Future<void> call_unFriend(int userId) async {
    await apiCall.onRequest(
      ApiUrl.post_unfriend(),
      RequestMethod.POST,
      body: {
        'userId': userId,
      },
    ).then((value) {
      call_fetchFriendByUserId();
    });
  }

  Future<void> call_requestAddFriend(int userIdAccept) async {
    await apiCall.onRequest(
      ApiUrl.post_requestAddFriend(),
      RequestMethod.POST,
      body: {
        'userIdAccept': userIdAccept,
      },
    ).then((result) => HelperWidget.showSnackBar(message: result.toString()));
  }

  Future<void> call_acceptFriendRequest(int userIdRequest) async {
    await apiCall.onRequest(
      ApiUrl.post_acceptFriendRequest(),
      RequestMethod.POST,
      body: {
        'userIdRequest': userIdRequest,
      },
    ).then((result) {
      HelperWidget.showSnackBar(message: result.toString());
      call_fetchFriendsRequest();
      call_fetchFriendByUserId();
    });
  }

  Future<void> call_editInformationUser({
    required String wentTo,
    required String liveIn,
    required Relationship relationship,
    required String phone,
  }) async {
    await apiCall.onRequest(
      ApiUrl.post_editInformationUser(),
      RequestMethod.POST,
      body: {
        'wentTo': wentTo,
        'liveIn': liveIn,
        'relationship': relationship.value,
        'phone': phone,
      },
    );
  }

  Future<void> call_uploadAvatar(
    List<String> filesPath,
  ) async {
    final formData = FormData({
      //? lúc thì api truyền files[], lúc thì file[]
      'file[]': filesPath.map((path) => MultipartFile(File(path), filename: path)).toList(),
    });

    final result = await apiCall.onRequest(
      ApiUrl.post_uploadAvatar(),
      RequestMethod.POST,
      body: formData,
      baseModel: UsersModel(),
    );
    if (result != null) {
      change(result, status: RxStatus.success());
      HelperWidget.showSnackBar(message: 'Success');
    }
  }
}
