import 'package:flutter/material.dart';

class SizerUtil {
  /// Device's BoxConstraints
  static late BoxConstraints boxConstraints;


  /// Device's Height
  static late double height;

  /// Device's Width
  static late double width;

  /// Sets the Screen's size and Device's Orientation,
  /// BoxConstraints, Height, and Width
  static void setScreenSize(BoxConstraints constraints,
      ) {
    // Sets boxconstraints and orientation
    boxConstraints = constraints;
    //
      width = boxConstraints.maxWidth;
      height = boxConstraints.maxHeight;
  }
}