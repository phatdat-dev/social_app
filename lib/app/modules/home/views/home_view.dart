import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/modules/home/widget/home_drawer_widget.dart';
import 'package:social_app/app/widget/app_bar_icon.dart';

import '../../../../facebook/screens/facebook_screen_pages.dart';
import '../controllers/home_controller.dart';
import 'home_dashboard_view.dart';
import 'home_menu_view.dart';
import 'home_notify_view.dart';
import 'home_video_view.dart';

part '../widget/home_view_extension.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final HomeController controller;
  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();
    controller.onInitData();

    controller.tabBarWidget = {
      Tab(icon: Icon(Icons.home_outlined, size: 30)): HomeDashBoardView(),
      Tab(icon: Icon(Icons.ondemand_video_outlined, size: 30)): HomeVideoView(),
      Tab(icon: Icon(Icons.flag_outlined, size: 30)): FacebookScreenPages(),
      Tab(icon: Icon(Icons.notifications_outlined, size: 30)): HomeNotifyView(),
      Tab(icon: Icon(Icons.menu_outlined, size: 30)): HomeMenuView(),
    };

    controller.tabBarController = TabController(length: controller.tabBarWidget.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //huy keyboard khi bam ngoai man hinh
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // extendBody: true,
        extendBodyBehindAppBar: true,
        drawer: HomeDrawerWidget(),
        body: RefreshIndicator(
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
    );
  }
}
