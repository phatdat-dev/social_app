
import 'dart:convert';

import 'package:flutter/material.dart';

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
import '../modules/notification/controllers/notification_controller.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/post/views/post_create_view.dart';
import '../modules/post/views/post_history_view.dart';
import '../modules/stories/views/stories_view.dart';
import '../modules/user/controllers/user_controller.dart';
import '../modules/user/views/user_friend_view.dart';
import '../modules/user/views/user_view.dart';





part 'app_middleware.dart';
// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = _Paths.HOME;

  static final routes = [
    GetPage(
      name: _Paths.AUTHENTICATION,
      page: () => const AuthenticationView(),
      binding:
          BindingsBuilder(() => Get.lazyPut(() => AuthenticationController())),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        final homeController = Get.put(HomeController());
        Get.put(homeController.postController);
        Get.put(homeController.storiesController);
        Get.put(homeController.notificationController);
      }),
      middlewares: [AuthenticationMiddleware()],
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
            name:
                '${_Paths.SETTING_PROFILE}/:id', // /message/setting-profile/:id
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
      name: '${_Paths.USER}/:id', // /user/:id
      page: () => const UserView(),
      binding: BindingsBuilder(() {
        final id = int.tryParse(Get.parameters['id'] ?? '') ?? 0;
        Get.lazyPut(() => UserController(id), tag: '$id');
      }),
      children: [
        GetPage(
          name: _Paths.FRIEND, // /user/:id/friend
          page: () => const UserFriendView(),
        )
      ],
    ),
    GetPage(
      name: '${_Paths.STORIES}/:id', // /stories/:id
      page: () => const StoriesView(),
      transition: Transition.circularReveal,
      // binding: BindingsBuilder(() => Get.lazyPut(() => StoriesController())),
    ),
    GetPage(
      name: '${_Paths.POST}${_Paths.CREATE}', // /post/create
      page: () => PostCreateView(postResponseModel: Get.arguments),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '${_Paths.POST}/:id', // /post/:id
      page: () => const Scaffold(),
      children: [
        GetPage(
          name: _Paths.HISTORY, // /post/:id/history
          page: () {
            final id = int.tryParse(Get.parameters['id'] ?? '') ?? 0;
            return PostHistoryView(postId: id);
          },
          transition: Transition.size,
        ),
      ],
    ),
    GetPage(
      name: _Paths.NOTIFICATION, 
      page:()=> const NotificationView(), 
      binding: BindingsBuilder(() => Get.lazyPut(() => NotificationController())),
    ),
  ];
}