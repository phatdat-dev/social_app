import 'dart:convert';
import 'dart:io';

import 'package:ckc_social_app/app/core/base/base_project.dart';
import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/models/users_model.dart';
import 'package:ckc_social_app/app/modules/search_friend/controllers/search_tag_friend_mixin_controller.dart';
import 'package:ckc_social_app/app/modules/search_friend/views/search_tag_friend_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/pusher_service.dart';
import '../../../routes/app_pages.dart';

class MessageController extends BaseController with SearchTagFriendMixinController {
  final ListMapDataState listChatState = ListMapDataState([]);
  final ListMapDataState listMessageState = ListMapDataState([]);

  ValueNotifier<Map<String, dynamic>> currentChatRoom = ValueNotifier({
    'chatRoomId': null,
    'users': null,
    'conversation': null,
  });

  @override
  Future<void> onInitData() async {
    call_fetchFriendByUserId();
    call_fetchListChat();
  }

  // String generateChatRoomId(List<String> users) {
  //   users.sort();
  //   return users.join('_');
  // }

  @override
  void onPresseSearchTagFriendDone() async {
    //create group chat
    final listSelected = listFriendOfUser.where((element) => element.isSelected).toList();

    final result = await call_createGroupChat(
      'Created group',
      listSelected.map((e) => e.id!).toList(),
    );

    Get.back();
    if (result == null) return;
    redirectToMessageDetail(result['id']);
  }

  void onCreateMessage(int index, UsersModel user) async {
    final result = await call_createChat(user.id!);
    if (result == null) return;
    redirectToMessageDetail(result['id']);
  }

  void onCreateNewGroupMessage<T extends SearchTagFriendMixinController>(BuildContext context) {
    currentChatRoom.value.update('chatRoomId', (value) => null);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchTagFriendView<T>(title: 'New Group Message')));
  }

  void onAddMemberToGroupMessage<T extends SearchTagFriendMixinController>({
    required BuildContext context,
    required ValueNotifier<List<UsersModel>> listMemberSelected,
  }) {
    //member đã chọn
    listMemberSelected.value.forEach((element) {
      listFriendOfUser.firstWhereOrNull((e) => (e).id == element.id)?.isSelected = true;
    });

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchTagFriendView<T>(title: 'Add member')));
  }

  // void onPickFileSend({
  //   required FileType type,
  // }) async {
  //   //pick file
  //   final pickerService = PickerService();
  //   await pickerService.pickMultiFile(type);
  //   if (pickerService.files.isEmpty) return;

  //   final formData = FormData({
  //     'files[]': pickerService.files.map((path) => MultipartFile(File(path), filename: path)).toList(),
  //   });

  //   final images = await apiCall.onRequest(
  //     ApiUrl.post_messageUploadFile(),
  //     RequestMethod.POST,
  //     body: formData,
  //   );

  //   Get.find<FireBaseService>().call_sendMessage(
  //     chatRoomId: currentChatRoom.value['chatRoomId'],
  //     type: type.name,
  //     data: images,
  //   );
  // }

  void handleMessage() {
    final pusherService = Get.find<PusherService>();
    pusherService.subscribeChannel(
      channalName: 'conversation-' + currentChatRoom.value['chatRoomId'].toString(),
      bindEventName: 'message',
      onEvent: (event) {
        // Printt.white(jsonDecode(event!.data!));
        listMessageState
          ..state!.add(jsonDecode(event!.data!)['message'])
          ..refresh();
      },
    );
  }

  void redirectToMessageDetail(int conversationId) async {
    currentChatRoom.value = currentChatRoom.value.copyWith({
      'chatRoomId': conversationId,
    });

    call_fetchListChat();
    Get.toNamed(Routes.MESSAGE_DETAIL(conversationId));
  }

  Future<Map<String, dynamic>?> call_createChat(int userId) async {
    return await apiCall.onRequest(
      ApiUrl.post_createChat(),
      RequestMethod.POST,
      body: {
        'userId': userId,
      },
    );
  }

  Future<void> call_fetchListChat() async {
    listChatState.run(
      apiCall
          .onRequest(
            ApiUrl.get_fetchListChat(),
            RequestMethod.GET,
          )
          .then((value) => Helper.convertToListMap(value)),
    );
  }

  Future<void> call_fetchMessageCurrent() async {
    listMessageState.run(
      apiCall
          .onRequest(
        ApiUrl.get_fetchMessage(currentChatRoom.value['chatRoomId']),
        RequestMethod.GET,
      )
          .then((value) {
        final listUser = (value['conversation']?['paticipaints'] as List?)?.map((element) {
          return UsersModel().fromJson(element['user']);
        }).toList();
        //
        currentChatRoom.value = currentChatRoom.value.copyWith({
          'conversation': value['conversation'],
          'users': listUser,
        });
        return Helper.convertToListMap((value['message'] as List).reversed);
      }),
    );
  }

  Future<void> call_sendMessage(String contentString, [List<String>? filesPath]) async {
    final formData = FormData({
      'conversationId': currentChatRoom.value['chatRoomId'],
      'contentMessage': contentString,
      'files[]': filesPath?.map((path) => MultipartFile(File(path), filename: path)).toList(),
    });

    await apiCall.onRequest(ApiUrl.post_sendMessage(), RequestMethod.POST, body: formData);
  }

  Future<Map<String, dynamic>?> call_createGroupChat(String contentMessage, List<int> listUserId) async {
    return await apiCall.onRequest(ApiUrl.post_createGroupChat(), RequestMethod.POST, body: {
      'contentMessage': contentMessage,
      'members': listUserId,
    }).then((value) => value[0]);
  }
}
