import 'package:flutter/material.dart';

import '../constants/color_constant.dart';

class ThemeConfig extends ColorConstants {
  ThemeData get lightTheme => ThemeData.light().copyWith(
        brightness: Brightness.light,
        primaryColor: ColorConstants.pink800,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: ColorConstants.pink800).copyWith(
          secondary: ColorConstants.pink500,
          inversePrimary: Colors.white,
        ),

        // scaffoldBackgroundColor: ColorConstants.pink500,
        appBarTheme: AppBarTheme(
          // iconTheme: IconThemeData(color: ColorConstants.pink800),
          // titleTextStyle: TextStyle(color: ColorConstants.pink800, fontWeight: FontWeight.bold),
          // backgroundColor: Colors.white,
          elevation: 2,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //side: const BorderSide(color: Colors.pink)
          ),
          //shadowColor: MaterialStateProperty.all<Color>(Colors.red),
          //elevation: MaterialStateProperty.all<double>(0),
          backgroundColor: ColorConstants.pink800, //background
        )),
        // textTheme: TextTheme(
        //   displayLarge: TextStyle(color: ColorConstants.blue800),
        //   displayMedium: TextStyle(color: ColorConstants.blue800),
        //   displaySmall: TextStyle(color: ColorConstants.blue800),
        //   headlineMedium: TextStyle(color: ColorConstants.blue800),
        //   headlineSmall: TextStyle(color: ColorConstants.blue800),
        //   titleLarge: TextStyle(color: ColorConstants.blue800),
        //   titleMedium: TextStyle(color: ColorConstants.blue800),
        //   titleSmall: TextStyle(color: ColorConstants.blue800),
        //   bodyLarge: TextStyle(color: ColorConstants.blue800),
        //   bodyMedium: TextStyle(color: ColorConstants.blue800),
        //   bodySmall: TextStyle(color: ColorConstants.blue800),
        //   labelLarge: TextStyle(color: ColorConstants.blue800),
        //   labelSmall: TextStyle(color: ColorConstants.blue800),
        // ),
        // listTileTheme: ListTileThemeData(textColor: ColorConstants.pink800),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          // backgroundColor: ColorConstants.pink800,
          //type: BottomNavigationBarType.fixed, //ko cho no thu nho? mat chu~
          //selectedIconTheme: const IconThemeData(size: 30),
          showSelectedLabels: true,
          // selectedItemColor: Colors.white,
          // unselectedItemColor: Colors.white,
        ),
        popupMenuTheme: const PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //side: const BorderSide(color: Colors.pink)
          ),
        ),
      );

  ThemeData get dartTheme => ThemeData.dark();
}
