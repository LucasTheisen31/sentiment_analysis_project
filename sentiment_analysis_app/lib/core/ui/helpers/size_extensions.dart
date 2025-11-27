import 'package:flutter/material.dart';

extension SizeExtensions on BuildContext {
  // Largura e altura da tela
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Menor tamanho da tela (entre largura e altura)
  // Maior tamanho da tela (entre largura e altura)
  double get screenShortestSide => MediaQuery.of(this).size.shortestSide;
  double get screenLongestSideSide => MediaQuery.of(this).size.longestSide;

  // Proporções da tela
  double percentageWidth(double percent) => MediaQuery.of(this).size.width * percent;
  double percentageHeight(double percent) => MediaQuery.of(this).size.height * percent;
}
