part of '../views/home_view.dart';

extension HomeViewExtension on _HomeViewState {
  SliverAppBar _buildAppBarDefaultTab() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
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
        AppBarIconWidget(icon: const Icon(Icons.add), onPressed: () {}),
        AppBarIconWidget(
          icon: const Icon(MdiIcons.magnify),
          onPressed: () async {
            final searchDropDown = [
              MoreDropDownSearchCustom(
                key: 'users',
                queryName: 'displayName',
                apiCall: (data) => controller.call_searchUsersAndGroups(data, 'users'),
              ),
              MoreDropDownSearchCustom(
                key: 'groups',
                queryName: 'group_name',
                apiCall: (data) => controller.call_searchUsersAndGroups(data, 'groups'),
              ),
              MoreDropDownSearchCustom(
                key: 'posts',
                queryName: 'post_content',
                apiCall: (data) => controller.call_searchUsersAndGroups(data, 'posts'),
              ),
            ];

            final result = await HelperWidget.showSearchDropDownApiCall(
              context: context,
              hintText: 'find your friends...',
              initData: searchDropDown.first,
              moreDropDownSearch: searchDropDown,
            );
            Printt.white(result?.dataResponse);
          },
        ),
        AppBarIconWidget(
            icon: const Icon(MdiIcons.facebookMessenger),
            onPressed: () {
              Get.toNamed(Routes.MESSAGE());
            }),
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
                AppBarIconWidget(icon: const Icon(Icons.person_outline), onPressed: () {}),
                AppBarIconWidget(icon: const Icon(MdiIcons.magnify), onPressed: () {}),
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
                indicator: ShapeDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: const StadiumBorder(),
                ),
                labelColor: Theme.of(context).colorScheme.primary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                // unselectedLabelColor: Theme.of(context).colorScheme.secondary,
              ),
            )
          : const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }

  Widget _buildAppBarGroup(BuildContext context) {
    // final controller = context.read<HomeController>();
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: controller.subTabBarGroupWidget != null
          ? SliverAppBar(
              floating: true, //giuu lau bottom
              pinned: true, //giuu lai bottom
              snap: true,

              title: Text(
                'Group',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              actions: [
                AppBarIconWidget(icon: const Icon(Icons.settings), onPressed: () {}),
                AppBarIconWidget(icon: const Icon(MdiIcons.magnify), onPressed: () {}),
              ],
              bottom: TabBar(
                controller: controller.subTabBarGroupController,
                tabs: controller.subTabBarGroupWidget!.keys.toList(),
                // isScrollable: true,
                indicatorColor: Theme.of(context).colorScheme.secondary,
                // indicatorSize: TabBarIndicatorSize.label,
                //duong` vien`
                indicatorPadding: const EdgeInsets.all(8),
                splashBorderRadius: BorderRadius.circular(100),
                indicator: ShapeDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: const StadiumBorder(),
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
          AppBarIconWidget(icon: const Icon(MdiIcons.magnify), onPressed: () {}),
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
          AppBarIconWidget(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Get.toNamed('/viewColorTheme');
              }),
          AppBarIconWidget(icon: const Icon(MdiIcons.magnify), onPressed: () {}),
        ],
      ),
    );
  }
}
