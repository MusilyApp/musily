import 'package:flutter/material.dart';
import 'package:musily/core/utils/display_helper.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';

class PlayerSizedBox extends StatelessWidget {
  final PlayerController playerController;
  const PlayerSizedBox({
    super.key,
    required this.playerController,
  });

  @override
  Widget build(BuildContext context) {
    return playerController.builder(
      builder: (context, data) {
        if (data.currentPlayingItem != null &&
            !DisplayHelper(context).isDesktop) {
          return const SizedBox(
            height: 70,
          );
        }
        return Container();
      },
    );
  }
}
