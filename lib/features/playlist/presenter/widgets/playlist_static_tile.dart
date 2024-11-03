import 'package:flutter/material.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_tile_thumb.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class PlaylistStaticTile extends StatelessWidget {
  final PlaylistEntity playlist;

  final void Function()? customClickAction;
  const PlaylistStaticTile({
    required this.playlist,
    this.customClickAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LyListTile(
      leading: PlaylistTileThumb(
        playlist: playlist,
        size: 40,
      ),
      title: Text(
        playlist.id == UserService.favoritesId
            ? context.localization.favorites
            : playlist.id == 'offline'
                ? context.localization.offline
                : playlist.title,
      ),
      subtitle: Text(
        '${context.localization.playlist} · ${playlist.trackCount} ${context.localization.songs}',
      ),
    );
  }
}
