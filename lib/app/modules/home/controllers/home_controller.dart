import 'package:flutter/material.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/core/utils/utils.dart';

class HomeController extends BaseController {
  // final BaseSearchRequestModel searchRequestModel = BaseSearchRequestModel(pageSize: 10);
  late final Map<Widget, Widget> tabBarWidget;
  late final TabController tabBarController;
  Map<Widget, Widget>? subTabBarVideoWidget;
  TabController? subTabBarVideoController;
  Map<String, dynamic> request = {
    "loading_type": 0,
    "page_size": 2,
    "reload_times": 0,
    "type": 1,
  };
  List<Map<String, dynamic>>? postData = null;
  final GlobalKey<NestedScrollViewState> globalKeyScrollController = GlobalKey();

  @override
  Future<void> onInitData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final scrollController = globalKeyScrollController.currentState!.innerController;
      scrollController.addListener(() {
        bool isScrollBottom = scrollController.position.pixels == scrollController.position.maxScrollExtent;
        if (tabBarController.index == 0 && isScrollBottom) {
          // Khi scroll đến cuối danh sách
          // Thực hiện tải thêm dữ liệu
          request = request.copyWith({"page_size": request["page_size"] + 2});
          loadPostData();
        }
      });
    });

    loadPostData();
  }

  Future<void> loadPostData() async {
    apiCall
        .onRequest(
      ApiUrl.get_communityPostList(),
      RequestMethod.GET,
      queryParam: request,
      // isShowLoading: false,
    )
        .then((value) {
      if (postData == null) {
        postData = List.from(value["data"]["list"]);
      } else {
        postData = [...postData!, ...List.from(value["data"]["list"])]; //ko xai` .addAll vi` notifyListeners se k rebuild
      }
      notifyListeners();
    });
  }

  Future<void> createPostData() async {}
}
