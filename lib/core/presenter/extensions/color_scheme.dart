import 'package:flutter/material.dart';

extension ExpandedColorScheme on ColorScheme {
  Color get onScaffold => surfaceContainerHighest.withValues(alpha: 0.4);
}
