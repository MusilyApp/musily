import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class SearchFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SearchFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? context.themeData.colorScheme.primary
              : context.themeData.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: context.themeData.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected
                ? context.themeData.colorScheme.onPrimary
                : context.themeData.colorScheme.onSurface
                    .withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}
