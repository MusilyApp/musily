import 'package:flutter/material.dart';

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
          color: Theme.of(context).colorScheme.outline.withOpacity(.2),
        ),
      ),
      child: child,
    );
  }
}
