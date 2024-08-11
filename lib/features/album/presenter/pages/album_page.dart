import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/core_base_widget.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/library_toggler.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/widgets/album_options_widget.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';
import 'package:musily_player/musily_entities.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlbumPage extends StatelessWidget {
  final CoreController coreController;
  final PlayerController playerController;
  final AlbumEntity album;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const AlbumPage({
    super.key,
    required this.coreController,
    required this.album,
    required this.playerController,
    required this.getAlbumUsecase,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return coreController.builder(
      builder: (context, data) {
        return CoreBaseWidget(
          coreController: coreController,
          child: Scaffold(
            appBar: AppBar(
              title: Text(album.artist.name),
            ),
            body: playerController.builder(
              builder: (context, data) {
                final isAlbumPlaying = data.playingId == album.id;
                return ListView(
                  children: [
                    if (album.highResImg != null &&
                        album.highResImg!.isNotEmpty) ...[
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: AppImage(
                                album.highResImg!,
                                width: 250,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 26,
                          ),
                          child: SizedBox(
                            width: 200,
                            child: Text(
                              album.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 16,
                          ),
                          child: Text(
                            album.year.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        downloaderController.builder(
                          builder: (context, data) {
                            final isAlbumDownloading = data.queue.isNotEmpty &&
                                data.downloadingKey == album.id;
                            return IconButton.filledTonal(
                              onPressed: () {
                                if (isAlbumDownloading) {
                                  libraryController.methods
                                      .cancelCollectionDownload(
                                    album.tracks,
                                    album.id,
                                  );
                                } else {
                                  libraryController.methods.downloadCollection(
                                    album.tracks,
                                    album.id,
                                  );
                                }
                              },
                              style: const ButtonStyle(
                                fixedSize: WidgetStatePropertyAll(
                                  Size(50, 50),
                                ),
                              ),
                              icon: Icon(
                                isAlbumDownloading
                                    ? Icons.close
                                    : Icons.download_rounded,
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        LibraryToggler(
                          item: album,
                          libraryController: libraryController,
                          notInLibraryWidget: (context, addToLibrary) {
                            return IconButton.filledTonal(
                              onPressed: addToLibrary,
                              style: const ButtonStyle(
                                fixedSize: WidgetStatePropertyAll(
                                  Size(50, 50),
                                ),
                              ),
                              icon: const Icon(
                                Icons.library_add,
                              ),
                            );
                          },
                          inLibraryWidget: (context, removeFromLibrary) {
                            return IconButton.filledTonal(
                              onPressed: removeFromLibrary,
                              style: const ButtonStyle(
                                fixedSize: WidgetStatePropertyAll(
                                  Size(50, 50),
                                ),
                              ),
                              icon: const Icon(
                                Icons.library_add_check_rounded,
                              ),
                            );
                          },
                          loadingWidget: (context) {
                            return const IconButton.filledTonal(
                              onPressed: null,
                              style: ButtonStyle(
                                fixedSize: WidgetStatePropertyAll(
                                  Size(50, 50),
                                ),
                              ),
                              icon: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        IconButton.filled(
                          onPressed: () async {
                            if (isAlbumPlaying) {
                              if (data.isPlaying) {
                                await playerController.methods.pause();
                              } else {
                                await playerController.methods.resume();
                              }
                            } else {
                              await playerController.methods.playPlaylist(
                                [
                                  ...album.tracks.map(
                                    (track) => TrackModel.toMusilyTrack(track),
                                  ),
                                ],
                                album.id,
                                startFrom: 0,
                              );
                              libraryController.methods.updateLastTimePlayed(
                                album.id,
                              );
                            }
                          },
                          style: const ButtonStyle(
                            iconSize: WidgetStatePropertyAll(40),
                            fixedSize: WidgetStatePropertyAll(
                              Size(60, 60),
                            ),
                          ),
                          icon: Icon(
                            isAlbumPlaying && data.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        IconButton.filledTonal(
                          onPressed: () async {
                            final random = Random();
                            final randomIndex = random.nextInt(
                              album.tracks.length,
                            );
                            playerController.methods.playPlaylist(
                              [
                                ...album.tracks.map(
                                  (element) =>
                                      TrackModel.toMusilyTrack(element),
                                ),
                              ],
                              album.id,
                              startFrom: randomIndex,
                            );
                            if (!data.shuffleEnabled) {
                              playerController.methods.toggleShuffle();
                            } else {
                              await playerController.methods.toggleShuffle();
                              playerController.methods.toggleShuffle();
                            }
                            libraryController.methods.updateLastTimePlayed(
                              album.id,
                            );
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
                        AlbumOptionsBuilder(
                          album: album,
                          coreController: coreController,
                          playerController: playerController,
                          getAlbumUsecase: getAlbumUsecase,
                          downloaderController: downloaderController,
                          getPlayableItemUsecase: getPlayableItemUsecase,
                          libraryController: libraryController,
                          getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                          getArtistSinglesUsecase: getArtistSinglesUsecase,
                          getArtistTracksUsecase: getArtistTracksUsecase,
                          getArtistUsecase: getArtistUsecase,
                          builder: (context, showOptions) =>
                              IconButton.filledTonal(
                            onPressed: showOptions,
                            style: const ButtonStyle(
                              fixedSize: WidgetStatePropertyAll(
                                Size(50, 50),
                              ),
                            ),
                            icon: const Icon(
                              Icons.more_vert_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ...album.tracks.map(
                      (track) => TrackTile(
                        getAlbumUsecase: getAlbumUsecase,
                        leading: isAlbumPlaying &&
                                data.currentPlayingItem?.hash == track.hash
                            ? LoadingAnimationWidget.staggeredDotsWave(
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              )
                            : SizedBox(
                                width: 20,
                                child: Center(
                                  child: Text(
                                    '${album.tracks.indexOf(track) + 1}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ),
                        hideOptions: const [
                          TrackTileOptions.seeAlbum,
                        ],
                        downloaderController: downloaderController,
                        getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                        getArtistSinglesUsecase: getArtistSinglesUsecase,
                        getArtistTracksUsecase: getArtistTracksUsecase,
                        getArtistUsecase: getArtistUsecase,
                        getPlayableItemUsecase: getPlayableItemUsecase,
                        libraryController: libraryController,
                        customAction: () {
                          late final List<MusilyTrack> queueToPlay;
                          if (data.playingId == album.id) {
                            queueToPlay = data.queue;
                          } else {
                            queueToPlay = [
                              ...album.tracks.map((element) =>
                                  TrackModel.toMusilyTrack(element))
                            ];
                          }

                          final startIndex = queueToPlay.indexWhere(
                            (element) => element.hash == track.hash,
                          );

                          playerController.methods.playPlaylist(
                            queueToPlay,
                            album.id,
                            startFrom: startIndex == -1 ? 0 : startIndex,
                          );
                          libraryController.methods.updateLastTimePlayed(
                            album.id,
                          );
                        },
                        track: track,
                        coreController: coreController,
                        playerController: playerController,
                      ),
                    ),
                    if (data.currentPlayingItem != null)
                      const SizedBox(
                        height: 75,
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class AsyncAlbumPage extends StatefulWidget {
  final CoreController coreController;
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final String albumId;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final LibraryController libraryController;
  const AsyncAlbumPage({
    super.key,
    required this.albumId,
    required this.coreController,
    required this.playerController,
    required this.getAlbumUsecase,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  State<AsyncAlbumPage> createState() => _AsyncAlbumPageState();
}

class _AsyncAlbumPageState extends State<AsyncAlbumPage> {
  bool loadingAlbum = true;
  AlbumEntity? album;

  loadAlbum() async {
    setState(() {
      loadingAlbum = true;
    });
    try {
      final fetchedAlbum = await widget.getAlbumUsecase.exec(
        widget.albumId,
      );
      setState(() {
        album = fetchedAlbum;
      });
    } catch (e) {
      setState(() {
        album = null;
      });
    }
    setState(() {
      loadingAlbum = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: album == null ? AppBar() : null,
      body: Builder(
        builder: (context) {
          if (loadingAlbum) {
            return CoreBaseWidget(
              coreController: widget.coreController,
              child: Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: Theme.of(context).colorScheme.primary,
                  size: 50,
                ),
              ),
            );
          }
          if (album == null) {
            return CoreBaseWidget(
              coreController: widget.coreController,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_rounded,
                      size: 50,
                      color: Theme.of(context).iconTheme.color?.withOpacity(.7),
                    ),
                    Text(
                      AppLocalizations.of(context)!.albumNotFound,
                    )
                  ],
                ),
              ),
            );
          }
          return AlbumPage(
            coreController: widget.coreController,
            getAlbumUsecase: widget.getAlbumUsecase,
            album: album!,
            playerController: widget.playerController,
            downloaderController: widget.downloaderController,
            getPlayableItemUsecase: widget.getPlayableItemUsecase,
            getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
            getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
            getArtistTracksUsecase: widget.getArtistTracksUsecase,
            getArtistUsecase: widget.getArtistUsecase,
            libraryController: widget.libraryController,
          );
        },
      ),
    );
  }
}
