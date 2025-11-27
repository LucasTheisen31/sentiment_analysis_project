import 'package:flutter/material.dart';

class CustomColors {
  static CustomColors? _instance;

  CustomColors._();

  static CustomColors get instance => _instance ??= CustomColors._();

  Color get primary => const Color(0xFF2E3E5C);
  Color get secondary => const Color(0xFF9FA5C0);
  Color get outline => const Color(0xFFD0DBEA);
  Color get form => const Color(0xFFF4F5F7);
  Color get green => const Color(0xFF1FCC79);
  Color get red => const Color(0xFFFF6464);
  Color get black => const Color(0XFF140E0E);
}

extension CustomColorsExtension on BuildContext {
  CustomColors get customColors => CustomColors.instance;
}
