import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ckc_social_app/app/core/utils/helper.dart';
import 'package:ckc_social_app/app/core/utils/helper_widget.dart';
import 'package:ckc_social_app/app/modules/home/controllers/base_fetch_controller.dart';
import 'package:ckc_social_app/app/routes/app_pages.dart';

import '../../../core/base/base_project.dart';

class GroupController extends BaseController {
  final FetchPostGroupController fetchPostGroupController = FetchPostGroupController();
  late FetchPostByGroupIdController fetchPostByGroupIdController;

  /// group of user
  RxList<Map<String, dynamic>> groupData = RxList.empty();
  Map<String, dynamic> currentGroup = {};
  RxList<Map<String, dynamic>> memberGroupData = RxList();

  @override
  Future<void> onInitData() async {
    fetchPostGroupController.onInitData();
    call_fetchGroupJoined();
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
    currentGroup = data;
    fetchPostByGroupIdController = FetchPostByGroupIdController(id: currentGroup['id']);
    Get.toNamed(Routes.GROUP(currentGroup['id'].toString()));
  }

  void redirectToGroupInfomation(BuildContext context) {
    Get.toNamed(Routes.GROUP_INFOMATION(currentGroup['id'].toString()));
  }

  void redirectToGroupMembers(BuildContext context) {
    Get.toNamed(Routes.GROUP_INFOMATION_MEMBERS(currentGroup['id'].toString()));
  }

  Future<void> call_fetchMemberGroup() async {
    await apiCall
        .onRequest(
      ApiUrl.get_fetchMemberGroup(currentGroup['id']),
      RequestMethod.GET,
    )
        .then((value) {
      //
      memberGroupData = Helper.convertToListMap(value).obs;
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
