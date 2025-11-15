import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';

class PlayerSizedBox extends StatelessWidget {
  final PlayerController playerController;
  final double height;
  const PlayerSizedBox({
    super.key,
    required this.playerController,
    this.height = 190,
  });

  @override
  Widget build(BuildContext context) {
    return playerController.builder(
      builder: (context, data) {
        if (data.currentPlayingItem != null && !context.display.isDesktop) {
          return SizedBox(height: height);
        }
        return Container();
      },
    );
  }
}
