import 'package:flutter/material.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_tile_thumb.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        playlist.id == 'favorites'
            ? AppLocalizations.of(context)!.favorites
            : playlist.id == 'offline'
                ? AppLocalizations.of(context)!.offline
                : playlist.title,
      ),
      subtitle: Text(
        '${AppLocalizations.of(context)!.playlist} · ${playlist.trackCount} ${AppLocalizations.of(context)!.songs}',
      ),
    );
  }
}
