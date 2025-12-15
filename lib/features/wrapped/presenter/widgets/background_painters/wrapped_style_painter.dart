import 'dart:math';
import 'package:flutter/material.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';

abstract class WrappedStylePainter {
  void paint(Canvas canvas, Size size, Random rng, double t,
      WrappedPalette palette, int seed);
}
