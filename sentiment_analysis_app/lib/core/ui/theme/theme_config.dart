import 'package:sentiment_analysis_app/core/ui/styles/app_styles.dart';
import 'package:sentiment_analysis_app/core/ui/styles/custom_colors.dart';
import 'package:sentiment_analysis_app/core/ui/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ThemeConfig {
  ThemeConfig._();

  static final defaultTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: Colors.black.withAlpha(5),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
      backgroundColor: CustomColors.instance.primary,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: CustomColors.instance.primary,
      primary: CustomColors.instance.primary,
      secondary: CustomColors.instance.secondary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: AppStyles.instance.primaryButton,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.all(20),
      fillColor: Colors.white,
      border: AppStyles.instance.defaultInputBorder,
      enabledBorder: AppStyles.instance.defaultInputBorder,
      focusedBorder: AppStyles.instance.defaultInputBorder.copyWith(
        borderSide: BorderSide(
          color: CustomColors.instance.primary,
          width: 2,
        ),
      ),
      labelStyle: TextStyles.instance.textRegular.copyWith(color: CustomColors.instance.secondary),
      floatingLabelStyle: TextStyles.instance.textRegular.copyWith(color: CustomColors.instance.primary),
      //errorStyle:TextStyles.instance.textRegular.copyWith(color: Colors.redAccent),
    ),
  );
}
