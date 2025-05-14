import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/duration.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/widgets/download_button.dart';
import 'package:musily/features/player/presenter/widgets/queue_widget.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_button.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/player/presenter/widgets/in_context_dialog.dart';
import 'package:musily/features/player/presenter/widgets/track_lyrics.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/presenter/widgets/track_options.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';

class MiniPlayerDesktop extends StatefulWidget {
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

  const MiniPlayerDesktop({
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
  });

  @override
  State<MiniPlayerDesktop> createState() => _MiniPlayerDesktopState();
}

class _MiniPlayerDesktopState extends State<MiniPlayerDesktop> {
  Duration _seekDuration = Duration.zero;
  bool _useSeekDuration = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return widget.playerController.builder(
        builder: (context, data) {
          final availableHeight = constraints.maxHeight;
          return Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                  ),
                  child: SizedBox(
                    height: availableHeight - 80,
                    child: InContextDialog(
                      show: data.showQueue,
                      width: 350,
                      child: Card(
                        color: context.themeData.scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            strokeAlign: 1,
                            color: context.themeData.dividerColor.withValues(
                              alpha: .2,
                            ),
                          ),
                        ),
                        child: QueueWidget(
                          playerController: widget.playerController,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                  ),
                  child: SizedBox(
                    height: availableHeight - 80,
                    child: InContextDialog(
                      show: data.showLyrics,
                      width: 350,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            strokeAlign: 1,
                            color: context.themeData.dividerColor.withValues(
                              alpha: .2,
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                            color: context.themeData.colorScheme.inversePrimary,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                            child: Builder(builder: (context) {
                              if (data.loadingLyrics) {
                                return Center(
                                  child: LoadingAnimationWidget.waveDots(
                                    color: IconTheme.of(context).color ??
                                        Colors.white,
                                    size: 45,
                                  ),
                                );
                              }
                              if (data.lyrics.lyrics == null) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.music_off_rounded,
                                        size: 45,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        context.localization.lyricsNotFound,
                                        style: context
                                            .themeData.textTheme.bodyLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                              return TrackLyrics(
                                totalDuration:
                                    data.currentPlayingItem!.duration,
                                currentPosition:
                                    data.currentPlayingItem!.position,
                                lyrics: data.lyrics.lyrics!,
                                timedLyrics: data.lyrics.timedLyrics,
                                synced: data.syncedLyrics,
                                onTimeSelected: (duration) =>
                                    widget.playerController.methods.seek(
                                  duration,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: context.themeData.dividerColor.withValues(
                          alpha: .2,
                        ),
                      ),
                    ),
                  ),
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          width: 1,
                                          color: context
                                              .themeData.colorScheme.outline
                                              .withValues(alpha: .2),
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          LyNavigator.close('player');
                                          LyNavigator.push(
                                            context.showingPageContext,
                                            AsyncAlbumPage(
                                              albumId: data
                                                  .currentPlayingItem!.album.id,
                                              getPlaylistUsecase:
                                                  widget.getPlaylistUsecase,
                                              coreController:
                                                  widget.coreController,
                                              playerController:
                                                  widget.playerController,
                                              getAlbumUsecase:
                                                  widget.getAlbumUsecase,
                                              downloaderController:
                                                  widget.downloaderController,
                                              getPlayableItemUsecase:
                                                  widget.getPlayableItemUsecase,
                                              libraryController:
                                                  widget.libraryController,
                                              getArtistAlbumsUsecase:
                                                  widget.getArtistAlbumsUsecase,
                                              getArtistSinglesUsecase: widget
                                                  .getArtistSinglesUsecase,
                                              getArtistTracksUsecase:
                                                  widget.getArtistTracksUsecase,
                                              getArtistUsecase:
                                                  widget.getArtistUsecase,
                                            ),
                                          );
                                        },
                                        child: Builder(
                                          builder: (context) {
                                            if (data.currentPlayingItem!
                                                        .lowResImg !=
                                                    null &&
                                                data.currentPlayingItem!
                                                    .lowResImg!.isNotEmpty) {
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: AppImage(
                                                  data.currentPlayingItem!
                                                      .lowResImg!,
                                                  width: 45,
                                                  height: 45,
                                                ),
                                              );
                                            }
                                            return SizedBox(
                                              height: 45,
                                              width: 45,
                                              child: Icon(
                                                Icons.music_note,
                                                color: context
                                                    .themeData.iconTheme.color
                                                    ?.withValues(alpha: .7),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    if (data.tracksFromSmartQueue.contains(
                                      data.currentPlayingItem!.hash,
                                    ))
                                      Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                context.themeData.colorScheme
                                                    .primary,
                                                context.themeData.colorScheme
                                                    .primary
                                                    .withValues(alpha: .2),
                                              ],
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              CupertinoIcons.wand_stars,
                                              color: context.themeData
                                                  .colorScheme.onPrimary,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InfinityMarquee(
                                        child: Text(
                                          data.currentPlayingItem!.title,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (!context.display.isDesktop) {
                                            LyNavigator.close('player');
                                          }
                                          LyNavigator.push(
                                            context.showingPageContext,
                                            AsyncArtistPage(
                                              artistId: data.currentPlayingItem!
                                                  .artist.id,
                                              coreController:
                                                  widget.coreController,
                                              playerController:
                                                  widget.playerController,
                                              getPlaylistUsecase:
                                                  widget.getPlaylistUsecase,
                                              getAlbumUsecase:
                                                  widget.getAlbumUsecase,
                                              downloaderController:
                                                  widget.downloaderController,
                                              getPlayableItemUsecase:
                                                  widget.getPlayableItemUsecase,
                                              libraryController:
                                                  widget.libraryController,
                                              getArtistAlbumsUsecase:
                                                  widget.getArtistAlbumsUsecase,
                                              getArtistSinglesUsecase: widget
                                                  .getArtistSinglesUsecase,
                                              getArtistTracksUsecase:
                                                  widget.getArtistTracksUsecase,
                                              getArtistUsecase:
                                                  widget.getArtistUsecase,
                                            ),
                                          );
                                        },
                                        child: InfinityMarquee(
                                          child: Text(
                                            data.currentPlayingItem!.artist
                                                .name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      FavoriteButton(
                                        libraryController:
                                            widget.libraryController,
                                        track: data.currentPlayingItem!,
                                      ),
                                      DownloadButton(
                                        controller: widget.downloaderController,
                                        track: data.currentPlayingItem!,
                                      ),
                                      if (data.tracksFromSmartQueue.contains(
                                          data.currentPlayingItem!.hash))
                                        IconButton(
                                          onPressed: () {
                                            widget.libraryController.methods
                                                .addTracksToPlaylist(
                                              widget.playerController.data
                                                  .playingId,
                                              [
                                                data.currentPlayingItem!,
                                              ],
                                            );
                                          },
                                          color: context
                                              .themeData.colorScheme.primary,
                                          icon: const Icon(
                                            Icons.add_circle_rounded,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                          Icons.shuffle_rounded,
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
                                            left: 17,
                                            top: 23,
                                          ),
                                          child: Icon(
                                            Icons.fiber_manual_record,
                                            size: 5,
                                            color: context.themeData.buttonTheme
                                                .colorScheme?.primary,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            top: 17,
                                          ),
                                          child: Icon(
                                            Icons.fiber_manual_record,
                                            size: 6,
                                            color: context.themeData.buttonTheme
                                                .colorScheme?.primary,
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                  Builder(builder: (context) {
                                    bool previousEnabled = true;
                                    if (data.queue.firstOrNull?.id ==
                                        data.currentPlayingItem!.id) {
                                      if (!data.shuffleEnabled) {
                                        if (data.repeatMode ==
                                                MusilyRepeatMode.noRepeat ||
                                            data.repeatMode ==
                                                MusilyRepeatMode.repeatOne) {
                                          if (data.currentPlayingItem!.position
                                                  .inSeconds <
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
                                              if (data.currentPlayingItem!
                                                      .position.inSeconds <
                                                  5) {
                                                await widget
                                                    .playerController.methods
                                                    .previousInQueue();
                                              } else {
                                                widget.playerController.methods
                                                    .seek(
                                                  Duration.zero,
                                                );
                                              }
                                            },
                                      icon: const Icon(
                                        Icons.skip_previous_rounded,
                                        size: 30,
                                      ),
                                    );
                                  }),
                                  IconButton(
                                    onPressed: () {
                                      if (data.isPlaying) {
                                        widget.playerController.methods.pause();
                                      } else {
                                        widget.playerController.methods
                                            .resume();
                                      }
                                    },
                                    icon: Icon(
                                      data.isPlaying
                                          ? Icons.pause_circle_filled_rounded
                                          : Icons.play_circle_rounded,
                                      size: 40,
                                    ),
                                  ),
                                  Builder(builder: (context) {
                                    bool nextEnabled = true;
                                    if (data.queue.lastOrNull?.id ==
                                        data.currentPlayingItem!.id) {
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
                                        Icons.skip_next_rounded,
                                        size: 30,
                                      ),
                                    );
                                  }),
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
                                                return Icons.repeat_rounded;
                                              case MusilyRepeatMode.repeat:
                                                return Icons.repeat_rounded;
                                              case MusilyRepeatMode.repeatOne:
                                                return Icons.repeat_one_rounded;
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
                                              color: context
                                                  .themeData
                                                  .buttonTheme
                                                  .colorScheme
                                                  ?.primary,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Builder(builder: (context) {
                                  late final Duration duration;
                                  if (_useSeekDuration) {
                                    duration = _seekDuration;
                                  } else {
                                    duration =
                                        data.currentPlayingItem!.position;
                                  }
                                  return Text(
                                    duration.formatDuration,
                                    style:
                                        context.themeData.textTheme.bodySmall,
                                  );
                                }),
                                Slider(
                                  min: 0,
                                  max: data
                                      .currentPlayingItem!.duration.inSeconds
                                      .toDouble(),
                                  value: () {
                                    if (data.currentPlayingItem!.position
                                            .inSeconds >
                                        data.currentPlayingItem!.duration
                                            .inSeconds) {
                                      return 0.0;
                                    }
                                    if (_useSeekDuration) {
                                      return _seekDuration.inSeconds.toDouble();
                                    }
                                    if (data.currentPlayingItem!.position
                                            .inSeconds
                                            .toDouble() >=
                                        0) {
                                      return data.currentPlayingItem!.position
                                          .inSeconds
                                          .toDouble();
                                    }
                                    return 0.0;
                                  }(),
                                  onChanged: (value) {
                                    setState(() {
                                      _useSeekDuration = true;
                                      _seekDuration =
                                          Duration(seconds: value.toInt());
                                    });
                                  },
                                  onChangeEnd: (value) async {
                                    setState(() {
                                      _useSeekDuration = false;
                                    });
                                    await widget.playerController.methods
                                        .seek(_seekDuration);
                                    await widget.playerController.methods
                                        .resume();
                                  },
                                ),
                                Text(
                                  data.currentPlayingItem!.duration
                                      .formatDuration,
                                  style: context.themeData.textTheme.bodySmall,
                                ),
                                Stack(
                                  fit: StackFit.loose,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        widget.playerController.methods
                                            .toggleShowQueue();
                                      },
                                      icon: Icon(
                                        Icons.queue_music_rounded,
                                        size: 20,
                                        color: data.showQueue
                                            ? context
                                                .themeData.colorScheme.primary
                                            : null,
                                      ),
                                    ),
                                    if (data.showQueue)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 28,
                                          left: 17,
                                        ),
                                        child: Icon(
                                          Icons.fiber_manual_record,
                                          size: 6,
                                          color: context
                                              .themeData.colorScheme.primary,
                                        ),
                                      ),
                                  ],
                                ),
                                Stack(
                                  fit: StackFit.loose,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        widget.playerController.methods
                                            .toggleLyrics(
                                          data.currentPlayingItem!.id,
                                        );
                                      },
                                      iconSize: 20,
                                      icon: Icon(
                                        Icons.lyrics_rounded,
                                        color: data.showLyrics
                                            ? context
                                                .themeData.colorScheme.primary
                                            : null,
                                      ),
                                    ),
                                    if (data.showLyrics)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 28,
                                          left: 16,
                                        ),
                                        child: Icon(
                                          Icons.fiber_manual_record,
                                          size: 6,
                                          color: context
                                              .themeData.colorScheme.primary,
                                        ),
                                      )
                                  ],
                                ),
                                TrackOptions(
                                  getPlaylistUsecase: widget.getPlaylistUsecase,
                                  track: data.currentPlayingItem!,
                                  playerController: widget.playerController,
                                  getAlbumUsecase: widget.getAlbumUsecase,
                                  downloaderController:
                                      widget.downloaderController,
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
                                  coreController: widget.coreController,
                                  hideOptions: const [
                                    TrackTileOptions.seeAlbum,
                                    TrackTileOptions.seeArtist,
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
