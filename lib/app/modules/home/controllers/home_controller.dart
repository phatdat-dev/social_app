import 'package:flutter/material.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/modules/group/controllers/group_controller.dart';
import 'package:social_app/app/modules/home/controllers/post_controller.dart';
import 'package:social_app/app/modules/search_tag_friend/controllers/search_tag_friend_controller.dart';

class HomeController extends BaseController with SearchTagFriendController {
  // final BaseSearchRequestModel searchRequestModel = BaseSearchRequestModel(pageSize: 10);
  late Map<Widget, Widget> tabBarWidget;
  late TabController tabBarController;
  Map<Widget, Widget>? subTabBarVideoWidget;
  Map<Widget, Widget>? subTabBarGroupWidget;
  TabController? subTabBarVideoController;
  TabController? subTabBarGroupController;

  final PostController postController = PostController();
  final GroupController groupController = GroupController();

  //bat event scroll chạm đáy sẽ load thêm api
  late GlobalKey<NestedScrollViewState> globalKeyScrollController;

  @override
  Future<void> onInitData() async {
    //reset data
    globalKeyScrollController = GlobalKey();
    postController.onInitData();

    //
    //sau khi RenderUI
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //lấy scrollController của NestedScrollView
      final scrollController = globalKeyScrollController.currentState?.innerController;
      //add event
      scrollController?.addListener(() {
        bool isScrollBottom = scrollController.position.pixels == scrollController.position.maxScrollExtent;
        //nếu đang ở trang HOME và scroll đến cuối danh sách
        if ((!postController.dataResponseIsMaximum) && (tabBarController.index == 0 && isScrollBottom)) {
          postController.loadMoreData();
        }
      });
    });
    call_fetchFriendByUserId();
  }
}
