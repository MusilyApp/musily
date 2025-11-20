import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/duration.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/core/presenter/widgets/musily_loading.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/widgets/download_button.dart';
import 'package:musily/features/player/domain/enums/player_mode.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_button.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/player/presenter/widgets/player_background.dart';
import 'package:musily/features/player/presenter/widgets/player_banner.dart';
import 'package:musily/features/player/presenter/widgets/player_options.dart';
import 'package:musily/features/player/presenter/widgets/player_title.dart';
import 'package:musily/features/player/presenter/widgets/sleep_timer_dialog.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class PlayerWidget extends StatefulWidget {
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final CoreController coreController;
  final GetArtistUsecase getArtistUsecase;
  final GetTrackUsecase getTrackUsecase;

  const PlayerWidget({
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
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  Duration _seekDuration = Duration.zero;
  bool _useSeekDuration = false;
  bool loadingAlbum = true;

  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'player',
      child: widget.playerController.builder(
        builder: (context, data) {
          final currentPlayingItem = data.currentPlayingItem!;
          final isLocal = currentPlayingItem.isLocal;
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                if (currentPlayingItem.highResImg != null &&
                    currentPlayingItem.highResImg!.isNotEmpty)
                  PlayerBackground(imageUrl: currentPlayingItem.highResImg!),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                LyNavigator.close('player');
                              },
                              icon: const Icon(
                                LucideIcons.chevronDown,
                                size: 20,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: PlayerTitle(
                                  playerController: widget.playerController,
                                  playerMode: data.playerMode,
                                  syncedLyrics: data.syncedLyrics,
                                  autoSmartQueue: data.autoSmartQueue,
                                  loadingSmartQueue: data.loadingSmartQueue,
                                  currentTrack: currentPlayingItem,
                                ),
                              ),
                            ),
                            PlayerOptions(
                              playerController: widget.playerController,
                              playerMode: data.playerMode,
                              track: data.currentPlayingItem!,
                              libraryController: widget.libraryController,
                              getTrackUsecase: widget.getTrackUsecase,
                              getPlaylistUsecase: widget.getPlaylistUsecase,
                              getAlbumUsecase: widget.getAlbumUsecase,
                              downloaderController: widget.downloaderController,
                              getPlayableItemUsecase:
                                  widget.getPlayableItemUsecase,
                              getArtistAlbumsUsecase:
                                  widget.getArtistAlbumsUsecase,
                              getArtistSinglesUsecase:
                                  widget.getArtistSinglesUsecase,
                              getArtistTracksUsecase:
                                  widget.getArtistTracksUsecase,
                              getArtistUsecase: widget.getArtistUsecase,
                              coreController: widget.coreController,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PlayerBanner(
                          getTrackUsecase: widget.getTrackUsecase,
                          track: currentPlayingItem,
                          playerController: widget.playerController,
                          coreController: widget.coreController,
                          getAlbumUsecase: widget.getAlbumUsecase,
                          downloaderController: widget.downloaderController,
                          getPlayableItemUsecase: widget.getPlayableItemUsecase,
                          libraryController: widget.libraryController,
                          getPlaylistUsecase: widget.getPlaylistUsecase,
                          getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                          getArtistSinglesUsecase:
                              widget.getArtistSinglesUsecase,
                          getArtistTracksUsecase: widget.getArtistTracksUsecase,
                          getArtistUsecase: widget.getArtistUsecase,
                        ),
                      ),
                      Column(
                        children: [
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: data.playerMode != PlayerMode.queue
                                  ? 1.0
                                  : 0.0,
                              child: data.playerMode != PlayerMode.queue
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: LyListTile(
                                        title: InfinityMarquee(
                                          child: Text(
                                            currentPlayingItem.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        subtitle: _ArtistSubtitle(
                                          isLocal: isLocal,
                                          artistName:
                                              currentPlayingItem.artist.name,
                                          onTap: () {
                                            LyNavigator.close('player');
                                            LyNavigator.push(
                                              context.showingPageContext,
                                              AsyncArtistPage(
                                                trackId:
                                                    data.currentPlayingItem!.id,
                                                getTrackUsecase:
                                                    widget.getTrackUsecase,
                                                artistId: data
                                                    .currentPlayingItem!
                                                    .artist
                                                    .id,
                                                coreController:
                                                    widget.coreController,
                                                getPlaylistUsecase:
                                                    widget.getPlaylistUsecase,
                                                playerController:
                                                    widget.playerController,
                                                getAlbumUsecase:
                                                    widget.getAlbumUsecase,
                                                downloaderController:
                                                    widget.downloaderController,
                                                getPlayableItemUsecase: widget
                                                    .getPlayableItemUsecase,
                                                libraryController:
                                                    widget.libraryController,
                                                getArtistAlbumsUsecase: widget
                                                    .getArtistAlbumsUsecase,
                                                getArtistSinglesUsecase: widget
                                                    .getArtistSinglesUsecase,
                                                getArtistTracksUsecase: widget
                                                    .getArtistTracksUsecase,
                                                getArtistUsecase:
                                                    widget.getArtistUsecase,
                                              ),
                                            );
                                          },
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (!isLocal)
                                              DownloadButton(
                                                controller:
                                                    widget.downloaderController,
                                                track: data.currentPlayingItem!,
                                                coreController:
                                                    widget.coreController,
                                              ),
                                            if (data.tracksFromSmartQueue
                                                .contains(
                                              currentPlayingItem.hash,
                                            ))
                                              IconButton(
                                                onPressed: () {
                                                  widget
                                                      .libraryController.methods
                                                      .addTracksToPlaylist(
                                                    widget.playerController.data
                                                        .playingId,
                                                    [currentPlayingItem],
                                                  );
                                                },
                                                color: context.themeData
                                                    .colorScheme.primary,
                                                icon: const Icon(
                                                  LucideIcons.circlePlus,
                                                  size: 20,
                                                ),
                                              ),
                                            if (!isLocal)
                                              FavoriteButton(
                                                libraryController:
                                                    widget.libraryController,
                                                track: data.currentPlayingItem!,
                                              ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 16,
                                ),
                              ),
                              child: Slider(
                                inactiveColor: context
                                    .themeData.buttonTheme.colorScheme?.primary
                                    .withValues(alpha: .3),
                                min: 0,
                                max: currentPlayingItem.duration.inSeconds
                                    .toDouble(),
                                value: () {
                                  if (currentPlayingItem.position.inSeconds >
                                      currentPlayingItem.duration.inSeconds) {
                                    return 0.0;
                                  }
                                  if (_useSeekDuration) {
                                    return _seekDuration.inSeconds.toDouble();
                                  }
                                  if (currentPlayingItem.position.inSeconds
                                          .toDouble() >=
                                      0) {
                                    return currentPlayingItem.position.inSeconds
                                        .toDouble();
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
                                  await widget.playerController.methods
                                      .resume();
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Builder(
                                  builder: (context) {
                                    late final Duration duration;
                                    if (_useSeekDuration) {
                                      duration = _seekDuration;
                                    } else {
                                      duration = currentPlayingItem.position;
                                    }
                                    return Text(
                                      duration.formatDuration,
                                      style: context
                                          .themeData.textTheme.bodySmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: context
                                            .themeData.colorScheme.onSurface
                                            .withValues(alpha: 0.8),
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  currentPlayingItem.duration.formatDuration,
                                  style: context.themeData.textTheme.bodySmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: context
                                        .themeData.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  fit: StackFit.loose,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await widget.playerController.methods
                                            .toggleShuffle();
                                      },
                                      icon: Icon(
                                        LucideIcons.shuffle,
                                        size: 20,
                                        color: data.shuffleEnabled
                                            ? context.themeData.buttonTheme
                                                .colorScheme?.primary
                                            : null,
                                      ),
                                    ),
                                    if (data.shuffleEnabled) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 21,
                                          top: 30,
                                        ),
                                        child: Icon(
                                          LucideIcons.circle,
                                          size: 4,
                                          color: context.themeData.buttonTheme
                                              .colorScheme?.primary,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 11,
                                          top: 20,
                                        ),
                                        child: Icon(
                                          Icons.fiber_manual_record,
                                          size: 8,
                                          color: context.themeData.buttonTheme
                                              .colorScheme?.primary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Builder(
                                  builder: (context) {
                                    bool previousEnabled = true;
                                    if (data.queue.first.id ==
                                        currentPlayingItem.id) {
                                      if (!data.shuffleEnabled) {
                                        if (data.repeatMode ==
                                                MusilyRepeatMode.noRepeat ||
                                            data.repeatMode ==
                                                MusilyRepeatMode.repeatOne) {
                                          if (currentPlayingItem
                                                  .position.inSeconds <
                                              5) {
                                            previousEnabled = false;
                                          }
                                        }
                                      }
                                    }
                                    return IconButton(
                                      onPressed: !previousEnabled
                                          ? null
                                          : () async {
                                              if (currentPlayingItem
                                                      .position.inSeconds <
                                                  5) {
                                                await widget
                                                    .playerController.methods
                                                    .previousInQueue();
                                              } else {
                                                widget.playerController.methods
                                                    .seek(Duration.zero);
                                              }
                                            },
                                      icon: const Icon(
                                        LucideIcons.skipBack,
                                        size: 30,
                                      ),
                                    );
                                  },
                                ),
                                Builder(
                                  builder: (context) {
                                    if ((!data.mediaAvailable ||
                                            data.isBuffering) &&
                                        data.loadRequested) {
                                      return const SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: Center(
                                          child: MusilyLoading(size: 45),
                                        ),
                                      );
                                    }
                                    return Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: context
                                            .themeData.colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: IconButton(
                                        onPressed: () async {
                                          if (data.currentPlayingItem?.duration
                                                  .inSeconds ==
                                              0) {
                                            widget.playerController.methods
                                                .loadAndPlay(
                                              data.currentPlayingItem!,
                                              data.playingId,
                                            );
                                            return;
                                          }
                                          if (data.isPlaying) {
                                            widget.playerController.methods
                                                .pause();
                                          } else if (data.mediaAvailable) {
                                            widget.playerController.methods
                                                .resume();
                                          } else if (data.currentPlayingItem !=
                                              null) {
                                            final playingId = data
                                                    .playingId.isNotEmpty
                                                ? data.playingId
                                                : data.currentPlayingItem!.id;
                                            await widget
                                                .playerController.methods
                                                .loadAndPlay(
                                              data.currentPlayingItem!,
                                              playingId,
                                            );
                                          }
                                        },
                                        visualDensity: VisualDensity.standard,
                                        iconSize: 35,
                                        icon: Icon(
                                          data.isPlaying
                                              ? LucideIcons.pause
                                              : LucideIcons.play,
                                          color: context
                                              .themeData.colorScheme.onPrimary,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Builder(
                                  builder: (context) {
                                    bool nextEnabled = true;
                                    if (data.queue.last.id ==
                                        currentPlayingItem.id) {
                                      if (!data.shuffleEnabled) {
                                        if (data.repeatMode ==
                                                MusilyRepeatMode.noRepeat ||
                                            data.repeatMode ==
                                                MusilyRepeatMode.repeatOne) {
                                          nextEnabled = false;
                                        }
                                      }
                                    }
                                    return IconButton(
                                      onPressed: !nextEnabled
                                          ? null
                                          : () async {
                                              await widget
                                                  .playerController.methods
                                                  .nextInQueue();
                                            },
                                      icon: const Icon(
                                        LucideIcons.skipForward,
                                        size: 30,
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await widget.playerController.methods
                                        .toggleRepeatState();
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
                                        size: 20,
                                        color: data.repeatMode !=
                                                MusilyRepeatMode.noRepeat
                                            ? context.themeData.buttonTheme
                                                .colorScheme?.primary
                                            : null,
                                      ),
                                      if (data.repeatMode ==
                                          MusilyRepeatMode.repeat)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 7,
                                            top: 7,
                                          ),
                                          child: Icon(
                                            Icons.fiber_manual_record,
                                            size: 6,
                                            color: context.themeData.buttonTheme
                                                .colorScheme?.primary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if (!isLocal)
                                  IconButton(
                                    onPressed: () {
                                      widget.coreController.methods.shareSong(
                                        currentPlayingItem,
                                      );
                                    },
                                    icon: const Icon(LucideIcons.share2,
                                        size: 20),
                                  ),
                                if (!isLocal)
                                  IconButton(
                                    onPressed: () {
                                      final newMode =
                                          data.playerMode == PlayerMode.lyrics
                                              ? PlayerMode.artwork
                                              : PlayerMode.lyrics;
                                      widget.playerController.methods
                                          .setPlayerMode(
                                        newMode,
                                      );
                                    },
                                    iconSize: 20,
                                    icon: Icon(
                                      data.playerMode != PlayerMode.lyrics
                                          ? LucideIcons.music2
                                          : LucideIcons.disc2,
                                      color:
                                          data.playerMode == PlayerMode.lyrics
                                              ? context
                                                  .themeData.colorScheme.primary
                                              : null,
                                    ),
                                  ),
                                IconButton(
                                  onPressed: () {
                                    if (data.playerMode == PlayerMode.queue) {
                                      widget.playerController.methods
                                          .setPlayerMode(PlayerMode.artwork);
                                    } else {
                                      widget.playerController.methods
                                          .setPlayerMode(PlayerMode.queue);
                                    }
                                  },
                                  icon: Icon(
                                    data.playerMode == PlayerMode.queue
                                        ? LucideIcons.disc2
                                        : LucideIcons.listMusic,
                                    size: 20,
                                    color: data.playerMode == PlayerMode.queue
                                        ? context.themeData.colorScheme.primary
                                        : null,
                                  ),
                                ),
                                Stack(
                                  children: [
                                    IconButton(
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
                                        size: 20,
                                        color: data.sleepTimerActive
                                            ? context
                                                .themeData.colorScheme.primary
                                            : null,
                                      ),
                                    ),
                                    if (data.sleepTimerActive)
                                      Positioned(
                                        right: 8,
                                        top: 8,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: context
                                                .themeData.colorScheme.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ArtistSubtitle extends StatelessWidget {
  final bool isLocal;
  final String artistName;
  final VoidCallback onTap;

  const _ArtistSubtitle({
    required this.isLocal,
    required this.artistName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          LucideIcons.micVocal,
          size: 14,
          color: context.themeData.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: InfinityMarquee(
            child: Text(
              artistName,
              style: context.themeData.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );

    if (isLocal) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      child: content,
    );
  }
}
