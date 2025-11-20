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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? context.themeData.colorScheme.primary
                : context.themeData.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? context.themeData.colorScheme.primary
                  : context.themeData.colorScheme.outline
                      .withValues(alpha: 0.15),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.themeData.colorScheme.primary
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: context.themeData.textTheme.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              letterSpacing: -0.2,
              color: isSelected
                  ? context.themeData.colorScheme.onPrimary
                  : context.themeData.colorScheme.onSurface
                      .withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}
