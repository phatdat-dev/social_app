import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/color_constant.dart';

class ThemeConfig with ChangeNotifier, ColorConstants {
  ThemeMode _defaultThemeMode = ThemeMode.light;

  ThemeMode get defaultThemeMode => _defaultThemeMode;
  set defaultThemeMode(ThemeMode themeMode) {
    _defaultThemeMode = themeMode;
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      // useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.blue.shade50,
      ),

      // scaffoldBackgroundColor: ColorConstants.pink500,
      appBarTheme: const AppBarTheme(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, //<-- SEE HERE
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.blueAccent,
        unselectedLabelColor: Colors.grey,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //side: const BorderSide(color: Colors.pink)
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.blue.shade50,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //side: const BorderSide(color: Colors.pink)
        ),
        //shadowColor: MaterialStateProperty.all<Color>(Colors.red),
        //elevation: MaterialStateProperty.all<double>(0),
        // backgroundColor: ColorConstants.pink800, //background
      )),
    );
  }

  ThemeData get dartTheme => ThemeData.dark(
      // useMaterial3: true,
      );
}

class ThemeView extends StatelessWidget {
  const ThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeConfig = context.read<ThemeConfig>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Theme'),
            bottom: TabBar(
              // isScrollable: true,
              onTap: (value) {
                switch (value) {
                  case 0:
                    if (themeConfig.defaultThemeMode != ThemeMode.light) themeConfig.defaultThemeMode = ThemeMode.light;
                    break;
                  case 1:
                    if (themeConfig.defaultThemeMode != ThemeMode.dark) themeConfig.defaultThemeMode = ThemeMode.dark;
                    break;
                  default:
                }
              },
              tabs: [
                const Tab(text: 'Light'),
                const Tab(text: 'Dark'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Theme(data: themeConfig.lightTheme, child: _buildThemeColor(context)),
              Theme(data: themeConfig.dartTheme, child: _buildThemeColor(context)),
            ],
          )),
    );
  }

  ListView _buildThemeColor(BuildContext context) {
    return ListView(
      children: [
        GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            buildColorTheme(Theme.of(context).canvasColor, 'canvasColor'),
            buildColorTheme(Theme.of(context).cardColor, 'cardColor'),
            buildColorTheme(Theme.of(context).dialogBackgroundColor, 'dialogBackgroundColor'),
            buildColorTheme(Theme.of(context).disabledColor, 'disabledColor'),
            buildColorTheme(Theme.of(context).dividerColor, 'dividerColor'),
            buildColorTheme(Theme.of(context).focusColor, 'focusColor'),
            buildColorTheme(Theme.of(context).highlightColor, 'highlightColor'),
            buildColorTheme(Theme.of(context).hintColor, 'hintColor'),
            buildColorTheme(Theme.of(context).hoverColor, 'hoverColor'),
            buildColorTheme(Theme.of(context).indicatorColor, 'indicatorColor'),
            buildColorTheme(Theme.of(context).primaryColor, 'primaryColor'),
            buildColorTheme(Theme.of(context).primaryColorDark, 'primaryColorDark'),
            buildColorTheme(Theme.of(context).primaryColorLight, 'primaryColorLight'),
            buildColorTheme(Theme.of(context).scaffoldBackgroundColor, 'scaffoldBackgroundColor'),
            buildColorTheme(Theme.of(context).secondaryHeaderColor, 'secondaryHeaderColor'),
            buildColorTheme(Theme.of(context).shadowColor, 'shadowColor'),
            buildColorTheme(Theme.of(context).splashColor, 'splashColor'),
            buildColorTheme(Theme.of(context).unselectedWidgetColor, 'unselectedWidgetColor'),
          ],
        ),
        const Divider(thickness: 2, color: Colors.cyan),
        //build colorSheme
        GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            buildColorTheme(Theme.of(context).colorScheme.primary, 'primary'),
            buildColorTheme(Theme.of(context).colorScheme.onPrimary, 'onPrimary'),
            buildColorTheme(Theme.of(context).colorScheme.primaryContainer, 'primaryContainer'),
            buildColorTheme(Theme.of(context).colorScheme.onPrimaryContainer, 'onPrimaryContainer'),
            buildColorTheme(Theme.of(context).colorScheme.secondary, 'secondary'),
            buildColorTheme(Theme.of(context).colorScheme.onSecondary, 'onSecondary'),
            buildColorTheme(Theme.of(context).colorScheme.secondaryContainer, 'secondaryContainer'),
            buildColorTheme(Theme.of(context).colorScheme.onSecondaryContainer, 'onSecondaryContainer'),
            buildColorTheme(Theme.of(context).colorScheme.tertiary, 'tertiary'),
            buildColorTheme(Theme.of(context).colorScheme.onTertiary, 'onTertiary'),
            buildColorTheme(Theme.of(context).colorScheme.tertiaryContainer, 'tertiaryContainer'),
            buildColorTheme(Theme.of(context).colorScheme.onTertiaryContainer, 'onTertiaryContainer'),
            buildColorTheme(Theme.of(context).colorScheme.error, 'error'),
            buildColorTheme(Theme.of(context).colorScheme.onError, 'onError'),
            buildColorTheme(Theme.of(context).colorScheme.errorContainer, 'errorContainer'),
            buildColorTheme(Theme.of(context).colorScheme.onErrorContainer, 'onErrorContainer'),
            buildColorTheme(Theme.of(context).colorScheme.background, 'background'),
            buildColorTheme(Theme.of(context).colorScheme.onBackground, 'onBackground'),
            buildColorTheme(Theme.of(context).colorScheme.surface, 'surface'),
            buildColorTheme(Theme.of(context).colorScheme.onSurface, 'onSurface'),
            buildColorTheme(Theme.of(context).colorScheme.surfaceVariant, 'surfaceVariant'),
            buildColorTheme(Theme.of(context).colorScheme.onSurfaceVariant, 'onSurfaceVariant'),
            buildColorTheme(Theme.of(context).colorScheme.outline, 'outline'),
            buildColorTheme(Theme.of(context).colorScheme.outlineVariant, 'outlineVariant'),
            buildColorTheme(Theme.of(context).colorScheme.shadow, 'shadow'),
            buildColorTheme(Theme.of(context).colorScheme.scrim, 'scrim'),
            buildColorTheme(Theme.of(context).colorScheme.inverseSurface, 'inverseSurface'),
            buildColorTheme(Theme.of(context).colorScheme.onInverseSurface, 'onInverseSurface'),
            buildColorTheme(Theme.of(context).colorScheme.inversePrimary, 'inversePrimary'),
            buildColorTheme(Theme.of(context).colorScheme.surfaceTint, 'surfaceTint'),
          ],
        ),
      ],
    );
  }

  Widget buildColorTheme(Color color, String name) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 100,
          color: color,
        ),
        Text(name, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
