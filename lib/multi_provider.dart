part of 'main.dart';

extension MyAppMultiProvider on MyApp {
  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (context) => PickerService()),
        ChangeNotifierProvider(create: (context) => AuthenticationController()),
        ChangeNotifierProvider(create: (context) => HomeController()),
      ];
}
