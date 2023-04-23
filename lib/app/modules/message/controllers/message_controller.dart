import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';

class MessageController extends BaseController {
  List<Map<String, dynamic>>? friends = null;

  @override
  Future<void> onInitData() async {
    call_fetchFriendByUserId();
  }

  Future<void> call_fetchFriendByUserId() async {
    apiCall
        .onRequest(
      ApiUrl.get_fetchFriendByUserId(
        AuthenticationController.userAccount!.id!,
      ),
      RequestMethod.GET,
    )
        .then((value) {
      friends = List.from(value);
      notifyListeners();
    });
  }

  String generateChatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) > 0) {
      return '$user1\_$user2';
    } else {
      return '$user2\_$user1';
    }
  }
}
