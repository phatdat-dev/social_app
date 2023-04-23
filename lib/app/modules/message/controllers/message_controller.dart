import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/constants/app_constant.dart';
import 'package:social_app/app/core/services/firebase_service.dart';
import 'package:social_app/app/models/users_model.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/search_tag_friend/controllers/search_tag_friend_controller.dart';

class MessageController extends BaseController with SearchTagFriendController {
  @override
  Future<void> onInitData() async {
    call_fetchFriendByUserId();
  }

  String generateChatRoomId(List<String> users) {
    users.sort();
    return users.join('_');
  }

  @override
  void onPresseSearchTagFriendDone() async {
    final context = Global.navigatorKey.currentContext!;
    final fireBaseService = context.read<FireBaseService>();
    final listSelected = listTagFriend!.where((element) => element.isSelected).toList();

    await fireBaseService.call_createGroupChat(
      chatRoomId: generateChatRoomId([
        '${AuthenticationController.userAccount!.id!}',
        ...listSelected.map((e) => (e as UsersModel).id!.toString()).toList(),
      ]),
      members: [AuthenticationController.userAccount!.toJson(), ...listSelected.map((e) => (e as UsersModel).toJson())],
    );

    context.pop();
  }
}
