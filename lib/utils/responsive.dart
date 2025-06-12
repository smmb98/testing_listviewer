import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockWidth;
  static late double blockHeight;
  static late Orientation orientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;

    // 100 blocks = 100% width/height
    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;
  }

  static double wp(double percent) => blockWidth * percent;
  static double hp(double percent) => blockHeight * percent;

  /// Font scaling based on screen width
  static double sp(double percent) => wp(percent);
}
