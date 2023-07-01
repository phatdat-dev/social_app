import 'dart:io';

import 'package:ckc_social_app/app/core/utils/helper.dart';
import 'package:ckc_social_app/app/core/utils/helper_widget.dart';
import 'package:ckc_social_app/app/modules/home/controllers/base_fetch_controller.dart';
import 'package:ckc_social_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/base_project.dart';
import '../../search_tag_friend/controllers/search_tag_friend_controller.dart';

class GroupController extends BaseController with SearchTagFriendController {
  final FetchPostGroupController fetchPostGroupController = FetchPostGroupController();
  late FetchPostByGroupIdController fetchPostByGroupIdController;

  /// group of user
  RxList<Map<String, dynamic>> groupData = RxList.empty();
  RxMap<String, dynamic> currentGroup = RxMap();
  RxList<Map<String, dynamic>> memberGroupData = RxList();
  ListMapDataState inviteMyGroupData = ListMapDataState([]);

  @override
  Future<void> onInitData() async {
    fetchPostGroupController.onInitData();
    call_fetchGroupJoined();
    call_fetchInviteToGroup();
  }

  @override
  void onPresseSearchTagFriendDone() async {
    final getListSelected = listFriendOfUser.where((element) => element.isSelected).toList();
    getListSelected.forEach((element) {
      call_sendInviteToGroup(element.id!);
    });
    Get.back();
    HelperWidget.showSnackBar(message: 'Success');
  }

  Future<void> call_fetchGroupJoined() async {
    await apiCall
        .onRequest(
      ApiUrl.get_fetchGroupJoined(),
      RequestMethod.GET,
      isShowLoading: false,
    )
        .then((value) {
      //
      final data = List.from(value).map((e) => Helper.convertToListMap(e['groups'])).reduce((value, element) => value + element).toList();
      groupData.value = data;
    });
  }

  void redirectToGroup(BuildContext context, Map<String, dynamic> data) {
    currentGroup.value = data;
    fetchPostByGroupIdController = FetchPostByGroupIdController(id: currentGroup['id']);
    Get.toNamed(Routes.GROUP(currentGroup['id'].toString()));
  }

  void redirectToGroupInfomation(BuildContext context) {
    Get.toNamed(Routes.GROUP_INFOMATION(currentGroup['id'].toString()));
  }

  void redirectToGroupMembers(BuildContext context) {
    Get.toNamed(Routes.GROUP_INFOMATION_MEMBERS(currentGroup['id'].toString()));
  }

  void redirectToGroupEditing(BuildContext context) {
    Get.toNamed(Routes.GROUP_EDITING(currentGroup['id'].toString()));
  }

  Future<void> call_fetchMemberGroup() async {
    await apiCall
        .onRequest(
      ApiUrl.get_fetchMemberGroup(currentGroup['id']),
      RequestMethod.GET,
    )
        .then((value) {
      //
      memberGroupData.value = Helper.convertToListMap(value);
    });
  }

  Future<void> call_setRoleAdminGroup({required int userId, required int groupId}) async {
    await apiCall.onRequest(
      ApiUrl.post_addAdminToGroup(),
      RequestMethod.POST,
      body: {
        'userId': userId,
        'groupId': groupId,
      },
    ).then((value) {
      HelperWidget.showSnackBar(message: 'Success');
    });
  }

  Future<void> call_removeMemberFromGroup({bool removeAdminGroup = false, required int userId, required int groupId}) async {
    await apiCall.onRequest(
      (removeAdminGroup) ? ApiUrl.post_removeAdminToGroup() : ApiUrl.post_removeMemberFromGroup(),
      RequestMethod.POST,
      body: {
        'userId': userId,
        'groupId': groupId,
      },
    ).then((value) {
      if (value is String) {
        HelperWidget.showSnackBar(message: value);
      } else {
        HelperWidget.showSnackBar(message: 'Success');
      }
    });
  }

  Future<void> call_createOrUpdateGroup(Map<String, dynamic> body, List<String> filesPath) async {
    final formData = FormData({
      ...body,
      if (filesPath.isNotEmpty) 'file': MultipartFile(File(filesPath.first), filename: filesPath.first),
    });

    //groupName, privacy
    await apiCall
        .onRequest(
      (body.containsKey('groupId')) ? ApiUrl.post_editInformationGroup() : ApiUrl.post_createGroup(),
      RequestMethod.POST,
      body: formData,
    )
        .then((value) {
      currentGroup.value = value;
      onInitData();
      fetchPostByGroupIdController.onInitData();
      HelperWidget.showSnackBar(message: 'Success');
    });
  }

  Future<void> call_sendInviteToGroup(int userId) async {
    await apiCall.onRequest(
      ApiUrl.post_sendInviteToGroup(),
      RequestMethod.POST,
      body: {
        'userId': userId,
        'groupId': currentGroup['id'],
      },
      isShowLoading: false,
    );
  }

  Future<void> call_fetchInviteToGroup() async {
    inviteMyGroupData.run(
      apiCall
          .onRequest(
            ApiUrl.get_fetchInviteToGroup(),
            RequestMethod.GET,
          )
          .then((value) => Helper.convertToListMap(value)),
    );
  }

  Future<void> call_acceptInviteToGroup(int groupId) async {
    await apiCall.onRequest(ApiUrl.post_acceptInviteToGroup(), RequestMethod.POST, body: {
      'groupId': groupId,
    }).then((value) {
      HelperWidget.showSnackBar(message: value);
      call_fetchInviteToGroup();
    });
  }
}

class FetchPostByGroupIdController extends BaseFetchController {
  final int id;
  FetchPostByGroupIdController({required this.id});
  ScrollController scrollController = ScrollController();

  @override
  String get apiUrl => ApiUrl.get_fetchPostByGroupId(id);

  @override
  Future<void> onInitData() async {
    super.onInitData();

    //sau khi RenderUI
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //add event
      scrollController.addListener(() {
        bool isScrollBottom = scrollController.position.pixels == scrollController.position.maxScrollExtent;
        //nếu scroll đến cuối danh sách
        if ((!dataResponseIsMaximum) && isScrollBottom) {
          loadMoreData();
        }
      });
    });
  }
}

class FetchPostGroupController extends BaseFetchController {
  @override
  String get apiUrl => ApiUrl.get_fetchPostGroup();
}
