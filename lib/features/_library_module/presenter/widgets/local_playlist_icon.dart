import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class LocalPlaylistIcon extends StatelessWidget {
  final double size;
  final double? iconSize;
  final bool animated;
  final bool isValid;

  const LocalPlaylistIcon({
    super.key,
    this.size = 50,
    this.iconSize,
    this.animated = false,
    this.isValid = true,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        context.themeData.buttonTheme.colorScheme?.tertiary ?? Colors.white;
    final gradientColors = isValid
        ? [
            Colors.transparent,
            animated ? primaryColor : primaryColor.withValues(alpha: 0.85),
          ]
        : [
            Colors.transparent,
            context.themeData.colorScheme.error,
          ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Center(
          child: Icon(
            isValid ? Icons.folder_rounded : LucideIcons.triangleAlert,
            color:
                animated ? Colors.white : Colors.white.withValues(alpha: 0.92),
            size: iconSize ?? size * 0.6,
          ),
        ),
      ),
    );
  }
}
