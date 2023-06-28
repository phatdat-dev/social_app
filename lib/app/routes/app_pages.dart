import 'dart:convert';
import 'dart:math';

import 'package:ckc_social_app/app/modules/user/views/user_editing_view.dart';
import 'package:ckc_social_app/app/modules/videoCall/bindings/video_call_binding.dart';
import 'package:ckc_social_app/app/modules/videoCall/views/video_call_detail_view.dart';
import 'package:ckc_social_app/app/modules/videoCall/views/video_call_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/config/theme_config.dart';
import '../core/constants/app_constant.dart';
import '../models/users_model.dart';
import '../modules/authentication/controllers/authentication_controller.dart';
import '../modules/authentication/views/authentication_view.dart';
import '../modules/group/controllers/group_controller.dart';
import '../modules/group/views/group_create_view.dart';
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

  static Transition get randomTransition {
    const translations = Transition.values;
    return translations[Random().nextInt(translations.length)];
  }

  static const INITIAL = _Paths.HOME;

  static final routes = [
    GetPage(
      name: _Paths.AUTHENTICATION,
      transition: randomTransition,
      page: () => const AuthenticationView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => AuthenticationController())),
    ),
    GetPage(
      name: _Paths.HOME,
      transition: randomTransition,
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
      transition: randomTransition,
      page: () => const ThemeView(),
    ),
    GetPage(
      name: _Paths.MESSAGE,
      transition: randomTransition,
      page: () => const MessageView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => MessageController())),
      children: [
        GetPage(
          name: '${_Paths.DETAIL}/:id', // /message/detail/:id
          transition: randomTransition,
          page: () => const MessageDetailView(),
        ),
        GetPage(
          name: _Paths.SEARCH, // /message/search
          transition: randomTransition,
          page: () => MessageSearchView(),
        ),
        GetPage(
            name: '${_Paths.SETTING_PROFILE}/:id', // /message/setting-profile/:id
            transition: randomTransition,
            page: () => MessageSettingProfileView(),
            children: [
              GetPage(
                name: _Paths.MEMBERS, // /message/setting-profile/:id/members
                transition: randomTransition,
                page: () => const MessageSettingProfileMembersView(),
              ),
            ]),
      ],
    ),
    GetPage(
      name: '${_Paths.GROUP}${_Paths.CREATE}', // /post/create
      transition: randomTransition,
      page: () => const GroupCreateView(),
    ),
    GetPage(
        name: '${_Paths.GROUP}/:id',
        transition: randomTransition,
        page: () => const GroupView(),
        binding: BindingsBuilder(() => Get.lazyPut(() => GroupController())),
        children: [
          GetPage(
              name: _Paths.INFOMATION, // /group/:id/infomation
              transition: randomTransition,
              page: () => const GroupInfomationView(),
              children: [
                GetPage(
                  name: _Paths.MEMBERS, // /group/:id/infomation/members
                  transition: randomTransition,
                  page: () => const GroupMembersView(),
                ),
              ]),
        ]),
    GetPage(
      name: '${_Paths.USER}/:id', // /user/:id
      transition: randomTransition,
      page: () => const UserView(),
      binding: BindingsBuilder(() {
        final id = int.tryParse(Get.parameters['id'] ?? '') ?? 0;
        Get.lazyPut(() => UserController(id), tag: '$id');
      }),
      children: [
        GetPage(
          name: _Paths.FRIEND, // /user/:id/friend
          transition: randomTransition,
          page: () => const UserFriendView(),
        ),
        GetPage(
          name: _Paths.EDITING, // /user/:id/editing
          transition: randomTransition,
          page: () => const UserEditingView(),
        ),
      ],
    ),
    GetPage(
      name: '${_Paths.STORIES}/:id', // /stories/:id
      transition: randomTransition,
      page: () => const StoriesView(),

      // binding: BindingsBuilder(() => Get.lazyPut(() => StoriesController())),
    ),
    GetPage(
      name: '${_Paths.POST}${_Paths.CREATE}', // /post/create
      transition: randomTransition,
      page: () => PostCreateView(postResponseModel: Get.arguments),
    ),
    GetPage(
      name: '${_Paths.POST}/:id', // /post/:id
      transition: randomTransition,
      page: () => const Scaffold(),
      children: [
        GetPage(
          name: _Paths.HISTORY, // /post/:id/history
          transition: randomTransition,
          page: () {
            final id = int.tryParse(Get.parameters['id'] ?? '') ?? 0;
            return PostHistoryView(postId: id);
          },
        ),
      ],
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      transition: randomTransition,
      page: () => const NotificationView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => NotificationController())),
    ),
    GetPage(name: _Paths.VIDEO_CALL, transition: randomTransition, page: () => const VideoCallView(), binding: VideoCallBinding(), children: [
      GetPage(
        name: _Paths.DETAIL,
        transition: randomTransition,
        page: () => VideoCallDetailView(chanelName: Get.arguments['chanelName']),
      )
    ])
  ];
}
