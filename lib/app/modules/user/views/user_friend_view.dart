// ignore_for_file: invalid_use_of_protected_member

import 'package:ckc_social_app/app/models/users_model.dart';
import 'package:ckc_social_app/app/modules/user/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/utils/utils.dart';
import '../../../models/other/tabbar_search_builder.dart';
import '../widget/user_friend_card_widget.dart';

class UserFriendView extends StatefulWidget {
  const UserFriendView({super.key});

  @override
  State<UserFriendView> createState() => _UserFriendViewState();
}

class _UserFriendViewState extends State<UserFriendView> with TickerProviderStateMixin, TabbarSearchView {
  late final UserController controller;

  @override
  String get title => LocaleKeys.Friend.tr;

  void onChangedSearchTextUser(String value) {
    HelperReflect.search(
      listOrigin: tabBarWidget[tabBarController.index].model.listOrigin,
      listSearch: tabBarWidget[tabBarController.index].model.listSearch,
      nameModel: 'displayName',
      keywordSearch: value,
    );
  }

  @override
  void initState() {
    controller = Get.find<UserController>(tag: '${int.tryParse(Get.parameters['id'] ?? '') ?? 0}');
    super.initState();
    controller.onInitDataUserFriend();
  }

  @override
  void onInitTabbarWidget() {
    tabBarWidget = [
      TabbarSearchBuilder(
        model: TabbarSearchModel(
          title: LocaleKeys.SuggetionsForYou,
          listOrigin: controller.listFriendSuggest,
          onChangedSearchText: onChangedSearchTextUser,
        ),
        itemBuilder: (e) {
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
        },
      ),
      TabbarSearchBuilder(
        model: TabbarSearchModel(
          title: LocaleKeys.YourFriend,
          listOrigin: controller.listFriendOfUser,
          onChangedSearchText: onChangedSearchTextUser,
        ),
        itemBuilder: (e) {
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
        },
      ),
      TabbarSearchBuilder(
        model: TabbarSearchModel(
          title: LocaleKeys.FriendRequests,
          listOrigin: controller.listFriendRequest,
          onChangedSearchText: onChangedSearchTextUser,
        ),
        itemBuilder: (e) {
          e as Map<String, dynamic>;
          return UserFriendCardWidget(
            title: e['displayName'] ?? '',
            image: NetworkImage(e['avatar'] ?? ''),
            action1: (
              LocaleKeys.Accept.tr,
              () => controller.call_acceptFriendRequest(int.parse('${e['user_request']}')), //
            ),
            action2: (
              LocaleKeys.Remove.tr,
              () => controller.call_denyFriendRequest(int.parse('${e['user_request']}')),
            ),
          );
        },
      ),
    ];
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
