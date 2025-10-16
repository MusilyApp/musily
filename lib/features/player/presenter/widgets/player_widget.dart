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
import 'package:musily/features/player/presenter/widgets/player_switches.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
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
                                    LucideIcons.chevronDown,
                                    size: 20,
                                  ),
                                );
                              },
                            ),
                            if (data.playerMode == PlayerMode.queue)
                              Expanded(
                                child: Center(
                                  child: Column(
                                    children: [
                                      InfinityMarquee(
                                        child: Text(
                                          currentPlayingItem.title,
                                          style: context
                                              .themeData.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity: 0.7,
                                        child: InfinityMarquee(
                                          child: Text(
                                            currentPlayingItem.artist.name,
                                            style: context
                                                .themeData.textTheme.bodyMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              PlayerSwitches(
                                playerController: widget.playerController,
                                playerMode: data.playerMode,
                                syncedLyrics: data.syncedLyrics,
                                autoSmartQueue: data.autoSmartQueue,
                                loadingSmartQueue: data.loadingSmartQueue,
                              ),
                            TrackOptions(
                              getTrackUsecase: widget.getTrackUsecase,
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
                        getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                        getArtistTracksUsecase: widget.getArtistTracksUsecase,
                        getArtistUsecase: widget.getArtistUsecase,
                      ),
                      Column(
                        children: [
                          if (data.playerMode != PlayerMode.queue)
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
                                        trackId: data.currentPlayingItem!.id,
                                        getTrackUsecase: widget.getTrackUsecase,
                                        artistId:
                                            data.currentPlayingItem!.artist.id,
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
                                            widget.playerController.data
                                                .playingId,
                                            [
                                              currentPlayingItem,
                                            ],
                                          );
                                        },
                                        color: context
                                            .themeData.colorScheme.primary,
                                        icon: const Icon(
                                          LucideIcons.circlePlus,
                                          size: 20,
                                        ),
                                      ),
                                    FavoriteButton(
                                      libraryController:
                                          widget.libraryController,
                                      track: data.currentPlayingItem!,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Slider(
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
                                      LucideIcons.skipBack,
                                      size: 30,
                                    ),
                                  );
                                }),
                                Builder(builder: (context) {
                                  if (currentPlayingItem.duration.inSeconds ==
                                      0) {
                                    return const SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Center(
                                        child: MusilyLoading(
                                          size: 45,
                                        ),
                                      ),
                                    );
                                  }
                                  return InkWell(
                                    onTap: () {
                                      if (data.isPlaying) {
                                        widget.playerController.methods.pause();
                                      } else {
                                        widget.playerController.methods
                                            .resume();
                                      }
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: context
                                            .themeData.colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: IconButton(
                                        onPressed: () {
                                          if (data.isPlaying) {
                                            widget.playerController.methods
                                                .pause();
                                          } else {
                                            widget.playerController.methods
                                                .resume();
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
                                      LucideIcons.skipForward,
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
                                  LucideIcons.share2,
                                  size: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  final newMode =
                                      data.playerMode == PlayerMode.lyrics
                                          ? PlayerMode.artwork
                                          : PlayerMode.lyrics;
                                  widget.playerController.methods
                                      .setPlayerMode(newMode);
                                },
                                iconSize: 20,
                                icon: Icon(
                                  data.playerMode != PlayerMode.lyrics
                                      ? LucideIcons.music2
                                      : LucideIcons.disc2,
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
