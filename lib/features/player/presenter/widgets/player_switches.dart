import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/player/domain/enums/player_mode.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';

class PlayerSwitches extends StatelessWidget {
  final PlayerController playerController;
  final PlayerMode playerMode;
  final bool syncedLyrics;
  final bool autoSmartQueue;
  final bool loadingSmartQueue;

  const PlayerSwitches({
    super.key,
    required this.playerController,
    required this.playerMode,
    required this.syncedLyrics,
    required this.autoSmartQueue,
    required this.loadingSmartQueue,
  });

  @override
  Widget build(BuildContext context) {
    switch (playerMode) {
      case PlayerMode.lyrics:
        return Switch(
          activeColor: context.themeData.colorScheme.primary,
          thumbIcon: WidgetStatePropertyAll(
            Icon(
              LucideIcons.refreshCw,
              color: context.themeData.colorScheme.onPrimary,
            ),
          ),
          value: syncedLyrics,
          onChanged: (value) {
            playerController.methods.toggleSyncedLyrics();
          },
        );
      case PlayerMode.artwork:
        return Switch(
          inactiveThumbColor:
              context.themeData.colorScheme.primary.withValues(alpha: .6),
          inactiveTrackColor:
              context.themeData.colorScheme.primary.withValues(alpha: 0.1),
          activeColor: context.themeData.colorScheme.primary,
          value: autoSmartQueue,
          thumbIcon: WidgetStatePropertyAll(
            Icon(
              LucideIcons.wand,
              color: context.themeData.colorScheme.onPrimary,
            ),
          ),
          onChanged: loadingSmartQueue
              ? null
              : (value) {
                  playerController.methods.toggleSmartQueue();
                },
        );
      case PlayerMode.queue:
        return const SizedBox.shrink();
    }
  }
}
