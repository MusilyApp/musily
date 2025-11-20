import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_data.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class VerticalTrackTile extends StatefulWidget {
  final RecommendedTrackModel recommendation;
  final PlayerController playerController;
  final LibraryController libraryController;
  final DownloaderController downloaderController;
  final CoreController coreController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;
  final SectionsController sectionsController;

  const VerticalTrackTile({
    required this.recommendation,
    required this.playerController,
    required this.libraryController,
    required this.downloaderController,
    required this.coreController,
    required this.getPlayableItemUsecase,
    required this.getAlbumUsecase,
    required this.getPlaylistUsecase,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
    required this.getTrackUsecase,
    required this.sectionsController,
    super.key,
  });

  @override
  State<VerticalTrackTile> createState() => _VerticalTrackTileState();
}

class _VerticalTrackTileState extends State<VerticalTrackTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? context.themeData.colorScheme.primary.withValues(alpha: 0.3)
                : context.themeData.colorScheme.outline.withValues(alpha: 0.15),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: context.themeData.colorScheme.primary
                        .withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Track Image
            GestureDetector(
              onTap: () {
                widget.playerController.methods.loadAndPlay(
                  widget.recommendation.track,
                  widget.recommendation.track.hash,
                );
                widget.libraryController.methods.updateLastTimePlayed(
                  widget.recommendation.track.hash,
                );
              },
              child: AnimatedScale(
                scale: _isHovered ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: widget.recommendation.track.lowResImg != null &&
                            widget.recommendation.track.lowResImg!.isNotEmpty
                        ? AppImage(
                            widget.recommendation.track.lowResImg!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  context.themeData.colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: 0.8),
                                  context.themeData.colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: 0.4),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Icon(
                              LucideIcons.music,
                              color: context
                                  .themeData.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                              size: 24,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Track Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.recommendation.track.title,
                    style: context.themeData.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.micVocal,
                        size: 12,
                        color: context.themeData.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.recommendation.track.artist.name,
                          style:
                              context.themeData.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: context
                                .themeData.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Play Button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: _isHovered
                    ? context.themeData.colorScheme.primary
                    : context.themeData.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: context.themeData.colorScheme.primary
                              .withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    widget.playerController.methods.playPlaylist(
                      widget.sectionsController.data.gridRecommendedTracks
                          .map((e) => e.track)
                          .toList(),
                      'recommended_section',
                      startFromTrackId: widget.recommendation.track.id,
                    );
                    widget.libraryController.methods.updateLastTimePlayed(
                      widget.recommendation.track.hash,
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      LucideIcons.play,
                      size: 18,
                      color: _isHovered
                          ? context.themeData.colorScheme.onPrimary
                          : context.themeData.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
