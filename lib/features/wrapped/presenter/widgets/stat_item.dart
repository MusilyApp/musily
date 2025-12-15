import 'package:flutter/material.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';

class StatItem extends StatelessWidget {
  final String value;
  final String label;
  final WrappedPalette palette;

  const StatItem({
    super.key,
    required this.value,
    required this.label,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: palette.text,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: palette.text.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
