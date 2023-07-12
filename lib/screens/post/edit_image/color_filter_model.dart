import 'package:flutter/material.dart';

class ColorFilterModel {
  String name;
  List<Color>? color;
  List<double>? matrix;

  BlendMode? blendMode;
  Color? filterColor;

  ColorFilterModel({required this.name, this.color, this.blendMode, this.filterColor, this.matrix});
}