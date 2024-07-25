import 'package:flutter/material.dart';

/// A utility class for handling display-related information and breakpoints.
class DisplayHelper {
  final BuildContext context;
  final double width;
  final double height;

  /// Constructs a [DisplayHelper] instance based on the provided [context].
  DisplayHelper(this.context)
      : width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

  /// Indicates whether the screen width corresponds to the 'xs' breakpoint.
  bool get xs => width < 600;

  /// Indicates whether the screen width corresponds to the 'sm' breakpoint.
  bool get sm => width > 600 && width < 960;

  /// Indicates whether the screen width corresponds to the 'md' breakpoint.
  bool get md => width > 960 && width < 1280;

  /// Indicates whether the screen width corresponds to the 'lg' breakpoint.
  bool get lg => width > 1280 && width < 1920;

  /// Indicates whether the screen width corresponds to the 'xl' breakpoint.
  bool get xl => width > 1920 && width < 2560;

  /// Indicates whether the screen width corresponds to the 'xxl' breakpoint.
  bool get xxl => width > 2560;

  /// Indicates whether the screen width greater than the 'xs' breakpoint.
  bool get moreThanXs => width > 600;

  /// Indicates whether the screen width greater than the 'sm' breakpoint.
  bool get moreThanSm => width > 960;

  /// Indicates whether the screen width greater than the 'md' breakpoint.
  bool get moreThanMd => width > 1280;

  /// Indicates whether the screen width greater than the 'lg' breakpoint.
  bool get moreThanLg => width > 1920;

  /// Indicates whether the screen width greater than the 'xl' breakpoint.
  bool get moreThanXl => width > 2560;

  /// Indicates whether the screen width is less than the 'sm' breakpoint.
  bool get lessThanSm => width <= 600;

  /// Indicates whether the screen width is less than the 'md' breakpoint.
  bool get lessThanMd => width <= 960;

  /// Indicates whether the screen width is less than the 'lg' breakpoint.
  bool get lessThanLg => width <= 1280;

  /// Indicates whether the screen width is less than the 'xl' breakpoint.
  bool get lessThanXl => width <= 1920;

  /// Indicates whether the screen width is less than the 'xxl' breakpoint.
  bool get lessThanXxl => width <= 2560;
}
