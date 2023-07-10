import 'dart:io';

import 'package:ckc_social_app/app/core/base/base_project.dart';
import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../../../models/users_model.dart';
import '../../authentication/controllers/authentication_controller.dart';
import '../../search_friend/controllers/search_tag_friend_mixin_controller.dart';

part 'user_photo_controller_mixin.dart';

enum Relationship {
  Nothing(3, 'Không'),
  Single(0, 'Độc thân'),
  Dating(1, 'Hẹn Hò'),
  Married(2, 'Đã kết hôn');

  final int value;
  final String title;
  const Relationship(this.value, this.title);

  factory Relationship.fromValue(int? value) {
    return Relationship.values.firstWhere((element) => element.value == value, orElse: () => Relationship.Nothing);
  }
}

class UserController extends BaseController with SearchTagFriendMixinController, UserPhotoControllerMixin, StateMixin<UsersModel?> {
  final int userId;
  UserController(this.userId);

  @override
  Future<void> onInitData() async {
    call_profileUser(userId).then((value) => change(value, status: RxStatus.success()));
    call_fetchFriendByUserId(userId, 6);
    call_fetchImageUploadByUserId(userId, 3);
  }

  Future<void> onInitDataUserImage() async {
    call_fetchImageUploadByUserId(userId);
    call_fetchImageFromPostTag(userId);
    call_fetchAlbumByUserId(userId);
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

  Future<void> call_editInformationUser(Map<String, dynamic> body) async {
    final result = await apiCall.onRequest(
      ApiUrl.post_editInformationUser(),
      RequestMethod.POST,
      body: body,
      baseModel: UsersModel(),
      // {
      //   'wentTo': wentTo,
      //   'liveIn': liveIn,
      //   'relationship': relationship.value,
      //   'phone': phone,
      // },
    );
    if (result != null) {
      change(result, status: RxStatus.success());
      Get.back();
      HelperWidget.showSnackBar(message: 'Success');
    }
  }

  Future<void> call_uploadAvatar(List<String> filesPath, {bool isCoverImage = false}) async {
    final formData = FormData({
      //? lúc thì api truyền files[], lúc thì file[]
      'file[]': filesPath.map((path) => MultipartFile(File(path), filename: path)).toList(),
    });

    final result = await apiCall.onRequest(
      isCoverImage ? ApiUrl.post_uploadCoverImage() : ApiUrl.post_uploadAvatar(),
      RequestMethod.POST,
      body: formData,
      baseModel: UsersModel(),
    );
    if (result != null) {
      change(result, status: RxStatus.success());
      HelperWidget.showSnackBar(message: 'Success');
    }
  }

  Future<void> call_updatePasswordUser(Map<String, dynamic> body) async {
    final result = await apiCall.onRequest(
      ApiUrl.post_updatePasswordUser(),
      RequestMethod.POST,
      body: body,
    );
    if (result != null) {
      Get.until((route) => route.settings.name == Routes.USER('$userId'));
      HelperWidget.showSnackBar(message: result.toString());
    }
  }
}
