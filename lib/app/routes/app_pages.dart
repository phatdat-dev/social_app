import 'package:go_router/go_router.dart';
import 'package:social_app/app/core/config/theme_config.dart';
import 'package:social_app/app/core/constants/global_constant.dart';
import 'package:social_app/app/modules/home/views/home_view.dart';

// https://pub.dev/documentation/go_router/latest/topics/Get%20started-topic.html
// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  static const INITIAL = "/";

  //context.Go
  static final router = GoRouter(
    initialLocation: AppPages.INITIAL,
    navigatorKey: Global.navigatorKey,
    debugLogDiagnostics: true, //show log
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => HomeView(),
        // routes: <RouteBase>[
        //   GoRoute(
        //     path: 'details',
        //     builder: (context,state) {
        //       return const DetailsScreen();
        //     },
        //   ),
        // ],
      ),
      GoRoute(path: "/viewColorTheme", builder: (context, state) => ThemeView()),
      GoRoute(
        path: "/${_Path.HOME}",
        builder: (context, state) => HomeView(),
        routes: [],
      ),
    ],
  );
}
