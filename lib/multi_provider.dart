part of 'main.dart';

extension MyAppMultiProvider on MyApp {
  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (context) => ThemeConfig()),
        ChangeNotifierProvider(create: (context) => FireBaseService()),
        ChangeNotifierProvider(create: (context) => AuthenticationController()),
        ChangeNotifierProvider(create: (context) => HomeController()),
      ];
}
