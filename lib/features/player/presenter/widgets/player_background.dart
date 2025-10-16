import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';

class PlayerBackground extends StatelessWidget {
  final String imageUrl;
  final PlayerController playerController;

  const PlayerBackground({
    super.key,
    required this.imageUrl,
    required this.playerController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.display.width,
      height: context.display.height,
      child: AppImage(
        imageUrl,
        fit: BoxFit.cover,
        color: context.themeData.scaffoldBackgroundColor.withValues(alpha: .85),
        colorBlendMode:
            context.isDarkMode ? BlendMode.darken : BlendMode.lighten,
      ),
    );
  }
}
