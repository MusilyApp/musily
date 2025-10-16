import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/player/domain/enums/player_mode.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class PlayerTitle extends StatelessWidget {
  final PlayerController playerController;
  final PlayerMode playerMode;
  final bool syncedLyrics;
  final bool autoSmartQueue;
  final bool loadingSmartQueue;
  final TrackEntity currentTrack;

  const PlayerTitle({
    super.key,
    required this.playerController,
    required this.playerMode,
    required this.syncedLyrics,
    required this.autoSmartQueue,
    required this.loadingSmartQueue,
    required this.currentTrack,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: child,
          ),
        );
      },
      child: _buildModeContent(context),
    );
  }

  Widget _buildModeContent(BuildContext context) {
    Widget content;
    String key;

    switch (playerMode) {
      case PlayerMode.lyrics:
        content = _buildLyricsSwitch(context);
        key = 'lyrics_switch';
        break;
      case PlayerMode.queue:
        content = _buildQueueTitle(context);
        key = 'queue_title';
        break;
      case PlayerMode.artwork:
        content = _buildArtworkSwitch(context);
        key = 'artwork_switch';
        break;
    }

    return Container(key: ValueKey(key), child: content);
  }

  Widget _buildLyricsSwitch(BuildContext context) {
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
  }

  Widget _buildArtworkSwitch(BuildContext context) {
    return Switch(
      inactiveThumbColor: context.themeData.colorScheme.primary.withValues(
        alpha: .6,
      ),
      inactiveTrackColor: context.themeData.colorScheme.primary.withValues(
        alpha: 0.1,
      ),
      activeColor: context.themeData.colorScheme.primary,
      value: autoSmartQueue,
      thumbIcon: WidgetStatePropertyAll(
        Icon(LucideIcons.wand, color: context.themeData.colorScheme.onPrimary),
      ),
      onChanged:
          loadingSmartQueue
              ? null
              : (value) {
                playerController.methods.toggleSmartQueue();
              },
    );
  }

  Widget _buildQueueTitle(BuildContext context) {
    return Column(
      children: [
        InfinityMarquee(
          child: Text(
            currentTrack.title,
            style: context.themeData.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Opacity(
          opacity: 0.7,
          child: InfinityMarquee(
            child: Text(
              currentTrack.artist.name,
              style: context.themeData.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
