import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_app/app/core/services/firebase_service.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/custom/widget/app_bar_icon_widget.dart';
import 'package:social_app/app/modules/home/widget/home_drawer_widget.dart';
import 'package:social_app/app/routes/app_pages.dart';

import '../../../custom/other/more_dropdown_search_custom.dart';
import '../controllers/home_controller.dart';
import 'home_dashboard_view.dart';
import 'home_group_view.dart';
import 'home_menu_view.dart';
import 'home_notify_view.dart';
import 'home_video_view.dart';

part '../widget/home_view_extension.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin, WidgetsBindingObserver {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();

    controller.tabBarWidget = {
      const Tab(icon: Icon(Icons.home_outlined, size: 30)): HomeDashBoardView(),
      const Tab(icon: Icon(Icons.ondemand_video_outlined, size: 30)): const HomeVideoView(),
      const Tab(icon: Icon(MdiIcons.accountGroupOutline, size: 30)): HomeGroupView(),
      const Tab(icon: Icon(Icons.notifications_outlined, size: 30)): HomeNotifyView(),
      const Tab(icon: Icon(Icons.menu_outlined, size: 30)): HomeMenuView(),
    };

    controller.tabBarController = TabController(length: controller.tabBarWidget.length, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    //bắt sự kiện app background hay foreground
    final fireBaseService = Get.find<FireBaseService>();
    switch (state) {
      case AppLifecycleState.resumed:
        Printt.cyan('App in resumed');
        fireBaseService.call_setStatusUserOnline('Online');
        break;
      case AppLifecycleState.inactive:
        Printt.cyan('App in inactive');
        break;
      case AppLifecycleState.paused:
        fireBaseService.call_setStatusUserOnline('Offline');
        Printt.cyan('App in paused');
        break;
      case AppLifecycleState.detached:
        Printt.cyan('App in detached');
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //huy keyboard khi bam ngoai man hinh
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: GetBuilder(
        init: controller.postController,
        builder: (postController) => Scaffold(
          resizeToAvoidBottomInset: false,
          // extendBody: true,
          extendBodyBehindAppBar: true,
          drawer: const HomeDrawerWidget(),
          body: RefreshIndicator(
            notificationPredicate: (notification) {
              // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
              if (notification is OverscrollNotification || Platform.isIOS) {
                return notification.depth == 2;
              }
              return notification.depth == 0;
            },
            onRefresh: () async {
              await controller.onInitData();
            },
            child: AnimatedBuilder(
              animation: controller.tabBarController,
              builder: (context, child) => NestedScrollView(
                key: controller.globalKeyScrollController,
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  switch (controller.tabBarController.index) {
                    case 0:
                      return [
                        _buildAppBarHome(context),
                      ];
                    case 1:
                      return [
                        _buildAppBarDefaultTab(),
                        _buildAppBarWatch(context),
                      ];
                    case 2:
                      return [
                        _buildAppBarDefaultTab(),
                        _buildAppBarGroup(context),
                      ];
                    case 3:
                      return [
                        _buildAppBarDefaultTab(),
                        _buildAppBarNotify(context),
                      ];
                    case 4:
                      return [
                        _buildAppBarDefaultTab(),
                        _buildAppBarMenu(context),
                      ];
                    default:
                      return [_buildAppBarDefaultTab()];
                  }
                },
                body: TabBarView(
                  controller: controller.tabBarController,
                  children: controller.tabBarWidget.values.toList(),
                ),
              ),
            ),
          ),
          //Footer
        ),
      ),
    );
  }
}
