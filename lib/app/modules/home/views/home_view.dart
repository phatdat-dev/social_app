import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/widget/app_bar_icon.dart';

import '../../../../facebook/screens/facebook_screen_groups.dart';
import '../../../../facebook/screens/facebook_screen_more.dart';
import '../../../../facebook/screens/facebook_screen_notify.dart';
import '../../../../facebook/screens/facebook_screen_pages.dart';
import '../../../../facebook/screens/facebook_screen_post.dart';
import '../../../../facebook/screens/facebook_screen_videos.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final HomeController controller;
  late final Map<Widget, Widget> tabBarWidget;
  late final TabController tabBarController;
  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();
    controller.onInitData();

    tabBarWidget = {
      Tab(icon: Icon(Icons.home_outlined, size: 30)): FacebookScreenPost(),
      Tab(icon: Icon(Icons.person_outline, size: 30)): FacebookScreenGroups(),
      Tab(icon: Icon(Icons.ondemand_video_outlined, size: 30)): FacebookScreenVideos(),
      Tab(icon: Icon(Icons.flag_outlined, size: 30)): FacebookScreenPages(),
      Tab(icon: Icon(Icons.notifications_outlined, size: 30)): FacebookScreenNotify(),
      Tab(icon: Icon(Icons.menu_outlined, size: 30)): FacebookScreenMore(),
    };

    tabBarController = TabController(length: tabBarWidget.length, vsync: this);
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
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
                //automaticallyImplyLeading: false,
                // centerTitle: true,
                // expandedHeight: 150,
                floating: true, //giuu lau bottom
                pinned: true, //giuu lai bottom
                snap: true,
                title: Text('Social App',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 30,
                          color: Theme.of(context).primaryColor,
                        )),
                actions: [
                  AppBarIcon(iconData: Icons.add, onTap: () {}),
                  AppBarIcon(iconData: MdiIcons.magnify, onTap: () {}),
                  AppBarIcon(iconData: MdiIcons.facebookMessenger, onTap: () {}),
                ],
                // flexibleSpace: const FlexibleSpaceBar(
                //   centerTitle: true,
                //   //collapseMode: CollapseMode.parallax,
                //   background: Padding(
                //     padding: EdgeInsets.only(left: 10),
                //     child: Align(
                //       alignment: Alignment.centerLeft,
                //       child: Text('Find your favorite product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                //     ),
                //   ),
                // ),
                bottom: TabBar(
                  controller: tabBarController,
                  tabs: tabBarWidget.keys.toList(),
                )),
          ],
          body: TabBarView(
            controller: tabBarController,
            children: tabBarWidget.values.toList(),
          ),
        ),
        //Footer
      ),
    );
  }
}
