import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/models/response/privacy_model.dart';
import 'package:ckc_social_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/other/tabbar_search_builder.dart';
import '../../../models/users_model.dart';
import '../../post/widget/facebook_card_post_widget.dart';

class HomeSearchView extends StatefulWidget {
  const HomeSearchView({super.key});

  @override
  State<HomeSearchView> createState() => _HomeSearchViewState();
}

class _HomeSearchViewState extends State<HomeSearchView> with TickerProviderStateMixin, TabbarSearchView {
  late final HomeController controller;
  final List<RxList> data = [
    RxList.empty(), //users
    RxList.empty(), //groups
    RxList.empty(), //posts
  ];
  final Debouncer debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  @override
  void initState() {
    controller = Get.find();
    super.initState();
  }

  @override
  void onInitTabbarWidget() {
    Widget buildText(String text) => searchText.text.isNotEmpty
        ? RichText(
            text: TextSpan(
                children: HelperWidget.highlightOccurrences(text, searchText.text), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          )
        : Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          );
    //
    tabBarWidget = [
      TabbarSearchBuilder(
        model: TabbarSearchModel(
          title: LocaleKeys.Friend,
          listOrigin: data[0],
          onChangedSearchText: onChangedSearchText,
        ),
        itemBuilder: (e) {
          e as UsersModel;
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(e.avatar!),
            ),
            title: buildText(e.displayName!),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          );
        },
      ),
      TabbarSearchBuilder(
        model: TabbarSearchModel(
          title: LocaleKeys.Group,
          listOrigin: data[1],
          onChangedSearchText: onChangedSearchText,
        ),
        itemBuilder: (e) {
          e as Map<String, dynamic>;
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(e['avatar']),
            ),
            title: buildText(e['group_name']),
            subtitle: Text("${PrivacyModel.from(e['privacy']).privacyGroupName} ☘ ${e['totalMember']} ${LocaleKeys.Members.tr}"),
          );
        },
      ),
      TabbarSearchBuilder(
        model: TabbarSearchModel(
          title: LocaleKeys.Post,
          listOrigin: data[2],
          onChangedSearchText: onChangedSearchText,
        ),
        itemBuilder: (e) {
          e as Map<String, dynamic>;
          return FacebookCardPostWidget(e);
        },
      ),
    ];
  }

  @override
  String get title => LocaleKeys.Search.tr;

  void onChangedSearchText(String value) {
    if (value.isEmpty) return;
    debouncer(() async {
      final result = await controller.call_searchUsersAndGroups(value);

      data[0].value = List.from(result['users']).map((e) => UsersModel().fromJson(e)).toList();
      data[1].value = Helper.convertToListMap(result['groups']);
      data[2].value = Helper.convertToListMap(result['posts']);
    });
  }
}
