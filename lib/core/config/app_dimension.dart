
import 'package:custom_map/core/config/utill/dimension_utill.dart';
import 'package:flutter/material.dart';

class AppDimension{
  static TextTheme textSize(context) => Theme.of(context).textTheme;
}

extension SizeExtension on num {

  double get h => this * SizerUtil.height / 100;


  double get w => this * SizerUtil.width / 100;

  double get sp => this * (SizerUtil.width / 3) / 100;
}
