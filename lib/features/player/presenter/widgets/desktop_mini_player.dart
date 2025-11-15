import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/duration.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/musily_loading.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/widgets/download_button.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_button.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/player/domain/enums/player_mode.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/presenter/widgets/track_options.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/player/presenter/widgets/desktop_full_player.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/player/presenter/widgets/sleep_timer_dialog.dart';
import 'package:window_manager/window_manager.dart';

class DesktopMiniPlayer extends StatefulWidget {
  final PlayerController playerController;
  final LibraryController libraryController;
  final DownloaderController downloaderController;
  final VoidCallback? onModeTap;
  final CoreController coreController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;

  const DesktopMiniPlayer({
    super.key,
    required this.playerController,
    required this.libraryController,
    required this.downloaderController,
    this.onModeTap,
    required this.coreController,
    required this.getPlayableItemUsecase,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getTrackUsecase,
    required this.getPlaylistUsecase,
  });

  @override
  State<DesktopMiniPlayer> createState() => _DesktopMiniPlayerState();
}

class _DesktopMiniPlayerState extends State<DesktopMiniPlayer> {
  Duration _seekDuration = Duration.zero;
  bool _useSeekDuration = false;
  double _previousVolume = 1.0;

  String _formatRemainingTime(DateTime endTime) {
    final now = DateTime.now();
    final remaining = endTime.difference(now);

    if (remaining.isNegative || remaining.inSeconds == 0) {
      return '0:00';
    }

    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return widget.playerController.builder(
      builder: (context, data) {
        final TrackEntity? track = data.currentPlayingItem;

        if (track == null) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 90,
          decoration: BoxDecoration(
            color: context.themeData.scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                  color: context.themeData.iconTheme.color
                          ?.withValues(alpha: 0.1) ??
                      Colors.white,
                  width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Album Art & Track Info
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    _AlbumArtwork(
                      isLocal: track.isLocal,
                      onTap: () {
                        LyNavigator.push(
                          context.showingPageContext,
                          AsyncAlbumPage(
                            getTrackUsecase: widget.getTrackUsecase,
                            albumId: track.album.id,
                            coreController: widget.coreController,
                            playerController: widget.playerController,
                            getPlaylistUsecase: widget.getPlaylistUsecase,
                            getAlbumUsecase: widget.getAlbumUsecase,
                            downloaderController: widget.downloaderController,
                            getPlayableItemUsecase:
                                widget.getPlayableItemUsecase,
                            libraryController: widget.libraryController,
                            getArtistAlbumsUsecase:
                                widget.getArtistAlbumsUsecase,
                            getArtistSinglesUsecase:
                                widget.getArtistSinglesUsecase,
                            getArtistTracksUsecase:
                                widget.getArtistTracksUsecase,
                            getArtistUsecase: widget.getArtistUsecase,
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: track.lowResImg != null
                            ? AppImage(
                                track.lowResImg!,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 56,
                                height: 56,
                                color: context.themeData.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                                child: Icon(
                                  LucideIcons.music,
                                  color: context.themeData.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                  size: 20,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          track.isLocal
                              ? Text(
                                  track.artist.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : InkWell(
                                  onTap: () {
                                    LyNavigator.push(
                                      context.showingPageContext,
                                      AsyncArtistPage(
                                        trackId: track.id,
                                        getTrackUsecase: widget.getTrackUsecase,
                                        artistId: track.artist.id,
                                        coreController: widget.coreController,
                                        getPlaylistUsecase:
                                            widget.getPlaylistUsecase,
                                        playerController:
                                            widget.playerController,
                                        getAlbumUsecase: widget.getAlbumUsecase,
                                        downloaderController:
                                            widget.downloaderController,
                                        getPlayableItemUsecase:
                                            widget.getPlayableItemUsecase,
                                        libraryController:
                                            widget.libraryController,
                                        getArtistAlbumsUsecase:
                                            widget.getArtistAlbumsUsecase,
                                        getArtistSinglesUsecase:
                                            widget.getArtistSinglesUsecase,
                                        getArtistTracksUsecase:
                                            widget.getArtistTracksUsecase,
                                        getArtistUsecase:
                                            widget.getArtistUsecase,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    track.artist.name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    if (!track.isLocal)
                      FavoriteButton(
                        libraryController: widget.libraryController,
                        track: track,
                      ),
                    if (!track.isLocal)
                      DownloadButton(
                        controller: widget.downloaderController,
                        track: track,
                      ),
                  ],
                ),
              ),
              // Player Controls
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                widget.playerController.methods.toggleShuffle();
                              },
                              icon: Icon(
                                LucideIcons.shuffle,
                                size: 18,
                                color: data.shuffleEnabled
                                    ? context.themeData.colorScheme.primary
                                    : context.themeData.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                              ),
                            ),
                            if (data.shuffleEnabled) ...[
                              Positioned(
                                left: 16,
                                top: 25,
                                child: Icon(
                                  LucideIcons.circle,
                                  size: 4,
                                  color: context.themeData.colorScheme.primary,
                                ),
                              ),
                              Positioned(
                                left: 9,
                                top: 17,
                                child: Icon(
                                  Icons.fiber_manual_record,
                                  size: 6,
                                  color: context.themeData.colorScheme.primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            widget.playerController.methods.previousInQueue();
                          },
                          icon: Icon(
                            LucideIcons.skipBack,
                            size: 20,
                            color: context.themeData.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                        Builder(builder: (context) {
                          if ((!data.mediaAvailable || data.isBuffering) &&
                              data.loadRequested) {
                            return const SizedBox(
                              width: 38,
                              height: 38,
                              child: Center(
                                child: MusilyLoading(size: 20),
                              ),
                            );
                          }
                          return Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: context.themeData.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                if (data.currentPlayingItem?.duration
                                        .inSeconds ==
                                    0) {
                                  widget.playerController.methods.loadAndPlay(
                                    data.currentPlayingItem!,
                                    data.playingId,
                                  );
                                  return;
                                }
                                if (data.isPlaying) {
                                  widget.playerController.methods.pause();
                                } else if (data.mediaAvailable) {
                                  widget.playerController.methods.resume();
                                } else if (data.currentPlayingItem != null) {
                                  final playingId = data.playingId.isNotEmpty
                                      ? data.playingId
                                      : data.currentPlayingItem!.id;
                                  await widget.playerController.methods
                                      .loadAndPlay(
                                    data.currentPlayingItem!,
                                    playingId,
                                  );
                                }
                              },
                              icon: Icon(
                                data.isPlaying
                                    ? LucideIcons.pause
                                    : LucideIcons.play,
                                size: 20,
                                color: context.themeData.colorScheme.onPrimary
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          );
                        }),
                        IconButton(
                          onPressed: () {
                            widget.playerController.methods.nextInQueue();
                          },
                          icon: Icon(
                            LucideIcons.skipForward,
                            size: 20,
                            color: context.themeData.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            widget.playerController.methods.toggleRepeatState();
                          },
                          icon: Stack(
                            children: [
                              Icon(
                                () {
                                  switch (data.repeatMode) {
                                    case MusilyRepeatMode.noRepeat:
                                      return LucideIcons.repeat;
                                    case MusilyRepeatMode.repeat:
                                      return LucideIcons.repeat;
                                    case MusilyRepeatMode.repeatOne:
                                      return LucideIcons.repeat1;
                                  }
                                }(),
                                size: 18,
                                color: data.repeatMode !=
                                        MusilyRepeatMode.noRepeat
                                    ? context.themeData.colorScheme.primary
                                    : context.themeData.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                              ),
                              if (data.repeatMode == MusilyRepeatMode.repeat)
                                Positioned(
                                  left: 7,
                                  top: 7,
                                  child: Icon(
                                    Icons.fiber_manual_record,
                                    size: 4,
                                    color:
                                        context.themeData.colorScheme.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Progress Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Text(
                            (_useSeekDuration ? _seekDuration : track.position)
                                .formatDuration,
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 12,
                                ),
                                activeTrackColor: context
                                    .themeData.colorScheme.primary
                                    .withValues(alpha: 0.7),
                                inactiveTrackColor: context
                                    .themeData.colorScheme.primary
                                    .withValues(alpha: 0.2),
                                thumbColor:
                                    context.themeData.colorScheme.primary,
                                overlayColor: context
                                    .themeData.colorScheme.primary
                                    .withValues(alpha: 0.2),
                              ),
                              child: Slider(
                                min: 0,
                                max: track.duration.inSeconds.toDouble(),
                                value: () {
                                  if (track.position.inSeconds >
                                      track.duration.inSeconds) {
                                    return 0.0;
                                  }
                                  if (_useSeekDuration) {
                                    return _seekDuration.inSeconds.toDouble();
                                  }
                                  if (track.position.inSeconds.toDouble() >=
                                      0) {
                                    return track.position.inSeconds.toDouble();
                                  }
                                  return 0.0;
                                }(),
                                onChanged: (value) {
                                  setState(() {
                                    _useSeekDuration = true;
                                    _seekDuration = Duration(
                                      seconds: value.toInt(),
                                    );
                                  });
                                },
                                onChangeEnd: (value) async {
                                  setState(() {
                                    _useSeekDuration = false;
                                  });
                                  await widget.playerController.methods.seek(
                                    _seekDuration,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            track.duration.formatDuration,
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Right Controls
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!track.isLocal)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale:
                                  Tween<double>(begin: 0.8, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              child: child,
                            ),
                          );
                        },
                        child: IconButton(
                          key: ValueKey(data.playerMode),
                          onPressed: widget.onModeTap,
                          icon: Icon(
                            data.playerMode == PlayerMode.lyrics
                                ? LucideIcons.listMusic
                                : LucideIcons.micVocal,
                            size: 18,
                            color: context.themeData.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        if (data.volume > 0) {
                          setState(() {
                            _previousVolume = data.volume;
                          });
                          widget.playerController.methods.setVolume(0.0);
                        } else {
                          widget.playerController.methods
                              .setVolume(_previousVolume);
                        }
                      },
                      icon: Icon(
                        () {
                          if (data.volume == 0) {
                            return LucideIcons.volumeOff;
                          } else if (data.volume < 0.5) {
                            return LucideIcons.volume1;
                          } else {
                            return LucideIcons.volume2;
                          }
                        }(),
                        size: 18,
                        color: context.themeData.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 12,
                          ),
                          activeTrackColor: context
                              .themeData.colorScheme.primary
                              .withValues(alpha: 0.7),
                          inactiveTrackColor: context
                              .themeData.colorScheme.primary
                              .withValues(alpha: 0.2),
                          thumbColor: context.themeData.colorScheme.primary,
                          overlayColor: context.themeData.colorScheme.primary
                              .withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          value: data.volume,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) {
                            widget.playerController.methods.setVolume(value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Stack(
                      children: [
                        Tooltip(
                          message: data.sleepTimerActive &&
                                  data.sleepTimerEndTime != null
                              ? context.localization.sleepTimerActive(
                                  _formatRemainingTime(data.sleepTimerEndTime!))
                              : context.localization.sleepTimer,
                          child: IconButton(
                            onPressed: () {
                              if (data.sleepTimerActive) {
                                SleepTimerDialog.showActiveTimer(
                                  context,
                                  endTime: data.sleepTimerEndTime!,
                                  onCancel: () {
                                    widget.playerController.methods
                                        .cancelSleepTimer();
                                  },
                                  onAddTime: (duration) {
                                    widget.playerController.methods
                                        .setSleepTimer(duration);
                                  },
                                );
                              } else {
                                SleepTimerDialog.show(
                                  context,
                                  onTimerSet: (duration) {
                                    widget.playerController.methods
                                        .setSleepTimer(duration);
                                  },
                                );
                              }
                            },
                            icon: Icon(
                              data.sleepTimerActive
                                  ? LucideIcons.timerOff
                                  : LucideIcons.timer,
                              size: 18,
                              color: data.sleepTimerActive
                                  ? context.themeData.colorScheme.primary
                                  : context.themeData.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        if (data.sleepTimerActive)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: context.themeData.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () async {
                        await windowManager.hide();
                        await Future.delayed(const Duration(milliseconds: 100));
                        await windowManager.setFullScreen(true);
                        await windowManager.show();
                        await windowManager.focus();
                        LyNavigator.push(
                          context,
                          DesktopFullPlayer(
                            playerController: widget.playerController,
                            libraryController: widget.libraryController,
                            downloaderController: widget.downloaderController,
                            coreController: widget.coreController,
                            getPlayableItemUsecase:
                                widget.getPlayableItemUsecase,
                            getAlbumUsecase: widget.getAlbumUsecase,
                            getArtistUsecase: widget.getArtistUsecase,
                            getArtistTracksUsecase:
                                widget.getArtistTracksUsecase,
                            getArtistAlbumsUsecase:
                                widget.getArtistAlbumsUsecase,
                            getArtistSinglesUsecase:
                                widget.getArtistSinglesUsecase,
                            getTrackUsecase: widget.getTrackUsecase,
                            getPlaylistUsecase: widget.getPlaylistUsecase,
                          ),
                        );
                      },
                      icon: Icon(
                        LucideIcons.maximize2,
                        size: 18,
                        color: context.themeData.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                      tooltip: context.localization.fullScreenPlayerTooltip,
                    ),
                    const SizedBox(width: 8),
                    if (!track.isLocal)
                      TrackOptions(
                        coreController: widget.coreController,
                        track: track,
                        playerController: widget.playerController,
                        downloaderController: widget.downloaderController,
                        getPlayableItemUsecase: widget.getPlayableItemUsecase,
                        libraryController: widget.libraryController,
                        getAlbumUsecase: widget.getAlbumUsecase,
                        getArtistUsecase: widget.getArtistUsecase,
                        getArtistTracksUsecase: widget.getArtistTracksUsecase,
                        getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                        getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                        getTrackUsecase: widget.getTrackUsecase,
                        getPlaylistUsecase: widget.getPlaylistUsecase,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AlbumArtwork extends StatelessWidget {
  final bool isLocal;
  final VoidCallback onTap;
  final Widget child;

  const _AlbumArtwork({
    required this.isLocal,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLocal) {
      return child;
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: child,
    );
  }
}
