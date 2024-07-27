import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';

class PlayerBackground extends StatefulWidget {
  final String imageUrl;
  final PlayerController playerController;

  const PlayerBackground({
    super.key,
    required this.imageUrl,
    required this.playerController,
  });

  @override
  State<PlayerBackground> createState() => _PlayerBackgroundState();
}

class _PlayerBackgroundState extends State<PlayerBackground> {
  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height;

    return widget.playerController.builder(builder: (context, data) {
      return Stack(
        children: [
          AnimatedOpacity(
            opacity: data.showLyrics ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          AnimatedOpacity(
            opacity: data.showLyrics ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
              width: maxWidth,
              height: maxHeight,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AppImage(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.8),
                  colorBlendMode:
                      isDarkMode ? BlendMode.darken : BlendMode.lighten,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
