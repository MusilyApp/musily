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
import 'package:musily/features/downloader/presenter/widgets/download_button.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_button.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:musily/features/track/presenter/widgets/track_options.dart';

class RecommendedTrackTile extends StatefulWidget {
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
  final Color? backgroundColor;
  final Color? textColor;
  final SectionsController sectionsController;

  const RecommendedTrackTile({
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
    this.backgroundColor,
    this.textColor,
    super.key,
  });

  @override
  State<RecommendedTrackTile> createState() => _RecommendedTrackTileState();
}

class _RecommendedTrackTileState extends State<RecommendedTrackTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ??
        context.themeData.colorScheme.primaryContainer;
    final textColor =
        widget.textColor ?? context.themeData.colorScheme.onPrimaryContainer;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 320,
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        constraints: const BoxConstraints(
          maxWidth: 320,
          maxHeight: 150,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? context.themeData.colorScheme.primary
                      .withValues(alpha: 0.25)
                  : backgroundColor.withValues(alpha: 0.3),
              blurRadius: _isHovered ? 16 : 12,
              offset: Offset(0, _isHovered ? 5 : 3),
              spreadRadius: _isHovered ? 1 : 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Content
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Track Artwork
                    AnimatedScale(
                      scale: _isHovered ? 1.04 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 80,
                        height: 80,
                        constraints: const BoxConstraints(
                          maxWidth: 80,
                          maxHeight: 80,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              widget.recommendation.track.highResImg != null &&
                                      widget.recommendation.track.highResImg!
                                          .isNotEmpty
                                  ? AppImage(
                                      widget.recommendation.track.highResImg!,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            textColor.withValues(alpha: 0.3),
                                            textColor.withValues(alpha: 0.15),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Icon(
                                        LucideIcons.music,
                                        size: 48,
                                        color: textColor.withValues(alpha: 0.6),
                                      ),
                                    ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Text Content and Actions
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title
                          Text(
                            widget.recommendation.track.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.4,
                              color: textColor,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  blurRadius: 6,
                                  color: backgroundColor.withValues(alpha: 0.4),
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          // Artist
                          Row(
                            children: [
                              Icon(
                                LucideIcons.micVocal,
                                size: 13,
                                color: textColor.withValues(alpha: 0.8),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.recommendation.track.artist.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textColor.withValues(alpha: 0.85),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Action Buttons
                          Row(
                            spacing: 8,
                            children: [
                              // Play Button
                              Container(
                                width: 40,
                                height: 40,
                                constraints: const BoxConstraints(
                                  maxWidth: 40,
                                  maxHeight: 40,
                                ),
                                decoration: BoxDecoration(
                                  color: textColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: textColor.withValues(alpha: 0.35),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      final recommendations = [
                                        ...widget.sectionsController.data
                                            .carouselRecommendedTracks,
                                        ...widget.sectionsController.data
                                            .gridRecommendedTracks,
                                      ];
                                      widget.playerController.methods
                                          .playPlaylist(
                                        recommendations
                                            .map((e) => e.track)
                                            .toList(),
                                        'recommended_section',
                                        startFromTrackId:
                                            widget.recommendation.track.id,
                                      );
                                      widget.libraryController.methods
                                          .updateLastTimePlayed(
                                        widget.recommendation.track.hash,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Center(
                                      child: Icon(
                                        LucideIcons.play,
                                        color: backgroundColor,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Favorite Button
                              Container(
                                width: 40,
                                height: 40,
                                constraints: const BoxConstraints(
                                  maxWidth: 40,
                                  maxHeight: 40,
                                ),
                                decoration: BoxDecoration(
                                  color: textColor.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    borderRadius: BorderRadius.circular(10),
                                    child: Center(
                                      child: IconTheme(
                                        data: IconThemeData(
                                          color: textColor,
                                          size: 16,
                                        ),
                                        child: FavoriteButton(
                                          libraryController:
                                              widget.libraryController,
                                          track: widget.recommendation.track,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Download Button
                              Container(
                                width: 40,
                                height: 40,
                                constraints: const BoxConstraints(
                                  maxWidth: 40,
                                  maxHeight: 40,
                                ),
                                decoration: BoxDecoration(
                                  color: textColor.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    borderRadius: BorderRadius.circular(10),
                                    child: Center(
                                      child: IconTheme(
                                        data: IconThemeData(
                                          color: textColor,
                                          size: 16,
                                        ),
                                        child: DownloadButton(
                                          color: textColor,
                                          controller:
                                              widget.downloaderController,
                                          track: widget.recommendation.track,
                                          coreController: widget.coreController,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // More Options
                              Container(
                                width: 40,
                                height: 40,
                                constraints: const BoxConstraints(
                                  maxWidth: 40,
                                  maxHeight: 40,
                                ),
                                decoration: BoxDecoration(
                                  color: textColor.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TrackOptions(
                                  getTrackUsecase: widget.getTrackUsecase,
                                  color: textColor,
                                  track: widget.recommendation.track,
                                  playerController: widget.playerController,
                                  libraryController: widget.libraryController,
                                  downloaderController:
                                      widget.downloaderController,
                                  coreController: widget.coreController,
                                  getPlayableItemUsecase:
                                      widget.getPlayableItemUsecase,
                                  getAlbumUsecase: widget.getAlbumUsecase,
                                  getPlaylistUsecase: widget.getPlaylistUsecase,
                                  getArtistUsecase: widget.getArtistUsecase,
                                  getArtistAlbumsUsecase:
                                      widget.getArtistAlbumsUsecase,
                                  getArtistTracksUsecase:
                                      widget.getArtistTracksUsecase,
                                  getArtistSinglesUsecase:
                                      widget.getArtistSinglesUsecase,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
