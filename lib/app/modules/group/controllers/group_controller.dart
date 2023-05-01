import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/core/utils/helper.dart';
import 'package:social_app/app/modules/home/controllers/base_fetch_controller.dart';
import 'package:social_app/app/routes/app_pages.dart';

import '../../../core/base/base_project.dart';

class GroupController extends BaseController {
  final FetchPostGroupController fetchPostGroupController = FetchPostGroupController();
  final FetchPostByGroupIdController fetchPostByGroupIdController = FetchPostByGroupIdController();

  /// group of user
  List<Map<String, dynamic>>? groupData = null;
  Map<String, dynamic> currentGroup = {};

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
    )
        .then((value) {
      //
      final data = List.from(value).map((e) => Helper.convertToListMap(e['groups'])).reduce((value, element) => value + element).toList();
      groupData = data;
      notifyListeners();
    });
  }

  void redirectToGroup(BuildContext context, Map<String, dynamic> data) {
    currentGroup = data;
    fetchPostByGroupIdController.id = currentGroup['id'];
    context.push(Routes.GROUP(currentGroup['id'].toString()), extra: context.read<GroupController>());
  }
}

class FetchPostByGroupIdController extends BaseController with BaseFetchController {
  late int id;
  ScrollController scrollController = ScrollController();

  @override
  String get apiUrl => ApiUrl.post_fetchPostByGroupId(id);

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

class FetchPostGroupController extends BaseController with BaseFetchController {
  @override
  String get apiUrl => ApiUrl.get_fetchPostGroup();
}
