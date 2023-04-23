import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';

class MessageController extends BaseController {
  List<Map<String, dynamic>>? friends = null;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Stream<QuerySnapshot> call_getChatRoom(String chatRoomId) {
    return _firestore.collection('chatRoom').doc(chatRoomId).collection('chats').orderBy('created_at', descending: false).snapshots();
  }

  Future<void> call_sendMessage(String chatRoomId, String message) async {
    Map<String, dynamic> messageData = {
      'message': message,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'user': AuthenticationController.userAccount!.toJson(),
    };
    await _firestore.collection('chatRoom').doc(chatRoomId).collection('chats').add(messageData);
  }
}
