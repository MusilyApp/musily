import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/image_collection.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/presenter/widgets/track_options.dart';

class PlaylistPage extends StatefulWidget {
  final PlaylistEntity playlist;
  final PlayerController playerController;
  final CoreController coreController;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const PlaylistPage({
    required this.playlist,
    required this.libraryController,
    required this.playerController,
    required this.coreController,
    required this.getAlbumUsecase,
    super.key,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late List<String> imageUrls;

  @override
  void initState() {
    super.initState();
    imageUrls = widget.playlist.tracks
        .map((track) => track.highResImg)
        .whereType<String>()
        .toSet()
        .toList()
      ..shuffle(Random());
  }

  @override
  Widget build(BuildContext context) {
    return widget.coreController.builder(
      builder: (context, data) {
        return PopScope(
          canPop: !data.isShowingDialog,
          onPopInvoked: (didPop) {
            if (data.isShowingDialog) {
              widget.coreController.dispatchEvent(
                BaseControllerEvent(
                  id: 'closePlayer',
                  data: data,
                ),
              );
              return;
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.playlist.title),
            ),
            body: Builder(builder: (context) {
              return widget.playerController.builder(
                builder: (context, data) {
                  final bool isAlbumPlaying =
                      data.playingId == widget.playlist.id;
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ImageCollection(
                                urls: imageUrls,
                                size: 250,
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //     vertical: 12,
                            //     horizontal: 26,
                            //   ),
                            //   child: Text(
                            //     widget.playlist.name,
                            //     textAlign: TextAlign.center,
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .headlineSmall
                            //         ?.copyWith(
                            //           fontWeight: FontWeight.w500,
                            //         ),
                            //   ),
                            // ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton.filledTonal(
                                  onPressed: () {},
                                  style: const ButtonStyle(
                                    fixedSize: WidgetStatePropertyAll(
                                      Size(50, 50),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.download_rounded,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                IconButton.filledTonal(
                                  onPressed: () {},
                                  style: const ButtonStyle(
                                    fixedSize: WidgetStatePropertyAll(
                                      Size(50, 50),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.edit_rounded,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                IconButton.filled(
                                  onPressed: () {
                                    if (isAlbumPlaying) {
                                      if (data.isPlaying) {
                                        widget.playerController.methods.pause();
                                        return;
                                      } else {
                                        widget.playerController.methods
                                            .resume();
                                        return;
                                      }
                                    }
                                    widget.playerController.methods
                                        .playPlaylist(
                                      [
                                        ...widget.playlist.tracks.map(
                                          (track) =>
                                              TrackModel.toMusilyTrack(track),
                                        ),
                                      ],
                                      widget.playlist.id,
                                      startFrom: 0,
                                    );
                                    widget.libraryController.methods
                                        .updateLastTimePlayed(
                                      widget.playlist.id,
                                    );
                                  },
                                  style: const ButtonStyle(
                                    iconSize: WidgetStatePropertyAll(40),
                                    fixedSize: WidgetStatePropertyAll(
                                      Size(60, 60),
                                    ),
                                  ),
                                  icon: Icon(
                                    () {
                                      if (isAlbumPlaying) {
                                        if (data.isPlaying) {
                                          return Icons.pause_rounded;
                                        }
                                      }
                                      return Icons.play_arrow_rounded;
                                    }(),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                IconButton.filledTonal(
                                  onPressed: () async {
                                    final random = Random();
                                    final randomIndex = random.nextInt(
                                      widget.playlist.tracks.length,
                                    );
                                    if (isAlbumPlaying) {
                                      widget.playerController.methods
                                          .queueJumpTo(randomIndex);
                                      return;
                                    }
                                    widget.playerController.methods
                                        .playPlaylist(
                                      [
                                        ...widget.playlist.tracks.map(
                                          (track) =>
                                              TrackModel.toMusilyTrack(track),
                                        ),
                                      ],
                                      widget.playlist.id,
                                      startFrom: 0,
                                    );
                                    widget.libraryController.methods
                                        .updateLastTimePlayed(
                                      widget.playlist.id,
                                    );
                                    if (!data.shuffleEnabled) {
                                      widget.playerController.methods
                                          .toggleShuffle();
                                    } else {
                                      await widget.playerController.methods
                                          .toggleShuffle();
                                      widget.playerController.methods
                                          .toggleShuffle();
                                    }
                                  },
                                  style: const ButtonStyle(
                                    fixedSize: WidgetStatePropertyAll(
                                      Size(50, 50),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.shuffle_rounded,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                IconButton.filledTonal(
                                  onPressed: () {},
                                  style: const ButtonStyle(
                                    fixedSize: WidgetStatePropertyAll(
                                      Size(50, 50),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.more_vert_outlined,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            ...widget.playlist.tracks.map(
                              (track) => ListTile(
                                onTap: () {
                                  if (isAlbumPlaying) {
                                    widget.playerController.methods.queueJumpTo(
                                      widget.playlist.tracks.indexOf(track),
                                    );
                                  } else {
                                    widget.playerController.methods
                                        .playPlaylist(
                                      [
                                        ...widget.playlist.tracks.map(
                                          (track) =>
                                              TrackModel.toMusilyTrack(track),
                                        ),
                                      ],
                                      widget.playlist.id,
                                      startFrom:
                                          widget.playlist.tracks.indexOf(track),
                                    );
                                    widget.libraryController.methods
                                        .updateLastTimePlayed(
                                      widget.playlist.id,
                                    );
                                  }
                                },
                                leading: Builder(builder: (context) {
                                  if (track.hash ==
                                      data.currentPlayingItem?.hash) {
                                    if (isAlbumPlaying) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: LoadingAnimationWidget
                                            .staggeredDotsWave(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 20,
                                        ),
                                      );
                                    }
                                  }
                                  return Builder(
                                    builder: (context) {
                                      if (track.lowResImg != null &&
                                          track.highResImg!.isNotEmpty) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: AppImage(
                                            track.lowResImg!,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }
                                      return SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Icon(
                                          Icons.music_note,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color
                                              ?.withOpacity(.7),
                                        ),
                                      );
                                    },
                                  );
                                }),
                                title: InfinityMarquee(
                                  child: Text(
                                    track.title,
                                  ),
                                ),
                                subtitle: Text(
                                  track.artist.name,
                                ),
                                trailing: TrackOptions(
                                  getAlbumUsecase: widget.getAlbumUsecase,
                                  coreController: widget.coreController,
                                  playerController: widget.playerController,
                                  getArtistAlbumsUsecase:
                                      widget.getArtistAlbumsUsecase,
                                  getArtistSinglesUsecase:
                                      widget.getArtistSinglesUsecase,
                                  getArtistTracksUsecase:
                                      widget.getArtistTracksUsecase,
                                  getArtistUsecase: widget.getArtistUsecase,
                                  track: track,
                                  downloaderController:
                                      widget.downloaderController,
                                  getPlayableItemUsecase:
                                      widget.getPlayableItemUsecase,
                                  libraryController: widget.libraryController,
                                  // builder: (
                                  //   BuildContext context,
                                  //   void Function() showOptions,
                                  // ) {
                                  //   return IconButton(
                                  //     onPressed: showOptions,
                                  //     icon: const Icon(
                                  //       Icons.more_vert_rounded,
                                  //     ),
                                  //   );
                                  // },
                                ),
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                // Rendering a SizedBox if it's playing
                                if (data.currentPlayingItem != null) {
                                  return const SizedBox(
                                    height: 75,
                                  );
                                }
                                return Container();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }
}
