import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/core_base_widget.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/library_toggler.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/widgets/square_album_tile.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_albums_page.dart';
import 'package:musily/features/artist/presenter/pages/artist_singles_page.dart';
import 'package:musily/features/artist/presenter/pages/artist_tracks_page.dart';
import 'package:musily/features/artist/presenter/widgets/artist_tile.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';
import 'package:musily_player/musily_entities.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArtistPage extends StatefulWidget {
  final CoreController coreController;
  final PlayerController playerController;
  final ArtistEntity artist;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const ArtistPage({
    required this.artist,
    required this.coreController,
    required this.playerController,
    super.key,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  List<TrackEntity> allTracks = [];
  List<AlbumEntity> allAlbums = [];
  List<AlbumEntity> allSingles = [];
  bool loadingTracks = false;

  Future<void> loadTracks() async {
    if (widget.playerController.data.playingId == widget.artist.id) {
      allTracks = [
        ...widget.playerController.data.queue
            .map(
              (track) => TrackModel.fromMusilyTrack(track),
            )
            .where(
              (e) => e.artist.id == widget.artist.id,
            ),
      ];
      return;
    }
    setState(() {
      loadingTracks = true;
    });
    try {
      final tracks = await widget.getArtistTracksUsecase.exec(
        widget.artist.id,
      );
      setState(() {
        allTracks = tracks;
      });
    } catch (e) {
      setState(() {
        allTracks = [];
      });
    }
    setState(() {
      loadingTracks = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CoreBaseWidget(
      coreController: widget.coreController,
      child: Scaffold(
        body: Builder(builder: (context) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 450,
                          child: widget.artist.highResImg == null
                              ? const SizedBox()
                              : AppImage(
                                  widget.artist.highResImg!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).scaffoldBackgroundColor,
                                  Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(
                                        .45,
                                      ),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 370,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: InfinityMarquee(
                                child: Text(
                                  widget.artist.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    widget.playerController.builder(builder: (context, data) {
                      final isArtistPlaying =
                          data.playingId == widget.artist.id;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filledTonal(
                            onPressed: loadingTracks
                                ? null
                                : () async {
                                    if (allTracks.isEmpty) {
                                      await loadTracks();
                                    }
                                    final random = Random();
                                    final randomIndex = random.nextInt(
                                      allTracks.length,
                                    );
                                    widget.playerController.methods
                                        .playPlaylist(
                                      [
                                        ...allTracks.map(
                                          (element) =>
                                              TrackModel.toMusilyTrack(element),
                                        ),
                                      ],
                                      widget.artist.id,
                                      startFrom: randomIndex,
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
                                    widget.libraryController.methods
                                        .updateLastTimePlayed(
                                      widget.artist.id,
                                    );
                                  },
                            style: const ButtonStyle(
                              fixedSize: WidgetStatePropertyAll(
                                Size(50, 50),
                              ),
                            ),
                            icon: const Icon(
                              Icons.shuffle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          IconButton.filled(
                            onPressed: loadingTracks
                                ? null
                                : () async {
                                    if (allTracks.isEmpty) {
                                      await loadTracks();
                                    }
                                    if (isArtistPlaying) {
                                      if (data.isPlaying) {
                                        await widget.playerController.methods
                                            .pause();
                                      } else {
                                        await widget.playerController.methods
                                            .resume();
                                      }
                                    } else {
                                      await widget.playerController.methods
                                          .playPlaylist(
                                        [
                                          ...allTracks.map(
                                            (track) =>
                                                TrackModel.toMusilyTrack(track),
                                          ),
                                        ],
                                        widget.artist.id,
                                        startFrom: 0,
                                      );
                                      widget.libraryController.methods
                                          .updateLastTimePlayed(
                                        widget.artist.id,
                                      );
                                    }
                                  },
                            style: const ButtonStyle(
                              iconSize: WidgetStatePropertyAll(40),
                              fixedSize: WidgetStatePropertyAll(
                                Size(60, 60),
                              ),
                            ),
                            icon: loadingTracks
                                ? CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  )
                                : Icon(
                                    isArtistPlaying && data.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
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
                              Icons.share_rounded,
                            ),
                          ),
                        ],
                      );
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                          ),
                          child: LibraryToggler(
                            libraryController: widget.libraryController,
                            loadingWidget: (context) {
                              return FilledButton.tonal(
                                onPressed: null,
                                child: LoadingAnimationWidget.halfTriangleDot(
                                  color: Theme.of(context).iconTheme.color ??
                                      Colors.white,
                                  size: 16,
                                ),
                              );
                            },
                            notInLibraryWidget: (context, addToLibrary) {
                              return FilledButton.tonal(
                                onPressed: addToLibrary,
                                child: Text(
                                  AppLocalizations.of(context)!.follow,
                                ),
                              );
                            },
                            inLibraryWidget: (context, removeFromLibrary) {
                              return FilledButton.tonalIcon(
                                onPressed: removeFromLibrary,
                                label: Text(
                                  AppLocalizations.of(context)!.following,
                                ),
                                icon: const Icon(
                                  Icons.check_rounded,
                                ),
                              );
                            },
                            item: widget.artist,
                          ),
                        ),
                      ],
                    ),
                    if (widget.artist.topTracks.isNotEmpty) ...[
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              bottom: 16,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.topSongs,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 16,
                              bottom: 16,
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  DownupRouter(
                                    builder: (context) => ArtistTracksPage(
                                      tracks: allTracks,
                                      artist: widget.artist,
                                      getArtistSinglesUsecase:
                                          widget.getArtistSinglesUsecase,
                                      getArtistUsecase: widget.getArtistUsecase,
                                      getArtistAlbumsUsecase:
                                          widget.getArtistAlbumsUsecase,
                                      getArtistTracksUsecase:
                                          widget.getArtistTracksUsecase,
                                      coreController: widget.coreController,
                                      playerController: widget.playerController,
                                      getPlayableItemUsecase:
                                          widget.getPlayableItemUsecase,
                                      libraryController:
                                          widget.libraryController,
                                      downloaderController:
                                          widget.downloaderController,
                                      getAlbumUsecase: widget.getAlbumUsecase,
                                      onLoadedTracks: (tracks) {
                                        setState(() {
                                          allTracks = tracks;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Text(AppLocalizations.of(context)!.more),
                            ),
                          ),
                        ],
                      ),
                      ...widget.artist.topTracks.map(
                        (track) => TrackTile(
                          getAlbumUsecase: widget.getAlbumUsecase,
                          track: track,
                          coreController: widget.coreController,
                          playerController: widget.playerController,
                          downloaderController: widget.downloaderController,
                          getPlayableItemUsecase: widget.getPlayableItemUsecase,
                          libraryController: widget.libraryController,
                          getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                          getArtistSinglesUsecase:
                              widget.getArtistSinglesUsecase,
                          getArtistTracksUsecase: widget.getArtistTracksUsecase,
                          getArtistUsecase: widget.getArtistUsecase,
                          customAction: () async {
                            if (allTracks.isEmpty) {
                              await loadTracks();
                            }

                            late final List<MusilyTrack> queueToPlay;
                            if (widget.playerController.data.playingId ==
                                widget.artist.id) {
                              queueToPlay = widget.playerController.data.queue;
                            } else {
                              queueToPlay = [
                                ...allTracks.map((element) =>
                                    TrackModel.toMusilyTrack(element))
                              ];
                            }

                            final startIndex = queueToPlay.indexWhere(
                              (element) => element.hash == track.hash,
                            );

                            widget.playerController.methods.playPlaylist(
                              queueToPlay,
                              widget.artist.id,
                              startFrom: startIndex == -1 ? 0 : startIndex,
                            );
                            widget.libraryController.methods
                                .updateLastTimePlayed(
                              widget.artist.id,
                            );
                          },
                        ),
                      ),
                    ],
                    if (widget.artist.topAlbums.isNotEmpty) ...[
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              bottom: 16,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.topAlbums,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 16,
                              bottom: 16,
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  DownupRouter(
                                    builder: (context) => ArtistAlbumsPage(
                                      albums: allAlbums,
                                      artist: widget.artist,
                                      getArtistAlbumsUsecase:
                                          widget.getArtistAlbumsUsecase,
                                      getArtistTracksUsecase:
                                          widget.getArtistTracksUsecase,
                                      coreController: widget.coreController,
                                      playerController: widget.playerController,
                                      getPlayableItemUsecase:
                                          widget.getPlayableItemUsecase,
                                      libraryController:
                                          widget.libraryController,
                                      downloaderController:
                                          widget.downloaderController,
                                      getAlbumUsecase: widget.getAlbumUsecase,
                                      getArtistSinglesUsecase:
                                          widget.getArtistSinglesUsecase,
                                      getArtistUsecase: widget.getArtistUsecase,
                                      onLoadedAlbums: (albums) {
                                        allAlbums = albums;
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Text(AppLocalizations.of(context)!.more),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 275,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...widget.artist.topAlbums.map(
                              (album) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: SquareAlbumTile(
                                  album: album,
                                  coreController: widget.coreController,
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (widget.artist.topSingles.isNotEmpty) ...[
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              bottom: 16,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.topSingles,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 16,
                              bottom: 16,
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  DownupRouter(
                                    builder: (context) => ArtistSinglesPage(
                                      singles: allSingles,
                                      artist: widget.artist,
                                      getArtistSinglesUsecase:
                                          widget.getArtistSinglesUsecase,
                                      getArtistTracksUsecase:
                                          widget.getArtistTracksUsecase,
                                      coreController: widget.coreController,
                                      playerController: widget.playerController,
                                      getPlayableItemUsecase:
                                          widget.getPlayableItemUsecase,
                                      libraryController:
                                          widget.libraryController,
                                      downloaderController:
                                          widget.downloaderController,
                                      getAlbumUsecase: widget.getAlbumUsecase,
                                      getArtistAlbumsUsecase:
                                          widget.getArtistAlbumsUsecase,
                                      getArtistUsecase: widget.getArtistUsecase,
                                      onLoadedSingles: (singles) {
                                        setState(() {
                                          allSingles = singles;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Text(AppLocalizations.of(context)!.more),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 275,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...widget.artist.topSingles.map(
                              (album) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: SquareAlbumTile(
                                  album: album,
                                  coreController: widget.coreController,
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (widget.artist.similarArtists.isNotEmpty) ...[
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              bottom: 16,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.similarArtists,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ...widget.artist.similarArtists.map(
                            (similarArtist) => ArtistTile(
                              getArtistAlbumsUsecase:
                                  widget.getArtistAlbumsUsecase,
                              getArtistTracksUsecase:
                                  widget.getArtistTracksUsecase,
                              artist: similarArtist,
                              getArtistUsecase: widget.getArtistUsecase,
                              getAlbumUsecase: widget.getAlbumUsecase,
                              coreController: widget.coreController,
                              downloaderController: widget.downloaderController,
                              getPlayableItemUsecase:
                                  widget.getPlayableItemUsecase,
                              libraryController: widget.libraryController,
                              playerController: widget.playerController,
                              getArtistSinglesUsecase:
                                  widget.getArtistSinglesUsecase,
                            ),
                          ),
                        ],
                      ),
                    ],
                    widget.playerController.builder(
                      builder: (context, data) {
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
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class AsyncArtistPage extends StatefulWidget {
  final String artistId;
  final CoreController coreController;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final GetArtistUsecase getArtistUsecase;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const AsyncArtistPage({
    super.key,
    required this.artistId,
    required this.coreController,
    required this.playerController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  State<AsyncArtistPage> createState() => _AsyncArtistPageState();
}

class _AsyncArtistPageState extends State<AsyncArtistPage> {
  bool loadingArtist = true;
  ArtistEntity? artist;

  loadArtist() async {
    setState(() {
      loadingArtist = true;
    });
    try {
      final fetchedArtist = await widget.getArtistUsecase.exec(
        widget.artistId,
      );
      setState(() {
        artist = fetchedArtist;
      });
    } catch (e) {
      setState(() {
        artist = null;
      });
    }
    setState(() {
      loadingArtist = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadArtist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: artist == null ? AppBar() : null,
      body: Builder(
        builder: (context) {
          if (loadingArtist) {
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
          if (artist == null) {
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
                    Text(AppLocalizations.of(context)!.artistNotFound),
                  ],
                ),
              ),
            );
          }
          return ArtistPage(
            artist: artist!,
            coreController: widget.coreController,
            playerController: widget.playerController,
            downloaderController: widget.downloaderController,
            getPlayableItemUsecase: widget.getPlayableItemUsecase,
            libraryController: widget.libraryController,
            getAlbumUsecase: widget.getAlbumUsecase,
            getArtistUsecase: widget.getArtistUsecase,
            getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
            getArtistTracksUsecase: widget.getArtistTracksUsecase,
            getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
          );
        },
      ),
    );
  }
}
