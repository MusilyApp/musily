import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_icon_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_tonal_icon_button.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/core_base_widget.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/library_toggler.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/widgets/album_options_widget.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/track/presenter/widgets/track_searcher.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';
import 'package:musily_player/musily_entities.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlbumPage extends StatefulWidget {
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
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final ScrollController scrollController = ScrollController();

  void scrollToTop() {
    if (scrollController.offset > 0) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.coreController.builder(
      builder: (context, data) {
        return CoreBaseWidget(
          coreController: widget.coreController,
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.album.artist.name),
              actions: [
                widget.playerController.builder(
                  builder: (context, data) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: TrackSearcher(
                        tracks: widget.album.tracks,
                        coreController: widget.coreController,
                        playerController: widget.playerController,
                        getPlayableItemUsecase: widget.getPlayableItemUsecase,
                        libraryController: widget.libraryController,
                        downloaderController: widget.downloaderController,
                        getAlbumUsecase: widget.getAlbumUsecase,
                        getArtistUsecase: widget.getArtistUsecase,
                        getArtistTracksUsecase: widget.getArtistTracksUsecase,
                        getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                        getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                        clickAction: (track, controller) {
                          late final List<MusilyTrack> queueToPlay;
                          if (data.playingId == widget.album.id) {
                            queueToPlay = data.queue;
                          } else {
                            queueToPlay = [
                              ...widget.album.tracks.map((element) =>
                                  TrackModel.toMusilyTrack(element))
                            ];
                          }

                          final startIndex = queueToPlay.indexWhere(
                            (element) => element.hash == track.hash,
                          );

                          widget.playerController.methods.playPlaylist(
                            queueToPlay,
                            widget.album.id,
                            startFrom: startIndex == -1 ? 0 : startIndex,
                          );
                          widget.libraryController.methods.updateLastTimePlayed(
                            widget.album.id,
                          );
                          controller.closeView(controller.text);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            body: widget.playerController.builder(
              builder: (context, data) {
                final isAlbumPlaying = data.playingId == widget.album.id;
                return ListView(
                  controller: scrollController,
                  children: [
                    if (widget.album.highResImg != null &&
                        widget.album.highResImg!.isNotEmpty) ...[
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
                                widget.album.highResImg!,
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
                              widget.album.title,
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
                            widget.album.year.toString(),
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
                        widget.downloaderController.builder(
                          builder: (context, data) {
                            final isAlbumDownloading = data.queue
                                    .where(
                                      (e) => e.status == e.downloadDownloading,
                                    )
                                    .isNotEmpty &&
                                data.downloadingKey == widget.album.id;
                            final isDone = data.queue
                                    .where(
                                      (e) => widget.album.tracks
                                          .where((item) =>
                                              item.hash == e.track.hash)
                                          .isNotEmpty,
                                    )
                                    .where(
                                        (e) => e.status == e.downloadCompleted)
                                    .length ==
                                widget.album.tracks.length;
                            return LyTonalIconButton(
                              onFocus: () {
                                scrollToTop();
                              },
                              onPressed: () {
                                if (isDone) {
                                  return;
                                }
                                if (isAlbumDownloading) {
                                  widget.libraryController.methods
                                      .cancelCollectionDownload(
                                    widget.album.tracks,
                                    widget.album.id,
                                  );
                                } else {
                                  widget.libraryController.methods
                                      .downloadCollection(
                                    widget.album.tracks,
                                    widget.album.id,
                                  );
                                }
                              },
                              fixedSize: const Size(55, 55),
                              icon: Icon(
                                isAlbumDownloading
                                    ? Icons.close
                                    : isDone
                                        ? Icons.download_done_rounded
                                        : Icons.download_rounded,
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        LibraryToggler(
                          item: widget.album,
                          libraryController: widget.libraryController,
                          notInLibraryWidget: (context, addToLibrary) {
                            return LyTonalIconButton(
                              onPressed: addToLibrary,
                              onFocus: () {
                                scrollToTop();
                              },
                              fixedSize: const Size(55, 55),
                              icon: const Icon(
                                Icons.library_add,
                              ),
                            );
                          },
                          inLibraryWidget: (context, removeFromLibrary) {
                            return LyTonalIconButton(
                              onPressed: removeFromLibrary,
                              onFocus: () {
                                scrollToTop();
                              },
                              fixedSize: const Size(55, 55),
                              icon: const Icon(
                                Icons.library_add_check_rounded,
                              ),
                            );
                          },
                          loadingWidget: (context) {
                            return LyTonalIconButton(
                              onPressed: null,
                              onFocus: () {
                                scrollToTop();
                              },
                              fixedSize: const Size(55, 55),
                              icon: const CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        LyFilledIconButton(
                          onPressed: () async {
                            if (isAlbumPlaying) {
                              if (data.isPlaying) {
                                await widget.playerController.methods.pause();
                              } else {
                                await widget.playerController.methods.resume();
                              }
                            } else {
                              await widget.playerController.methods
                                  .playPlaylist(
                                [
                                  ...widget.album.tracks.map(
                                    (track) => TrackModel.toMusilyTrack(track),
                                  ),
                                ],
                                widget.album.id,
                                startFrom: 0,
                              );
                              widget.libraryController.methods
                                  .updateLastTimePlayed(
                                widget.album.id,
                              );
                            }
                          },
                          onFocus: () {
                            scrollToTop();
                          },
                          iconSize: 40,
                          fixedSize: const Size(60, 60),
                          icon: Icon(
                            isAlbumPlaying && data.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        LyTonalIconButton(
                          onFocus: () {
                            scrollToTop();
                          },
                          onPressed: () async {
                            final random = Random();
                            final randomIndex = random.nextInt(
                              widget.album.tracks.length,
                            );
                            widget.playerController.methods.playPlaylist(
                              [
                                ...widget.album.tracks.map(
                                  (element) =>
                                      TrackModel.toMusilyTrack(element),
                                ),
                              ],
                              widget.album.id,
                              startFrom: randomIndex,
                            );
                            if (!data.shuffleEnabled) {
                              widget.playerController.methods.toggleShuffle();
                            } else {
                              await widget.playerController.methods
                                  .toggleShuffle();
                              widget.playerController.methods.toggleShuffle();
                            }
                            widget.libraryController.methods
                                .updateLastTimePlayed(
                              widget.album.id,
                            );
                          },
                          fixedSize: const Size(55, 55),
                          icon: const Icon(
                            Icons.shuffle_rounded,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        AlbumOptions(
                          album: widget.album,
                          coreController: widget.coreController,
                          playerController: widget.playerController,
                          getAlbumUsecase: widget.getAlbumUsecase,
                          downloaderController: widget.downloaderController,
                          getPlayableItemUsecase: widget.getPlayableItemUsecase,
                          libraryController: widget.libraryController,
                          getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                          getArtistSinglesUsecase:
                              widget.getArtistSinglesUsecase,
                          getArtistTracksUsecase: widget.getArtistTracksUsecase,
                          getArtistUsecase: widget.getArtistUsecase,
                          onFocus: scrollToTop,
                          tonal: true,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ...widget.album.tracks.map(
                      (track) => TrackTile(
                        getAlbumUsecase: widget.getAlbumUsecase,
                        leading: isAlbumPlaying &&
                                data.currentPlayingItem?.hash == track.hash &&
                                data.isPlaying
                            ? LoadingAnimationWidget.staggeredDotsWave(
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              )
                            : SizedBox(
                                width: 20,
                                child: Center(
                                  child: Text(
                                    '${widget.album.tracks.indexOf(track) + 1}',
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
                        downloaderController: widget.downloaderController,
                        getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                        getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                        getArtistTracksUsecase: widget.getArtistTracksUsecase,
                        getArtistUsecase: widget.getArtistUsecase,
                        getPlayableItemUsecase: widget.getPlayableItemUsecase,
                        libraryController: widget.libraryController,
                        customAction: () {
                          late final List<MusilyTrack> queueToPlay;
                          if (data.playingId == widget.album.id) {
                            queueToPlay = data.queue;
                          } else {
                            queueToPlay = [
                              ...widget.album.tracks.map((element) =>
                                  TrackModel.toMusilyTrack(element))
                            ];
                          }

                          final startIndex = queueToPlay.indexWhere(
                            (element) => element.hash == track.hash,
                          );

                          widget.playerController.methods.playPlaylist(
                            queueToPlay,
                            widget.album.id,
                            startFrom: startIndex == -1 ? 0 : startIndex,
                          );
                          widget.libraryController.methods.updateLastTimePlayed(
                            widget.album.id,
                          );
                        },
                        track: track,
                        coreController: widget.coreController,
                        playerController: widget.playerController,
                      ),
                    ),
                    PlayerSizedBox(
                      playerController: widget.playerController,
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
