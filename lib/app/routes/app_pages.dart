import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/config/theme_config.dart';
import 'package:social_app/app/core/constants/app_constant.dart';
import 'package:social_app/app/models/users_model.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/modules/authentication/views/authentication_view.dart';
import 'package:social_app/app/modules/home/views/home_view.dart';
import 'package:social_app/app/modules/message/controllers/message_controller.dart';
import 'package:social_app/app/modules/message/views/message_setting_profile_view.dart';
import 'package:social_app/app/modules/message/views/message_view.dart';

import '../modules/message/views/message_detail_view.dart';
import '../modules/message/views/message_search_view.dart';

// https://pub.dev/documentation/go_router/latest/topics/Get%20started-topic.html
// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  static const INITIAL = '/';

  //context.Go
  static final router = GoRouter(
    initialLocation: AppPages.INITIAL,
    navigatorKey: Global.navigatorKey,
    debugLogDiagnostics: true, //show log
    redirect: (context, state) {
      if (AuthenticationController.userAccount == null) {
        //kiểm tra xem bộ nhớ có lưu thông tin đăng nhập trước hay không
        final userAccountString = Global.sharedPreferences.getString(StorageConstants.userAccount);
        if (userAccountString != null) {
          //nếu có thì lấy thông tin đăng nhập
          AuthenticationController.userAccount = UsersModel().fromJson(jsonDecode(userAccountString));
          return null;
        }
        //nếu chưa đăng nhập thì chuyển về màn hình đăng nhập
        return '/authentication';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeView(),
        // routes: <RouteBase>[
        //   GoRoute(
        //     path: 'details',
        //     builder: (context,state) {
        //       return const DetailsScreen();
        //     },
        //   ),
        // ],
      ),
      GoRoute(path: '/viewColorTheme', builder: (context, state) => const ThemeView()),
      GoRoute(
        path: '/authentication',
        builder: (context, state) => const AuthenticationView(),
        routes: [],
      ),
      GoRoute(
        path: '/message',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => MessageController(),
          child: const MessageView(),
        ),
        routes: [
          GoRoute(
            path: 'detail/:id', // /message/detail/:id
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              return ChangeNotifierProvider.value(
                  value: extra['controller'] as MessageController, child: MessageDetailView(extra['chatRoomId'], extra['user']));
            },
          ),
          GoRoute(
            path: 'search', // /message/search
            builder: (context, state) => ChangeNotifierProvider.value(
              value: state.extra as MessageController,
              child: MessageSearchView(),
            ),
          ),
          GoRoute(
            path: 'settingProfile/:id', // /message/settingProfile
            builder: (context, state) => ChangeNotifierProvider.value(
              value: state.extra as MessageController,
              child: MessageSettingProfileView(),
            ),
          ),
        ],
      ),
    ],
  );
}
