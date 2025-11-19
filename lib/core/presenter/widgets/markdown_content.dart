import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class MarkdownContent extends StatelessWidget {
  final String content;

  const MarkdownContent({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    final List<Widget> widgets = [];

    for (final line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      if (line.startsWith('**') && line.endsWith('**')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              line.replaceAll('**', ''),
              style: context.themeData.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      } else if (line.trim().startsWith('- ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: context.themeData.textTheme.bodyMedium?.copyWith(
                    color: context.themeData.colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: Text(
                    line.substring(2),
                    style: context.themeData.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              line,
              style: context.themeData.textTheme.bodyMedium,
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
