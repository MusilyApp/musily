import 'package:flutter/material.dart';

class AppInputBase extends StatelessWidget {
  final Widget? child;
  final String? labelText;
  const AppInputBase({
    super.key,
    this.child,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: 12,
            ),
            child: Text(
              labelText!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              8,
            ),
            side: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(.2),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              8,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
