import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/domain/entities/local_library_playlist.dart';
import 'package:musily/features/_library_module/presenter/widgets/local_playlist_options.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';

class LocalPlaylistTile extends StatelessWidget {
  final LocalLibraryPlaylist playlist;
  final PlayerController playerController;
  final LibraryController libraryController;
  final CoreController coreController;
  final VoidCallback? customClickAction;
  final double? leadingSize;
  final LyDensity density;

  const LocalPlaylistTile({
    super.key,
    required this.playlist,
    required this.libraryController,
    required this.playerController,
    required this.coreController,
    this.customClickAction,
    this.leadingSize,
    this.density = LyDensity.normal,
  });

  @override
  Widget build(BuildContext context) {
    return LyListTile(
      density: density,
      onTap: customClickAction,
      leading: _LocalPlaylistThumb(
        playlist: playlist,
        size: leadingSize ?? 48,
      ),
      title: InfinityMarquee(
        child: Text(
          playlist.name,
          style: TextStyle(
            fontSize: density == LyDensity.normal ? 16 : 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            LucideIcons.listMusic,
            size: 14,
            color: context.themeData.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.7),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '${playlist.trackCount} ${context.localization.songs}',
              style: TextStyle(
                fontSize: density == LyDensity.normal ? 14 : 12,
                fontWeight: FontWeight.w400,
                color: context.themeData.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
      trailing: LocalPlaylistOptions(
        playlist: playlist,
        coreController: coreController,
        playerController: playerController,
        libraryController: libraryController,
      ),
    );
  }
}

class _LocalPlaylistThumb extends StatelessWidget {
  final LocalLibraryPlaylist playlist;
  final double size;

  const _LocalPlaylistThumb({
    required this.playlist,
    this.size = 40,
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
        child: Container(
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
            LucideIcons.folderOpenDot,
            size: size * 0.5,
            color: context.themeData.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
