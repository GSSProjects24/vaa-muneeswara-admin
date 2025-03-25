import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle textStyle(double size, Color color, {FontWeight? weight}) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: weight,
    );
  }
}
