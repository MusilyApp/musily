import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class EmptyState extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? icon;
  final Widget? action;
  final double? maxWidth;

  const EmptyState({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.action,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeData;
    final textColorPrimary = theme.colorScheme.onSurface;
    final textColorSecondary =
        theme.colorScheme.onSurface.withValues(alpha: .7);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  size: 56,
                  color: theme.iconTheme.color?.withValues(alpha: .5),
                ),
                child: icon!,
              ),
              const SizedBox(height: 12),
            ],
            Text(
              title ?? context.localization.noItemsFound,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: textColorPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: -.2,
              ),
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColorSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 14),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
