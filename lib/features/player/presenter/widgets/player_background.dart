import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';

class PlayerBackground extends StatelessWidget {
  final String imageUrl;

  const PlayerBackground({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.display.width,
      height: context.display.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppImage(imageUrl, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              color: context.themeData.scaffoldBackgroundColor.withValues(
                alpha: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
