import 'package:flutter/material.dart';
import 'package:musily/features/downloader/presenter/widgets/offline_icon.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_icon.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class PlaylistTileThumb extends StatelessWidget {
  final PlaylistEntity playlist;
  final double size;
  const PlaylistTileThumb({
    required this.playlist,
    this.size = 40,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.outline.withOpacity(.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: playlist.id == 'favorites'
            ? FavoriteIcon(
                size: size,
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
                            Theme.of(context).iconTheme.color?.withOpacity(.7),
                      ),
                    ),
                  ),
      ),
    );
  }
}
