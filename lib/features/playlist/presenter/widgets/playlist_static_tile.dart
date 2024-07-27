import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musily/features/_library_module/presenter/widgets/playlist_tile_thumb.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_icon.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

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
    return ListTile(
      leading: playlist.id == 'favorites'
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const FavoriteIcon(
                size: 45,
              ),
            )
          : PlaylistTileThumb(
              urls: playlist.tracks
                  .map((track) =>
                      track.lowResImg?.replaceAll('w60-h60', 'w40-h40'))
                  .whereType<String>()
                  .toSet()
                  .toList()
                ..shuffle(
                  Random(),
                ),
            ),
      title: Text(
        playlist.id == 'favorites' ? 'Favoritos' : playlist.title,
      ),
      subtitle: Text(
        'Playlist · ${playlist.tracks.length} músicas',
      ),
    );
  }
}
