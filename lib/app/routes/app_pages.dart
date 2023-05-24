import 'dart:convert';

import 'package:get/get.dart';

import '../core/config/theme_config.dart';
import '../core/constants/app_constant.dart';
import '../models/users_model.dart';
import '../modules/authentication/controllers/authentication_controller.dart';
import '../modules/authentication/views/authentication_view.dart';
import '../modules/group/controllers/group_controller.dart';
import '../modules/group/views/group_infomation_view.dart';
import '../modules/group/views/group_members_view.dart';
import '../modules/group/views/group_view.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/home/views/home_view.dart';
import '../modules/message/controllers/message_controller.dart';
import '../modules/message/views/message_detail_view.dart';
import '../modules/message/views/message_search_view.dart';
import '../modules/message/views/message_setting_profile_members_view.dart';
import '../modules/message/views/message_setting_profile_view.dart';
import '../modules/message/views/message_view.dart';
import '../modules/user/controllers/user_controller.dart';
import '../modules/user/views/user_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = _Paths.HOME;

  static final routes = [
    GetPage(
      name: _Paths.AUTHENTICATION,
      page: () => const AuthenticationView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => AuthenticationController())),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => HomeController())),
    ),
    GetPage(
      name: '/viewColorTheme',
      page: () => const ThemeView(),
    ),
    GetPage(
      name: _Paths.MESSAGE,
      page: () => const MessageView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => MessageController())),
      children: [
        GetPage(
          name: '${_Paths.DETAIL}/:id', // /message/detail/:id
          page: () => const MessageDetailView(),
        ),
        GetPage(
          name: _Paths.SEARCH, // /message/search
          page: () => MessageSearchView(),
        ),
        GetPage(
            name: '${_Paths.SETTING_PROFILE}/:id', // /message/setting-profile/:id
            page: () => MessageSettingProfileView(),
            children: [
              GetPage(
                name: _Paths.MEMBERS, // /message/setting-profile/:id/members
                page: () => const MessageSettingProfileMembersView(),
              ),
            ]),
      ],
    ),
    GetPage(
        name: '${_Paths.GROUP}/:id',
        page: () => const GroupView(),
        binding: BindingsBuilder(() => Get.lazyPut(() => GroupController())),
        children: [
          GetPage(
              name: _Paths.INFOMATION, // /group/:id/infomation
              page: () => const GroupInfomationView(),
              children: [
                GetPage(
                  name: _Paths.MEMBERS, // /group/:id/infomation/members
                  page: () => const GroupMembersView(),
                ),
              ]),
        ]),
    GetPage(
      name: '${_Paths.USER}/:id',
      page: () => const UserView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => UserController())),
    ),
  ];

  static void routingCallback(Routing? routing) {
    if (AuthenticationController.userAccount == null) {
      //kiểm tra xem bộ nhớ có lưu thông tin đăng nhập trước hay không
      final userAccountString = Global.sharedPreferences.getString(StorageConstants.userAccount);
      if (userAccountString != null) {
        //nếu có thì lấy thông tin đăng nhập
        AuthenticationController.userAccount = UsersModel().fromJson(jsonDecode(userAccountString));
        Get.offAllNamed(Routes.HOME());
      }
      //nếu chưa đăng nhập thì chuyển về màn hình đăng nhập
      Get.offNamed(Routes.AUTHENTICATION());
    }
  }
}
