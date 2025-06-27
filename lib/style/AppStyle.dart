import 'package:flutter/material.dart';
import 'package:t0d0/style/AppColors.dart';

class AppStyle {
  static ThemeData lightTheme = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Appcolors.lightPrimaryColor,
      shape: StadiumBorder(side: BorderSide(color: Colors.white, width: 4)),
    ),
    scaffoldBackgroundColor: Appcolors.lightBackGround,
    appBarTheme: AppBarTheme(elevation: 0,
      backgroundColor: Appcolors.lightPrimaryColor,
      toolbarHeight: 157,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      titleMedium: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Appcolors.lightPrimaryColor),
      labelSmall: TextStyle(fontSize: 12, color: Appcolors.labelColor),
      titleSmall: TextStyle(fontSize: 18, color: Colors.black),
      bodySmall: TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Appcolors.lightPrimaryColor,
      primary: Appcolors.lightPrimaryColor,
    ),
    useMaterial3: false,
  );
}
