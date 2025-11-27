import 'package:sentiment_analysis_app/core/ui/styles/custom_colors.dart';
import 'package:sentiment_analysis_app/core/ui/styles/text_styles.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static AppStyles? _instance;

  AppStyles._();

  static AppStyles get instance => _instance ??= AppStyles._();

  ButtonStyle get primaryButton => ElevatedButton.styleFrom(
        backgroundColor: CustomColors.instance.primary,
        foregroundColor: Colors.white,
        textStyle: TextStyles.instance.textButtonLabel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      );

  OutlineInputBorder get defaultInputBorder => OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color: CustomColors.instance.secondary.withAlpha(30),
        ),
      );
}

extension AppStylesExtension on BuildContext {
  AppStyles get appStyles => AppStyles.instance;
}
