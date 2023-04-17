import 'package:flutter/material.dart';

import '../constants/color_constant.dart';

class ThemeConfig extends ColorConstants {
  ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      brightness: Brightness.light,

      // scaffoldBackgroundColor: ColorConstants.pink500,
      appBarTheme: AppBarTheme(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, //<-- SEE HERE
      ),

      tabBarTheme: TabBarTheme(
        labelColor: Colors.blueAccent,
        unselectedLabelColor: Colors.grey,
      ),

      popupMenuTheme: const PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //side: const BorderSide(color: Colors.pink)
        ),
      ),
    );
  }

  ThemeData get dartTheme => ThemeData.dark();
}
