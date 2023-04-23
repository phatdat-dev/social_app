import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../modules/authentication/controllers/authentication_controller.dart';
import '../utils/utils.dart';

class FireBaseService with ChangeNotifier {
  FireBaseService() {
    Printt.white('Create Service: ${runtimeType}');
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> call_setStatusUserOnline(String status) async {
    await _firestore.collection('users').doc('${AuthenticationController.userAccount!.id!}').set({'status': status});
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> call_getUser(String id) {
    return _firestore.collection('users').doc(id).snapshots();
  }
}
