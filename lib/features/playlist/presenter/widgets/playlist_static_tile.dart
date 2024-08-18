import 'package:flutter/material.dart';
import 'package:musily/features/_library_module/presenter/widgets/playlist_tile_thumb.dart';
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
    return ListTile(
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
        '${AppLocalizations.of(context)!.playlist} · ${playlist.tracks.length} ${AppLocalizations.of(context)!.songs}',
      ),
    );
  }
}
