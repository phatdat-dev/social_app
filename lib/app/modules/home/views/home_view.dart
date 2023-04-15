import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/constants/translate_key_constant.dart';

import '../controllers/home_controller.dart';

part 'dashboard_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController controller;
  late final List<Widget> widgetPage;
  late ValueNotifier<int> currentIndexBottomNav;

  @override
  void initState() {
    controller = context.read<HomeController>();
    controller.onInitData();
    widgetPage = [
      DashboardView(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
    ];
    currentIndexBottomNav = ValueNotifier(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //huy keyboard khi bam ngoai man hinh
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: ValueListenableBuilder(
        valueListenable: currentIndexBottomNav,
        builder: (BuildContext context, value, Widget? child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            // extendBody: true,
            extendBodyBehindAppBar: true,
            // drawer: HomeDrawerWidget(),
            body: widgetPage.elementAt(currentIndexBottomNav.value),
            //Footer
            bottomNavigationBar: DecoratedBox(
              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)), boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(0, 8), // changes position of shadow
                )
              ]),
              child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                  child: BottomNavigationBar(
                    //backgroundColor: Colors.amber,
                    type: BottomNavigationBarType.fixed, //ko cho no thu nho? mat chu~
                    currentIndex: currentIndexBottomNav.value,
                    selectedIconTheme: const IconThemeData(size: 30),
                    //selectedItemColor: Colors.indigo,
                    onTap: (index) => currentIndexBottomNav.value = index,
                    items: [
                      bottomNavBarItem(context, label: TranslateKeys.Home.tr(), iconData: Icons.home_outlined),
                      bottomNavBarItem(context, label: 'Message', iconData: Icons.message_outlined),
                      bottomNavBarItem(context, label: 'Daily Task', iconData: Icons.task_outlined),
                      bottomNavBarItem(context, label: 'Profile', iconData: Icons.person_outline),
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }

  BottomNavigationBarItem bottomNavBarItem(BuildContext context, {required String label, required IconData iconData}) => BottomNavigationBarItem(
      icon: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Icon(iconData, color: Theme.of(context).colorScheme.primary)),
      label: label,
      activeIcon: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Icon(iconData, color: Colors.white)));
}
