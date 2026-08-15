import 'package:flutter/material.dart';

import 'app_color.dart';
import 'app_text_style.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.primary,
      ),

      scaffoldBackgroundColor: AppColor.pageBackground,

      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            50,
          ),
          textStyle: AppTextStyle.button,
        ),
      ),
    );
  }
}