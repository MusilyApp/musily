import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/entities/app_menu_entry.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/duration.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/widgets/download_button.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:musily/features/track/presenter/widgets/track_options.dart';

enum TrackTileOptions {
  addToPlaylist,
  addToQueue,
  seeAlbum,
  seeArtist,
  share,
  download,
}

class TrackTile extends StatefulWidget {
  final TrackEntity track;
  final CoreController coreController;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;
  final Widget? leading;
  final void Function()? customAction;
  final List<AppMenuEntry> Function(BuildContext context)? customOptions;
  final List<TrackTileOptions> hideOptions;
  const TrackTile({
    required this.track,
    required this.coreController,
    required this.playerController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.downloaderController,
    this.hideOptions = const [],
    this.customOptions,
    this.leading,
    this.customAction,
    super.key,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<TrackTile> createState() => _TrackTileState();
}

class _TrackTileState extends State<TrackTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.playerController.builder(
      builder: (context, data) {
        final isPlaying = data.playingId == widget.track.hash;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.customAction ??
                  () async {
                    if (isPlaying) {
                      widget.playerController.methods.pause();
                    } else {
                      widget.playerController.methods.loadAndPlay(
                        widget.track,
                        widget.track.hash,
                      );
                    }
                  },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    // Track Artwork
                    widget.leading ??
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: widget.track.lowResImg != null &&
                                    widget.track.lowResImg!.isNotEmpty
                                ? AppImage(
                                    widget.track.lowResImg!,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          context.themeData.colorScheme.primary
                                              .withValues(alpha: 0.6),
                                          context.themeData.colorScheme.primary
                                              .withValues(alpha: 0.3),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Icon(
                                      LucideIcons.music,
                                      color: context
                                          .themeData.colorScheme.onPrimary
                                          .withValues(alpha: 0.7),
                                      size: 22,
                                    ),
                                  ),
                          ),
                        ),
                    const SizedBox(width: 12),
                    // Track Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InfinityMarquee(
                            child: Text(
                              widget.track.title,
                              style: context.themeData.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.2,
                                color: isPlaying
                                    ? context.themeData.colorScheme.primary
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.micVocal,
                                size: 12,
                                color: context
                                    .themeData.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: InfinityMarquee(
                                  child: Text(
                                    widget.track.artist.name,
                                    style: context.themeData.textTheme.bodySmall
                                        ?.copyWith(
                                      color: context.themeData.colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              if (widget.track.duration.inSeconds > 1) ...[
                                const SizedBox(width: 8),
                                Text(
                                  widget.track.duration.formatDuration,
                                  style: context.themeData.textTheme.bodySmall
                                      ?.copyWith(
                                    color: context
                                        .themeData.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Action Buttons
                    if (!widget.track.isLocal)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DownloadButton(
                            controller: widget.downloaderController,
                            track: widget.track,
                            coreController: widget.coreController,
                          ),
                          const SizedBox(width: 8),
                          TrackOptions(
                            getTrackUsecase: widget.getTrackUsecase,
                            getPlaylistUsecase: widget.getPlaylistUsecase,
                            hideOptions: widget.hideOptions,
                            coreController: widget.coreController,
                            track: widget.track,
                            playerController: widget.playerController,
                            downloaderController: widget.downloaderController,
                            getPlayableItemUsecase:
                                widget.getPlayableItemUsecase,
                            libraryController: widget.libraryController,
                            customActions: widget.customOptions,
                            getAlbumUsecase: widget.getAlbumUsecase,
                            getArtistAlbumsUsecase:
                                widget.getArtistAlbumsUsecase,
                            getArtistSinglesUsecase:
                                widget.getArtistSinglesUsecase,
                            getArtistTracksUsecase:
                                widget.getArtistTracksUsecase,
                            getArtistUsecase: widget.getArtistUsecase,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
