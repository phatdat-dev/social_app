import 'package:flutter/material.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/models/response/post_response_model.dart';
import 'package:social_app/app/modules/search_tag_friend/controllers/search_tag_friend_controller.dart';

class HomeController extends BaseController with SearchTagFriendController {
  // final BaseSearchRequestModel searchRequestModel = BaseSearchRequestModel(pageSize: 10);
  late Map<Widget, Widget> tabBarWidget;
  late TabController tabBarController;
  Map<Widget, Widget>? subTabBarVideoWidget;
  TabController? subTabBarVideoController;
  // Map<String, dynamic> request = {
  //   "loading_type": 0,
  //   "page_size": 2,
  //   "reload_times": 0,
  //   "type": 1,
  // };
  List<PostResponseModel>? postData = null;
  //bat event scroll chạm đáy sẽ load thêm api
  final GlobalKey<NestedScrollViewState> globalKeyScrollController = GlobalKey();

  @override
  Future<void> onInitData() async {
    //sau khi RenderUI
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //lấy scrollController của NestedScrollView
      final scrollController = globalKeyScrollController.currentState!.innerController;
      //add event
      scrollController.addListener(() {
        bool isScrollBottom = scrollController.position.pixels == scrollController.position.maxScrollExtent;
        //nếu đang ở trang HOME và scroll đến cuối danh sách
        if (tabBarController.index == 0 && isScrollBottom) {
          // Khi scroll đến cuối danh sách
          // Thực hiện tải thêm dữ liệu
          // request = request.copyWith({"page_size": request["page_size"] + 2});
          call_fetchPostData();
        }
      });
    });

    call_fetchPostData();
    call_fetchFriendByUserId();
  }

  Future<void> call_fetchPostData() async {
    apiCall
        .onRequest(
      ApiUrl.get_fetchPost(),
      RequestMethod.GET,
      // queryParam: request,
      // isShowLoading: false,
      baseModel: PostResponseModel(),
    )
        .then((value) {
      if (postData == null) {
        postData = value;
      } else {
        postData = [...postData!, value]; //ko xai` .addAll vi` notifyListeners se k rebuild
      }
      notifyListeners();
    });
  }

  Future<void> call_createPostData() async {}
}
