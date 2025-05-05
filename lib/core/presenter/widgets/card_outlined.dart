import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class CardOutlined extends StatelessWidget {
  final Widget? child;
  const CardOutlined({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          width: 1,
          color: context.themeData.colorScheme.outline.withValues(alpha: .2),
        ),
      ),
      child: child,
    );
  }
}
