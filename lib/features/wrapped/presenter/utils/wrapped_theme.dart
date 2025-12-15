import 'dart:math';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class WrappedPalette {
  final Color background;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color text;

  const WrappedPalette({
    required this.background,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.text,
  });

  bool get isDark => background.computeLuminance() < 0.5;

  factory WrappedPalette.fromSeed(Color seedColor,
      {Brightness brightness = Brightness.dark}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    if (brightness == Brightness.dark) {
      return WrappedPalette(
        background: colorScheme.surface,
        primary: colorScheme.primary,
        secondary: colorScheme.secondary,
        accent: colorScheme.tertiary,
        text: colorScheme.onSurface,
      );
    } else {
      return WrappedPalette(
        background: colorScheme.surface,
        primary: colorScheme.primary,
        secondary: colorScheme.secondary,
        accent: colorScheme.tertiary,
        text: colorScheme.onSurface,
      );
    }
  }
}

enum WrappedStyle {
  lines,
  particles,
  honeycomb,
  galaxy,
  tech;

  static const darkOnlyStyles = {
    WrappedStyle.galaxy,
    WrappedStyle.tech,
  };

  bool get requiresDarkMode => darkOnlyStyles.contains(this);
}

class WrappedTheme {
  final WrappedPalette palette;
  final WrappedStyle style;
  final int seed;

  const WrappedTheme({
    required this.palette,
    required this.style,
    required this.seed,
  });

  WrappedPalette get effectivePalette {
    if (style.requiresDarkMode && !palette.isDark) {
      return WrappedPalette(
        background: _darkenColor(palette.background, 0.85),
        primary: palette.primary,
        secondary: palette.secondary,
        accent: palette.accent,
        text: Colors.white,
      );
    }
    return palette;
  }

  static Color _darkenColor(Color color, double factor) {
    return Color.fromARGB(
      color.intAlpha,
      (color.r * (1 - factor)).round().clamp(0, 255),
      (color.g * (1 - factor)).round().clamp(0, 255),
      (color.b * (1 - factor)).round().clamp(0, 255),
    );
  }

  WrappedTheme copyWith({
    WrappedPalette? palette,
    WrappedStyle? style,
    int? seed,
  }) {
    return WrappedTheme(
      palette: palette ?? this.palette,
      style: style ?? this.style,
      seed: seed ?? this.seed,
    );
  }

  factory WrappedTheme.fromSeed(int seed) {
    final rng = Random(seed);

    final seedColors = [
      const Color(0xFF764AF1),
      const Color(0xFF38BDF8),
      const Color(0xFF22C55E),
      const Color(0xFFEF4444),
      const Color(0xFFF97316),
      const Color(0xFFEC4899),
      const Color(0xFF8B5CF6),
      const Color(0xFF06B6D4),
      const Color(0xFFFACC15),
      const Color(0xFF14B8A6),
      const Color(0xFFF43F5E),
      const Color(0xFF6366F1),
    ];

    final seedColor = seedColors[rng.nextInt(seedColors.length)];

    final brightness =
        rng.nextDouble() < 0.7 ? Brightness.dark : Brightness.light;

    final palette = WrappedPalette.fromSeed(seedColor, brightness: brightness);

    final style = WrappedStyle.values[rng.nextInt(WrappedStyle.values.length)];

    return WrappedTheme(palette: palette, style: style, seed: seed);
  }
}
