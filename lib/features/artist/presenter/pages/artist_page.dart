import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_icon_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_tonal_icon_button.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
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
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

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
  final bool isAsync;

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
    this.isAsync = false,
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
        ...widget.playerController.data.queue.where(
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
    return LyPage(
      ignoreFromStack: widget.isAsync,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor:
              context.themeData.scaffoldBackgroundColor.withOpacity(
            .002,
          ),
        ),
        body: Builder(
          builder: (context) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 450,
                      width: context.display.width,
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
                              context.themeData.scaffoldBackgroundColor,
                              context.themeData.scaffoldBackgroundColor
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
                              style: context.themeData.textTheme.displayMedium
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
                  final isArtistPlaying = data.playingId == widget.artist.id;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LyTonalIconButton(
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
                                widget.playerController.methods.playPlaylist(
                                  allTracks,
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
                        fixedSize: const Size(55, 55),
                        icon: const Icon(
                          Icons.shuffle,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      LyFilledIconButton(
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
                                    allTracks,
                                    widget.artist.id,
                                    startFrom: 0,
                                  );
                                  widget.libraryController.methods
                                      .updateLastTimePlayed(
                                    widget.artist.id,
                                  );
                                }
                              },
                        fixedSize: const Size(60, 60),
                        iconSize: 40,
                        icon: loadingTracks
                            ? CircularProgressIndicator(
                                color: context.themeData.colorScheme.onPrimary,
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
                      LyTonalIconButton(
                        onPressed: () {},
                        fixedSize: const Size(55, 55),
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
                      child: widget.libraryController.builder(
                        builder: (context, data) => LibraryToggler(
                          libraryController: widget.libraryController,
                          notInLibraryWidget: (context, addToLibrary) {
                            return LyTonalIconButton(
                              onPressed: addToLibrary,
                              iconSpacing: 0,
                              density: LyDensity.normal,
                              icon: const SizedBox.shrink(),
                              label: Text(
                                context.localization.follow,
                              ),
                            );
                          },
                          inLibraryWidget: (context, removeFromLibrary) {
                            return LyTonalIconButton(
                              onPressed: removeFromLibrary,
                              density: LyDensity.normal,
                              label: Text(
                                context.localization.following,
                              ),
                              icon: const Icon(
                                Icons.check_rounded,
                              ),
                            );
                          },
                          item: widget.libraryController.data.items
                                  .where(
                                      (e) => e.artist?.id == widget.artist.id)
                                  .firstOrNull ??
                              LibraryItemEntity(
                                id: '',
                                synced: false,
                                lastTimePlayed: DateTime.now(),
                                createdAt: DateTime.now(),
                                artist: widget.artist,
                              ),
                        ),
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
                          context.localization.topSongs,
                          style: context.themeData.textTheme.headlineSmall
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
                        child: LyOutlinedButton(
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
                                  libraryController: widget.libraryController,
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
                          child: Text(context.localization.more),
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
                      getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                      getArtistTracksUsecase: widget.getArtistTracksUsecase,
                      getArtistUsecase: widget.getArtistUsecase,
                      customAction: () async {
                        if (allTracks.isEmpty) {
                          await loadTracks();
                        }

                        late final List<TrackEntity> queueToPlay;
                        if (widget.playerController.data.playingId ==
                            widget.artist.id) {
                          queueToPlay = widget.playerController.data.queue;
                        } else {
                          queueToPlay = allTracks;
                        }

                        final startIndex = queueToPlay.indexWhere(
                          (element) => element.hash == track.hash,
                        );

                        widget.playerController.methods.playPlaylist(
                          queueToPlay,
                          widget.artist.id,
                          startFrom: startIndex == -1 ? 0 : startIndex,
                        );
                        widget.libraryController.methods.updateLastTimePlayed(
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
                          context.localization.topAlbums,
                          style: context.themeData.textTheme.headlineSmall
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
                        child: LyOutlinedButton(
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
                                  libraryController: widget.libraryController,
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
                          child: Text(context.localization.more),
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
                          context.localization.topSingles,
                          style: context.themeData.textTheme.headlineSmall
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
                        child: LyOutlinedButton(
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
                                  libraryController: widget.libraryController,
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
                          child: Text(context.localization.more),
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
                          context.localization.similarArtists,
                          style: context.themeData.textTheme.headlineSmall
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
                          contentOrigin: ContentOrigin.dataFetch,
                          getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                          getArtistTracksUsecase: widget.getArtistTracksUsecase,
                          artist: similarArtist,
                          getArtistUsecase: widget.getArtistUsecase,
                          getAlbumUsecase: widget.getAlbumUsecase,
                          coreController: widget.coreController,
                          downloaderController: widget.downloaderController,
                          getPlayableItemUsecase: widget.getPlayableItemUsecase,
                          libraryController: widget.libraryController,
                          playerController: widget.playerController,
                          getArtistSinglesUsecase:
                              widget.getArtistSinglesUsecase,
                        ),
                      ),
                    ],
                  ),
                ],
                PlayerSizedBox(
                  playerController: widget.playerController,
                ),
              ],
            );
          },
        ),
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
    return LyPage(
      child: Scaffold(
        appBar: artist == null ? AppBar() : null,
        body: Builder(
          builder: (context) {
            if (loadingArtist) {
              return Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: context.themeData.colorScheme.primary,
                  size: 50,
                ),
              );
            }
            if (artist == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_rounded,
                      size: 50,
                      color: context.themeData.iconTheme.color?.withOpacity(.7),
                    ),
                    Text(context.localization.artistNotFound),
                  ],
                ),
              );
            }
            return ArtistPage(
              artist: artist!,
              isAsync: true,
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
      ),
    );
  }
}
