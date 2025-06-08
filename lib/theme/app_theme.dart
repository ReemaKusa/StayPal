import 'package:flutter/material.dart';
import 'package:staypal/constants/color_constants.dart';
import 'package:staypal/constants/app_constants.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.white,
  fontFamily: 'Roboto',
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.deepOrange,
  ).copyWith(
    secondary: AppColors.primary,
    primary: AppColors.primary,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.black,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: AppFontSizes.title,
      fontWeight: FontWeight.bold,
      color: AppColors.black,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.grey,
    backgroundColor: AppColors.white,
    selectedLabelStyle: TextStyle(fontSize: AppFontSizes.body),
    unselectedLabelStyle: TextStyle(fontSize: AppFontSizes.body),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: AppFontSizes.body),
    bodyMedium: TextStyle(fontSize: AppFontSizes.body),
    bodySmall: TextStyle(fontSize: AppFontSizes.body),
  ),
);