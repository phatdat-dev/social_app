// ignore_for_file: invalid_use_of_protected_member

import 'package:ckc_social_app/app/custom/widget/search_widget.dart';
import 'package:ckc_social_app/app/models/users_model.dart';
import 'package:ckc_social_app/app/modules/user/controllers/user_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/utils/utils.dart';
import '../widget/user_friend_card_widget.dart';

class UserFriendView extends StatefulWidget {
  const UserFriendView({super.key});

  @override
  State<UserFriendView> createState() => _UserFriendViewState();
}

class _UserFriendViewState extends State<UserFriendView> with TickerProviderStateMixin {
  late final UserController controller;
  late final TabController tabBarController;
  late final List<(Map<String, dynamic>, Widget Function(int index))> tabBarWidget;
  final searchText = TextEditingController();

  String get title => LocaleKeys.Friend.tr;

  void onChangedSearchTextUser(String value) {
    HelperReflect.search(
      listOrigin: tabBarWidget[tabBarController.index].$1['ValueNotifier'],
      listSearch: tabBarWidget[tabBarController.index].$1['ValueNotifierSearch'],
      nameModel: 'displayName',
      keywordSearch: value,
    );
  }

  @override
  void initState() {
    super.initState();
    controller = Get.find<UserController>(tag: '${int.tryParse(Get.parameters['id'] ?? '') ?? 0}');

    tabBarWidget = [
      (
        {
          'Title': LocaleKeys.SuggetionsForYou,
          'ValueNotifier': controller.listFriendSuggest,
          'ValueNotifierSearch': RxList.from(controller.listFriendSuggest),
          'onChanged': onChangedSearchTextUser,
        },
        (index) => Obx(() => ListView(
              padding: EdgeInsets.zero,
              children: (tabBarWidget[index].$1['ValueNotifierSearch'] as RxList).map((e) {
                e as UsersModel;
                return UserFriendCardWidget(
                  title: e.displayName!,
                  image: NetworkImage(e.avatar!),
                  action1: (
                    LocaleKeys.AddFriend.tr,
                    () => controller.call_requestAddFriend(e.id!),
                  ),
                  action2: (
                    LocaleKeys.Remove.tr,
                    () {},
                  ),
                );
              }).toList(),
            ))
      ),
      (
        {
          'Title': LocaleKeys.YourFriend,
          'ValueNotifier': controller.listFriendOfUser,
          'ValueNotifierSearch': RxList.from(controller.listFriendOfUser),
          'onChanged': onChangedSearchTextUser,
        },
        (index) => Obx(() => ListView(
              padding: EdgeInsets.zero,
              children: (tabBarWidget[index].$1['ValueNotifierSearch'] as RxList).map((e) {
                e as UsersModel;
                return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(e.avatar!),
                    ),
                    title: searchText.text.isNotEmpty
                        ? RichText(
                            text: TextSpan(
                                children: HelperWidget.highlightOccurrences(e.displayName!, searchText.text),
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                          )
                        : Text(
                            e.displayName!,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () => showBottomSheetOptionFriend(e),
                    ));
              }).toList(),
            ))
      ),
      (
        {
          'Title': LocaleKeys.FriendRequests,
          'ValueNotifier': controller.listFriendRequest,
          'ValueNotifierSearch': RxList.from(controller.listFriendRequest),
          'onChanged': onChangedSearchTextUser,
        },
        (index) => Obx(() => ListView(
              padding: EdgeInsets.zero,
              children: (tabBarWidget[index].$1['ValueNotifierSearch'] as RxList).map((e) {
                e as Map<String, dynamic>;
                return UserFriendCardWidget(
                  title: e['displayName'] ?? '',
                  image: NetworkImage(e['avatar'] ?? ''),
                  action1: (
                    LocaleKeys.Accept.tr,
                    () => controller.call_acceptFriendRequest(e['user_request']), //
                  ),
                  action2: (
                    LocaleKeys.Remove.tr,
                    () {},
                  ),
                );
              }).toList(),
            ))
      ),
    ];
    //do call api sau nên lúc đầu mảng sẽ rỗng
    tabBarWidget.forEach((element) {
      (element.$1['ValueNotifier'] as RxList).listen((p0) {
        //update lại biến search khi api call thành công
        element.$1.update('ValueNotifierSearch', (valueNotifierSearch) => (valueNotifierSearch as RxList)..value = p0);
      });
    });

    tabBarController = TabController(length: tabBarWidget.length, vsync: this);

    controller.onInitDataUserFriend();
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
        body: RefreshIndicator(
          onRefresh: () async {},
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true, //giuu lau bottom
                pinned: true, //giuu lai bottom
                snap: true,
                title: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight + 48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TabBar(
                        controller: tabBarController,
                        tabs: tabBarWidget.map((e) => Tab(text: (e.$1['Title'] as String).tr)).toList(),
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
                      AnimatedBuilder(
                        animation: tabBarController,
                        builder: (context, child) => SearchBarWidget(
                          controller: searchText,
                          onChanged: tabBarWidget[tabBarController.index].$1['onChanged'] as Function(String)?,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: tabBarController,
              children: tabBarWidget.mapIndexed((index, e) => e.$2.call(index)).toList(),
            ),
          ),
        ),
        //Footer
      ),
    );
  }

  void showBottomSheetOptionFriend(UsersModel usersModel) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            // height: MediaQuery.of(context).size.height * 0.5,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(usersModel.avatar!),
                  ),
                  title: Text(usersModel.displayName!),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(MdiIcons.facebookMessenger),
                  title: Text(LocaleKeys.Message.tr),
                  trailing: const Icon(Icons.navigate_next_outlined),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(MdiIcons.accountMinusOutline),
                  title: Text(LocaleKeys.UnFollow.tr),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(MdiIcons.accountCancelOutline),
                  title: Text(LocaleKeys.Block.tr),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(MdiIcons.accountOffOutline, color: Colors.red),
                  title: Text(
                    LocaleKeys.UnFriend.tr,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    await controller.call_unFriend(usersModel.id!);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}
