import 'package:flutter/material.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/modules/home/controllers/group_controller.dart';
import 'package:social_app/app/modules/home/controllers/post_controller.dart';
import 'package:social_app/app/modules/search_tag_friend/controllers/search_tag_friend_controller.dart';

class HomeController extends BaseController with SearchTagFriendController, PostController, GroupController {
  // final BaseSearchRequestModel searchRequestModel = BaseSearchRequestModel(pageSize: 10);
  late Map<Widget, Widget> tabBarWidget;
  late TabController tabBarController;
  Map<Widget, Widget>? subTabBarVideoWidget;
  TabController? subTabBarVideoController;

  //bat event scroll chạm đáy sẽ load thêm api
  late GlobalKey<NestedScrollViewState> globalKeyScrollController;

  @override
  Future<void> onInitData() async {
    //reset data
    requestPost.update('page', (value) => 1);
    globalKeyScrollController = GlobalKey();
    postDataIsMaximum = false;

    //
    //sau khi RenderUI
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //lấy scrollController của NestedScrollView
      final scrollController = globalKeyScrollController.currentState?.innerController;
      //add event
      scrollController?.addListener(() {
        if (!postDataIsMaximum) {
          bool isScrollBottom = scrollController.position.pixels == scrollController.position.maxScrollExtent;
          //nếu đang ở trang HOME và scroll đến cuối danh sách
          if (tabBarController.index == 0 && isScrollBottom) {
            // Khi scroll đến cuối danh sách
            // Thực hiện tải thêm dữ liệu
            requestPost = requestPost.copyWith({'page': requestPost['page'] + 1});
            call_fetchPostData();
          }
        }
      });
    });

    call_fetchPostData();
    call_fetchFriendByUserId();
  }
}
