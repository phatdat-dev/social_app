part of 'main.dart';

extension MyAppMultiProvider on _MyAppState {
  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (context) => ThemeConfig()),
        ChangeNotifierProvider.value(value: _fireBaseService),
        ChangeNotifierProvider(create: (context) => AuthenticationController()),
        ChangeNotifierProvider(create: (context) => HomeController()),
      ];
}
