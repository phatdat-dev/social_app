part of '../views/home_view.dart';

extension HomeViewExtension on _HomeViewState {
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
                  color: Theme.of(context).colorScheme.secondary,
                  border: Border.all(color: Theme.of(context).colorScheme.secondary),
                ),
                labelColor: Theme.of(context).colorScheme.primary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                // unselectedLabelColor: Theme.of(context).colorScheme.secondary,
              ),
            )
          : const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }

  Widget _buildAppBarNotify(BuildContext context) {
    // final controller = context.read<HomeController>();
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: SliverAppBar(
        floating: true, //giuu lau bottom
        pinned: true, //giuu lai bottom
        snap: true,

        title: Text(
          'Thông báo',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 30,
                color: Theme.of(context).primaryColor,
              ),
        ),
        actions: [
          AppBarIcon(iconData: MdiIcons.magnify, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildAppBarMenu(BuildContext context) {
    // final controller = context.read<HomeController>();
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: SliverAppBar(
        floating: true, //giuu lau bottom
        pinned: true, //giuu lai bottom
        snap: true,

        title: Text(
          'Menu',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 30,
                color: Theme.of(context).primaryColor,
              ),
        ),
        actions: [
          AppBarIcon(
              iconData: Icons.settings,
              onTap: () {
                context.push('/viewColorTheme');
              }),
          AppBarIcon(iconData: MdiIcons.magnify, onTap: () {}),
        ],
      ),
    );
  }
}
