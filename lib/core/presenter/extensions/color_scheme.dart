import 'package:flutter/material.dart';

extension ExpandedColorScheme on ColorScheme {
  Color get onScaffold => surface.computeLuminance() > 0.5
      ? const Color(0xffefebf5)
      : const Color(0xff131217);
}
