import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/core/services/firebase_service.dart';
import 'package:social_app/app/core/services/picker_service.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/models/users_model.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/search_tag_friend/controllers/search_tag_friend_controller.dart';
import 'package:social_app/app/modules/search_tag_friend/views/search_tag_friend_view.dart';

class MessageController extends BaseController with SearchTagFriendController {
  Map<String, dynamic> currentChatRoom = {
    'chatRoomId': null,
    'user': null,
  };

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
    final fireBaseService = Get.find<FireBaseService>();
    final listSelected = listTagFriend!.where((element) => element.isSelected).toList();

    await fireBaseService.call_createOrUpdateGroupChat(
      chatRoomId: currentChatRoom['chatRoomId'] ?? Helper.generateIdFromDateTimeNow(),
      members: [AuthenticationController.userAccount!.toJson(), ...listSelected.map((e) => (e as UsersModel).toJson())],
    );

    Get.back();
  }

  void onCreateNewGroupMessage<T extends SearchTagFriendController>(BuildContext context) {
    currentChatRoom.update('chatRoomId', (value) => null);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchTagFriendView<T>(title: 'New Message')));
  }

  void onAddMemberToGroupMessage<T extends SearchTagFriendController>({
    required BuildContext context,
    required ValueNotifier<List<UsersModel>> listMemberSelected,
  }) {
    //member đã chọn
    listMemberSelected.value.forEach((element) {
      listTagFriend?.firstWhereOrNull((e) => (e as UsersModel).id == element.id)?.isSelected = true;
    });

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchTagFriendView<T>(title: 'Add member', minSelected: 1)));
  }

  void onPickFileSend({
    required FileType type,
  }) async {
    //pick file
    final pickerService = PickerService();
    await pickerService.pickMultiFile(type);
    if (pickerService.files == null || pickerService.files!.isEmpty) return;

    final formData = FormData({
      'files[]': pickerService.files?.map((path) => MultipartFile(File(path), filename: path)).toList(),
    });

    final images = await apiCall.onRequest(
      ApiUrl.post_messageUploadFile(),
      RequestMethod.POST,
      body: formData,
    );

    Get.find<FireBaseService>().call_sendMessage(
      chatRoomId: currentChatRoom['chatRoomId'],
      type: type.name,
      data: images,
    );
  }
}
