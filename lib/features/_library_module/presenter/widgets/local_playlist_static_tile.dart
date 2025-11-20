import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/features/_library_module/domain/entities/local_library_playlist.dart';
import 'package:musily/features/_library_module/presenter/widgets/local_playlist_icon.dart';

class LocalPlaylistStaticTile extends StatelessWidget {
  final LocalLibraryPlaylist playlist;

  const LocalPlaylistStaticTile({
    required this.playlist,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LyListTile(
      leading: const LocalPlaylistIcon(
        size: 40,
        iconSize: 20,
      ),
      title: Text(playlist.name),
      subtitle: Text(
        '${context.localization.localPlaylist} · ${playlist.trackCount} ${context.localization.songs}',
      ),
    );
  }
}
