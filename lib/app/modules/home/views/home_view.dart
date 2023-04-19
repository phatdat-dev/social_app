import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/widget/app_bar_icon.dart';

import '../../../../facebook/screens/facebook_screen_more.dart';
import '../../../../facebook/screens/facebook_screen_notify.dart';
import '../../../../facebook/screens/facebook_screen_pages.dart';
import '../controllers/home_controller.dart';
import 'home_dashboard_view.dart';
import 'home_video_view.dart';

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
      Tab(icon: Icon(Icons.notifications_outlined, size: 30)): FacebookScreenNotify(),
      Tab(icon: Icon(Icons.menu_outlined, size: 30)): FacebookScreenMore(),
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
        // drawer: HomeDrawerWidget(),
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

  SliverAppBar _buildAppBarDefaultTab() {
    return SliverAppBar(
      floating: true, //giuu lau bottom
      pinned: true, //giuu lai bottom
      snap: true,
      //with padding safeArea
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: SafeArea(
          child: TabBar(
            controller: controller.tabBarController,
            tabs: controller.tabBarWidget.keys.toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarHome(BuildContext context) {
    return SliverAppBar(
      floating: true, //giuu lau bottom
      pinned: true, //giuu lai bottom
      snap: true,

      title: Text(
        'Social App',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 30,
              color: Theme.of(context).primaryColor,
            ),
      ),
      actions: [
        AppBarIcon(iconData: Icons.add, onTap: () {}),
        AppBarIcon(iconData: MdiIcons.magnify, onTap: () {}),
        AppBarIcon(iconData: MdiIcons.facebookMessenger, onTap: () {}),
      ],
      bottom: TabBar(
        controller: controller.tabBarController,
        tabs: controller.tabBarWidget.keys.toList(),
      ),
    );
  }

  Widget _buildAppBarWatch(BuildContext context) {
    // final controller = context.read<HomeController>();
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: controller.subTabBarVideoWidget != null
          ? SliverAppBar(
              floating: true, //giuu lau bottom
              pinned: true, //giuu lai bottom
              snap: true,

              title: Text(
                'Watch',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              actions: [
                AppBarIcon(iconData: Icons.person_outline, onTap: () {}),
                AppBarIcon(iconData: MdiIcons.magnify, onTap: () {}),
              ],
              bottom: TabBar(
                controller: controller.subTabBarVideoController,
                tabs: controller.subTabBarVideoWidget!.keys.toList(),
                isScrollable: true,
                indicatorColor: Theme.of(context).colorScheme.secondary,
                // indicatorSize: TabBarIndicatorSize.label,
                //duong` vien`
                indicatorPadding: const EdgeInsets.all(8),
                splashBorderRadius: BorderRadius.circular(100),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
                ),
                labelColor: Theme.of(context).colorScheme.primary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                // unselectedLabelColor: Theme.of(context).colorScheme.secondary,
              ),
            )
          : const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }
}
