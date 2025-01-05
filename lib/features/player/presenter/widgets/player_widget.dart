import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/duration.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
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
import 'package:musily/features/player/presenter/widgets/player_background.dart';
import 'package:musily/features/player/presenter/widgets/player_banner.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/presenter/widgets/track_options.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';

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
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                if (currentPlayingItem.highResImg != null &&
                    currentPlayingItem.highResImg!.isNotEmpty)
                  PlayerBackground(
                    imageUrl: currentPlayingItem.highResImg!,
                    playerController: widget.playerController,
                  ),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  onPressed: () {
                                    LyNavigator.close('player');
                                  },
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                  ),
                                );
                              },
                            ),
                            Stack(
                              children: [
                                AnimatedOpacity(
                                  duration: const Duration(
                                    milliseconds: 200,
                                  ),
                                  opacity: data.showLyrics ? 1 : 0,
                                  child: Switch(
                                    activeColor:
                                        context.themeData.colorScheme.onPrimary,
                                    thumbIcon: const WidgetStatePropertyAll(
                                      Icon(Icons.sync_rounded),
                                    ),
                                    value: data.syncedLyrics,
                                    onChanged: data.showLyrics
                                        ? (value) {
                                            widget.playerController.methods
                                                .toggleSyncedLyrics();
                                          }
                                        : null,
                                  ),
                                ),
                                AnimatedOpacity(
                                  opacity: data.showLyrics ? 0 : 1,
                                  duration: const Duration(
                                    milliseconds: 200,
                                  ),
                                  child: data.showLyrics
                                      ? const SizedBox.shrink()
                                      : Switch(
                                          inactiveThumbColor: context
                                              .themeData.colorScheme.primary
                                              .withOpacity(.6),
                                          inactiveTrackColor: context
                                              .themeData.colorScheme.primary
                                              .withOpacity(0.1),
                                          activeColor: context
                                              .themeData.colorScheme.primary,
                                          value: data.tracksFromSmartQueue
                                                  .isNotEmpty ||
                                              data.loadingSmartQueue,
                                          thumbIcon: WidgetStatePropertyAll(
                                            Icon(
                                              CupertinoIcons.wand_rays,
                                              color: context.themeData
                                                  .colorScheme.onPrimary,
                                            ),
                                          ),
                                          onChanged: data.loadingSmartQueue
                                              ? null
                                              : (value) {
                                                  widget
                                                      .playerController.methods
                                                      .toggleSmartQueue();
                                                },
                                        ),
                                ),
                              ],
                            ),
                            TrackOptions(
                              getPlaylistUsecase: widget.getPlaylistUsecase,
                              track: data.currentPlayingItem!,
                              playerController: widget.playerController,
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
                              coreController: widget.coreController,
                              hideOptions: const [
                                TrackTileOptions.seeAlbum,
                                TrackTileOptions.seeArtist,
                                TrackTileOptions.addToQueue,
                              ],
                            ),
                          ],
                        ),
                      ),
                      PlayerBanner(
                        track: currentPlayingItem,
                        playerController: widget.playerController,
                        coreController: widget.coreController,
                        getAlbumUsecase: widget.getAlbumUsecase,
                        downloaderController: widget.downloaderController,
                        getPlayableItemUsecase: widget.getPlayableItemUsecase,
                        libraryController: widget.libraryController,
                        getPlaylistUsecase: widget.getPlaylistUsecase,
                        getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                        getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                        getArtistTracksUsecase: widget.getArtistTracksUsecase,
                        getArtistUsecase: widget.getArtistUsecase,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: LyListTile(
                              title: InfinityMarquee(
                                child: Text(
                                  currentPlayingItem.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              subtitle: InkWell(
                                onTap: () {
                                  LyNavigator.close('player');
                                  LyNavigator.push(
                                    context.showingPageContext,
                                    AsyncArtistPage(
                                      artistId:
                                          data.currentPlayingItem!.artist.id,
                                      coreController: widget.coreController,
                                      getPlaylistUsecase:
                                          widget.getPlaylistUsecase,
                                      playerController: widget.playerController,
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
                                      getArtistUsecase: widget.getArtistUsecase,
                                    ),
                                  );
                                },
                                child: InfinityMarquee(
                                  child: Text(
                                    currentPlayingItem.artist.name,
                                  ),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DownloadButton(
                                    controller: widget.downloaderController,
                                    track: data.currentPlayingItem!,
                                  ),
                                  if (data.tracksFromSmartQueue
                                      .contains(currentPlayingItem.hash))
                                    IconButton(
                                      onPressed: () {
                                        widget.libraryController.methods
                                            .addTracksToPlaylist(
                                          widget
                                              .playerController.data.playingId,
                                          [
                                            currentPlayingItem,
                                          ],
                                        );
                                      },
                                      color:
                                          context.themeData.colorScheme.primary,
                                      icon: const Icon(
                                        Icons.add_circle_rounded,
                                      ),
                                    ),
                                  FavoriteButton(
                                    libraryController: widget.libraryController,
                                    track: data.currentPlayingItem!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Slider(
                            inactiveColor: context
                                .themeData.buttonTheme.colorScheme?.primary
                                .withOpacity(.3),
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
                              await widget.playerController.methods.resume();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Builder(builder: (context) {
                                  late final Duration duration;
                                  if (_useSeekDuration) {
                                    duration = _seekDuration;
                                  } else {
                                    duration = currentPlayingItem.position;
                                  }
                                  return Text(
                                    duration.formatDuration,
                                  );
                                }),
                                Text(
                                  currentPlayingItem.duration.formatDuration,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                        Icons.shuffle_rounded,
                                        size: 30,
                                        color: data.shuffleEnabled
                                            ? context.themeData.buttonTheme
                                                .colorScheme?.primary
                                            : null,
                                      ),
                                    ),
                                    if (data.shuffleEnabled) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 21.5,
                                          top: 28,
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
                                          left: 11,
                                          top: 19,
                                        ),
                                        child: Icon(
                                          Icons.fiber_manual_record,
                                          size: 8,
                                          color: context.themeData.buttonTheme
                                              .colorScheme?.primary,
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                                Builder(builder: (context) {
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
                                                  .seek(
                                                Duration.zero,
                                              );
                                            }
                                          },
                                    icon: const Icon(
                                      Icons.skip_previous_rounded,
                                      size: 50,
                                    ),
                                  );
                                }),
                                Builder(builder: (context) {
                                  if (currentPlayingItem.duration.inSeconds ==
                                      0) {
                                    return SizedBox(
                                      width: 86,
                                      height: 86,
                                      child: Center(
                                        child: LoadingAnimationWidget
                                            .halfTriangleDot(
                                          color: context
                                                  .themeData.iconTheme.color ??
                                              Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    );
                                  }
                                  return IconButton(
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
                                      size: 70,
                                    ),
                                  );
                                }),
                                Builder(builder: (context) {
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
                                      Icons.skip_next_rounded,
                                      size: 50,
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
                                        size: 30,
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
                                            left: 11,
                                            top: 11,
                                          ),
                                          child: Icon(
                                            Icons.fiber_manual_record,
                                            size: 8,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  widget.coreController.methods.shareSong(
                                    currentPlayingItem,
                                  );
                                },
                                icon: const Icon(
                                  Icons.share_rounded,
                                  size: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () => widget.playerController.methods
                                    .toggleLyrics(
                                  currentPlayingItem.id,
                                ),
                                iconSize: 20,
                                icon: Icon(
                                  !data.showLyrics
                                      ? Icons.lyrics_rounded
                                      : Icons.album_rounded,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  LyNavigator.showBottomSheet(
                                    padding: EdgeInsets.zero,
                                    width: context.display.width,
                                    margin: const EdgeInsets.all(8),
                                    context: context,
                                    content: Expanded(
                                      child: QueueWidget(
                                        playerController:
                                            widget.playerController,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.queue_music_rounded,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
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
