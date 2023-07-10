import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom/widget/search_widget.dart';

class TabbarSearchBuilder {
  final TabbarSearchModel model;
  final Widget Function(dynamic element) itemBuilder;

  TabbarSearchBuilder({
    required this.model,
    required this.itemBuilder,
  });
}

class TabbarSearchModel<T> {
  final String title;
  final RxList<T> listOrigin;
  late final RxList<T> listSearch;
  final ValueChanged<String>? onChangedSearchText;

  TabbarSearchModel({
    required this.title,
    required this.listOrigin,
    this.onChangedSearchText,
  }) {
    listSearch = RxList.from(listOrigin);
    listOrigin.listen((p0) {
      //update lại biến search khi api call thành công
      listSearch.value = p0;
    });
  }
}

mixin TabbarSearchView<T extends StatefulWidget> on State<T> implements TickerProvider {
  late final TabController tabBarController;
  late final List<TabbarSearchBuilder> tabBarWidget;
  final searchText = TextEditingController();
  String get title;

  void onInitTabbarWidget(); //init List<TabbarSearchBuilder> tabBarWidget; here

  @override
  void initState() {
    super.initState();
    onInitTabbarWidget();
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
                        tabs: tabBarWidget.map((e) => Tab(text: e.model.title.tr)).toList(),
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
                          onChanged: tabBarWidget[tabBarController.index].model.onChangedSearchText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: tabBarController,
              children: tabBarWidget
                  .mapIndexed((index, e) => Obx(() => ListView(
                        padding: EdgeInsets.zero,
                        children: e.model.listSearch.map((e2) => e.itemBuilder.call(e2)).toList(),
                      )))
                  .toList(),
            ),
          ),
        ),
        //Footer
      ),
    );
  }
}
