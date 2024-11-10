import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';

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
  int selectedAnimatedWidget = 0;
  bool changingAnimatedWidget = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    selectedAnimatedWidget = Random().nextInt(4);
    _startAnimationTimer();
  }

  void _startAnimationTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        changingAnimatedWidget = true;
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {
          selectedAnimatedWidget = Random().nextInt(3);
          changingAnimatedWidget = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _getAnimatedWidget(BuildContext context) {
    final items = [
      LoadingAnimationWidget.waveDots(
        color: context.themeData.dividerColor,
        size: context.display.width,
      ),
      LoadingAnimationWidget.progressiveDots(
        color: context.themeData.dividerColor,
        size: context.display.width,
      ),
      LoadingAnimationWidget.horizontalRotatingDots(
        color: context.themeData.dividerColor,
        size: context.display.width,
      ),
      LoadingAnimationWidget.stretchedDots(
        color: context.themeData.dividerColor,
        size: context.display.width,
      ),
    ];
    return items[selectedAnimatedWidget];
  }

  @override
  Widget build(BuildContext context) {
    return widget.playerController.builder(builder: (context, data) {
      return Stack(
        children: [
          AnimatedOpacity(
            opacity: data.showLyrics ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              color: context.themeData.colorScheme.inversePrimary,
            ),
          ),
          AnimatedOpacity(
            opacity: data.showLyrics ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
              width: context.display.width,
              height: context.display.height,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AppImage(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  color: context.themeData.scaffoldBackgroundColor
                      .withOpacity(0.9),
                  colorBlendMode:
                      context.isDarkMode ? BlendMode.darken : BlendMode.lighten,
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity:
                data.isPlaying && !data.showLyrics && !changingAnimatedWidget
                    ? 1
                    : 0,
            duration: const Duration(milliseconds: 400),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Align(
                alignment: Alignment.topCenter,
                child: _getAnimatedWidget(context),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity:
                data.isPlaying && !data.showLyrics && !changingAnimatedWidget
                    ? 1
                    : 0,
            duration: const Duration(milliseconds: 400),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _getAnimatedWidget(context),
              ),
            ),
          ),
        ],
      );
    });
  }
}
