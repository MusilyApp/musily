import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/widgets/track_downloader_widget.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_button.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';
import 'package:musily/features/player/presenter/widgets/player_background.dart';
import 'package:musily/features/player/presenter/widgets/player_banner.dart';
import 'package:musily/features/player/presenter/widgets/queue_widget.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/presenter/widgets/track_options.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';
import 'package:musily_player/musily_player.dart';

class PlayerWidget extends StatefulWidget {
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final CoreController coreController;
  final LibraryController libraryController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistUsecase getArtistUsecase;
  final ResultsPageController resultsPageController;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  final void Function()? onClose;
  const PlayerWidget({
    required this.playerController,
    required this.getAlbumUsecase,
    required this.coreController,
    required this.libraryController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getArtistUsecase,
    required this.resultsPageController,
    this.onClose,
    super.key,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
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
    return widget.coreController.builder(
      eventListener: (context, event, data) {
        if (event.id == 'closePlayer') {
          Navigator.pop(context);
          widget.coreController.updateData(
            widget.coreController.data.copyWith(
              isPlayerExpanded: false,
            ),
          );
        }
      },
      builder: (context, data) {
        return PopScope(
          onPopInvoked: (didPop) {
            widget.coreController.updateData(
              widget.coreController.data.copyWith(
                isPlayerExpanded: false,
              ),
            );
          },
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
                              bottom: 8,
                              left: 12,
                              right: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Builder(
                                  builder: (context) {
                                    if (widget.onClose != null) {
                                      return IconButton(
                                        onPressed: () {
                                          widget.onClose!.call();
                                        },
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 30,
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                                TrackOptionsBuilder(
                                  getAlbumUsecase: widget.getAlbumUsecase,
                                  track: TrackModel.fromMusilyTrack(
                                      currentPlayingItem),
                                  coreController: widget.coreController,
                                  playerController: widget.playerController,
                                  getArtistAlbumsUsecase:
                                      widget.getArtistAlbumsUsecase,
                                  getArtistSinglesUsecase:
                                      widget.getArtistSinglesUsecase,
                                  getArtistTracksUsecase:
                                      widget.getArtistTracksUsecase,
                                  getArtistUsecase: widget.getArtistUsecase,
                                  downloaderController:
                                      widget.downloaderController,
                                  getPlayableItemUsecase:
                                      widget.getPlayableItemUsecase,
                                  libraryController: widget.libraryController,
                                  hideOptions: const [
                                    TrackTileOptions.seeAlbum,
                                    TrackTileOptions.seeArtist,
                                  ],
                                  builder: (
                                    BuildContext context,
                                    void Function() showOptions,
                                  ) {
                                    return IconButton(
                                      onPressed: showOptions,
                                      icon: const Icon(
                                        Icons.more_vert,
                                        size: 25,
                                      ),
                                    );
                                  },
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
                            getPlayableItemUsecase:
                                widget.getPlayableItemUsecase,
                            libraryController: widget.libraryController,
                            getArtistAlbumsUsecase:
                                widget.getArtistAlbumsUsecase,
                            getArtistTracksUsecase:
                                widget.getArtistTracksUsecase,
                            getArtistSinglesUsecase:
                                widget.getArtistSinglesUsecase,
                            getArtistUsecase: widget.getArtistUsecase,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: ListTile(
                                  title: InfinityMarquee(
                                    child: Text(
                                      currentPlayingItem.title ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  subtitle: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      widget.coreController.methods.pushWidget(
                                        AsyncArtistPage(
                                          artistId:
                                              currentPlayingItem.artist?.id ??
                                                  '',
                                          coreController: widget.coreController,
                                          playerController:
                                              widget.playerController,
                                          downloaderController:
                                              widget.downloaderController,
                                          getPlayableItemUsecase:
                                              widget.getPlayableItemUsecase,
                                          libraryController:
                                              widget.libraryController,
                                          getAlbumUsecase:
                                              widget.getAlbumUsecase,
                                          getArtistUsecase:
                                              widget.getArtistUsecase,
                                          getArtistAlbumsUsecase:
                                              widget.getArtistAlbumsUsecase,
                                          getArtistTracksUsecase:
                                              widget.getArtistTracksUsecase,
                                          getArtistSinglesUsecase:
                                              widget.getArtistSinglesUsecase,
                                        ),
                                      );
                                    },
                                    child: InfinityMarquee(
                                      child: Text(
                                        currentPlayingItem.artist?.name ?? '',
                                      ),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TrackDownloaderWidget(
                                        downloaderController:
                                            widget.downloaderController,
                                        track: TrackModel.fromMusilyTrack(
                                            currentPlayingItem),
                                        getPlayableItemUsecase:
                                            widget.getPlayableItemUsecase,
                                      ),
                                      FavoriteButton(
                                        libraryController:
                                            widget.libraryController,
                                        track: TrackModel.fromMusilyTrack(
                                            currentPlayingItem),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Slider(
                                inactiveColor: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme
                                    ?.primary
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
                                  await widget.playerController.methods
                                      .resume();
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Builder(builder: (context) {
                                      late final Duration duration;
                                      if (_useSeekDuration) {
                                        duration = _seekDuration;
                                      } else {
                                        duration = currentPlayingItem.position;
                                      }
                                      return Text(
                                          '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}');
                                    }),
                                    Text(
                                        '${currentPlayingItem.duration.inMinutes}:${(currentPlayingItem.duration.inSeconds % 60).toString().padLeft(2, '0')}'),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      fit: StackFit.loose,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await widget
                                                .playerController.methods
                                                .toggleShuffle();
                                          },
                                          icon: Icon(
                                            Icons.shuffle_rounded,
                                            size: 30,
                                            color: data.shuffleEnabled
                                                ? Theme.of(context)
                                                    .buttonTheme
                                                    .colorScheme
                                                    ?.primary
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
                                              color: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme
                                                  ?.primary,
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
                                              color: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme
                                                  ?.primary,
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
                                                  widget
                                                      .playerController.methods
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
                                      if (currentPlayingItem
                                              .duration.inSeconds ==
                                          0) {
                                        return SizedBox(
                                          width: 86,
                                          height: 86,
                                          child: Center(
                                            child: LoadingAnimationWidget
                                                .halfTriangleDot(
                                              color: Theme.of(context)
                                                      .iconTheme
                                                      .color ??
                                                  Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        );
                                      }
                                      return IconButton(
                                        onPressed: () {
                                          if (data.isPlaying) {
                                            widget.playerController.methods
                                                .pause();
                                          } else {
                                            widget.playerController.methods
                                                .resume();
                                          }
                                        },
                                        icon: Icon(
                                          data.isPlaying
                                              ? Icons
                                                  .pause_circle_filled_rounded
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
                                                  return Icons
                                                      .repeat_one_rounded;
                                              }
                                            }(),
                                            size: 30,
                                            color: data.repeatMode !=
                                                    MusilyRepeatMode.noRepeat
                                                ? Theme.of(context)
                                                    .buttonTheme
                                                    .colorScheme
                                                    ?.primary
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
                                                color: Theme.of(context)
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.share_rounded,
                                      size: 20,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => widget
                                        .playerController.methods
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
                                    onPressed: data.queue.length < 2
                                        ? null
                                        : () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) => Scaffold(
                                                body: SafeArea(
                                                  child: QueueWidget(
                                                    playerController:
                                                        widget.playerController,
                                                    coreController:
                                                        widget.coreController,
                                                  ),
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
      },
    );
  }
}
