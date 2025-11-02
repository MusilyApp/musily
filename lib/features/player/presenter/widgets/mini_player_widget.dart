import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/core/presenter/widgets/musily_loading.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_button.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/player/presenter/widgets/player_widget.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class MiniPlayerWidget extends StatefulWidget {
  final DownloaderController downloaderController;
  final PlayerController playerController;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final CoreController coreController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetTrackUsecase getTrackUsecase;

  const MiniPlayerWidget({
    required this.playerController,
    required this.downloaderController,
    super.key,
    required this.libraryController,
    required this.getAlbumUsecase,
    required this.getPlayableItemUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getArtistTracksUsecase,
    required this.coreController,
    required this.getArtistUsecase,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
}

class _MiniPlayerWidgetState extends State<MiniPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.playerController.builder(
      builder: (context, data) {
        if (data.currentPlayingItem != null) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: GestureDetector(
              onTap: () async {
                Navigator.of(context).push(
                  DownupRouter(
                    builder: (context) => PlayerWidget(
                      playerController: widget.playerController,
                      downloaderController: widget.downloaderController,
                      libraryController: widget.libraryController,
                      getAlbumUsecase: widget.getAlbumUsecase,
                      getPlayableItemUsecase: widget.getPlayableItemUsecase,
                      coreController: widget.coreController,
                      getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                      getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                      getPlaylistUsecase: widget.getPlaylistUsecase,
                      getArtistTracksUsecase: widget.getArtistTracksUsecase,
                      getArtistUsecase: widget.getArtistUsecase,
                      getTrackUsecase: widget.getTrackUsecase,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.themeData.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: context.themeData.colorScheme.outline
                          .withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Row(
                          children: [
                            // Album artwork
                            _AlbumArtwork(
                              imageUrl: data.currentPlayingItem!.lowResImg,
                            ),
                            const SizedBox(width: 10),
                            // Track info
                            Expanded(
                              child: _TrackInfo(
                                title: data.currentPlayingItem!.title,
                                artist: data.currentPlayingItem!.artist.name,
                              ),
                            ),
                            // Controls
                            FavoriteButton(
                              libraryController: widget.libraryController,
                              track: data.currentPlayingItem!,
                            ),
                            _PlayPauseButton(
                              isPlaying: data.isPlaying,
                              isLoading:
                                  data.currentPlayingItem?.duration.inSeconds ==
                                      0,
                              onPlayPause: () {
                                if (data.isPlaying) {
                                  widget.playerController.methods.pause();
                                } else {
                                  widget.playerController.methods.resume();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      // Progress bar
                      _ProgressBar(
                        position: data.currentPlayingItem!.position,
                        duration: data.currentPlayingItem!.duration,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

class _AlbumArtwork extends StatelessWidget {
  final String? imageUrl;

  const _AlbumArtwork({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: context.themeData.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? AppImage(
                imageUrl!,
                width: 42,
                height: 42,
              )
            : Icon(
                LucideIcons.disc3,
                color:
                    context.themeData.iconTheme.color?.withValues(alpha: 0.6),
                size: 20,
              ),
      ),
    );
  }
}

class _TrackInfo extends StatelessWidget {
  final String title;
  final String artist;

  const _TrackInfo({
    required this.title,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InfinityMarquee(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 1),
        InfinityMarquee(
          child: Text(
            artist,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: context.themeData.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onPlayPause;

  const _PlayPauseButton({
    required this.isPlaying,
    required this.isLoading,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: context.themeData.colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: MusilyLoading(
            color: context.themeData.colorScheme.primary,
            size: 16,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPlayPause,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.themeData.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPlaying ? LucideIcons.pause : LucideIcons.play,
            size: 18,
            color: context.themeData.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;

  const _ProgressBar({
    required this.position,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    late final double progressValue;
    if (position.inMilliseconds == 0 || duration.inMilliseconds == 0) {
      progressValue = 0;
    } else {
      progressValue = position.inMilliseconds / duration.inMilliseconds;
    }

    return SizedBox(
      height: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1),
        child: LinearProgressIndicator(
          value: progressValue,
          backgroundColor:
              context.themeData.colorScheme.onSurface.withValues(alpha: 0.1),
          valueColor: AlwaysStoppedAnimation<Color>(
            context.themeData.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
