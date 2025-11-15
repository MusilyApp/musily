import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;
  final Widget? trailing;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.color,
    this.trailing,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final sectionColor = color ?? context.themeData.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: sectionColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            icon,
            size: 18,
            color: sectionColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InfinityMarquee(
                  child: Text(
                    title,
                    style: context.themeData.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: context.themeData.textTheme.bodySmall?.copyWith(
                      color: context.themeData.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}
