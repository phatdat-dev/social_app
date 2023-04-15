import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({Key? key}) : super(key: key);
  @override
  _AuthenticationViewState createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> with SingleTickerProviderStateMixin {
  late final AuthenticationController controller;
  late final TabController tabController;
  late final List<Tab> listTabBar;

  @override
  void initState() {
    // Printt.white("init AuthenticationView");
    listTabBar = [
      Tab(text: TranslateKeys.SignIn.tr()),
      Tab(text: TranslateKeys.SignUp.tr()),
    ];
    tabController = TabController(length: listTabBar.length, vsync: this);
    //
    controller = context.read<AuthenticationController>();
    controller.onInitData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = 10.0;
    return GestureDetector(
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: Scaffold(
        key: controller.key,
        body: ListView(
          children: [
            Center(child: Text("asdasd")),
          ],
        ),
      ),
    );
  }
}
