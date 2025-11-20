import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/downloader/presenter/widgets/offline_icon.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_icon.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class PlaylistTileThumb extends StatelessWidget {
  final PlaylistEntity playlist;
  final PlayerController? playerController;
  final double size;
  const PlaylistTileThumb({
    required this.playlist,
    this.size = 40,
    super.key,
    this.playerController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          width: 2,
          color: context.themeData.colorScheme.outline.withValues(alpha: .15),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: playlist.id == UserService.favoritesId
            ? Builder(
                builder: (context) {
                  if (playerController == null) {
                    return FavoriteIcon(
                      size: size,
                    );
                  }
                  return playerController!.builder(
                    builder: (context, data) => FavoriteIcon(
                      size: size,
                      animated: data.isPlaying,
                    ),
                  );
                },
              )
            : playlist.id == 'offline'
                ? OfflineIcon(
                    size: size,
                  )
                : Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          context.themeData.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.8),
                          context.themeData.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      LucideIcons.listMusic,
                      size: size * 0.5,
                      color: context.themeData.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                    ),
                  ),
      ),
    );
  }
}
