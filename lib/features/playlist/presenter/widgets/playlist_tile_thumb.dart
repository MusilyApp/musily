import 'package:flutter/material.dart';
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          width: 1,
          color: context.themeData.colorScheme.outline.withOpacity(.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
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
                : SizedBox(
                    width: size,
                    height: size,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.playlist_play_rounded,
                        color:
                            context.themeData.iconTheme.color?.withOpacity(.7),
                      ),
                    ),
                  ),
      ),
    );
  }
}
