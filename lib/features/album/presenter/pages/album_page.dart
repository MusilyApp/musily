import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_icon_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_tonal_icon_button.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/core/presenter/widgets/musily_loading.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/library_toggler.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/widgets/album_options_widget.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:musily/features/track/presenter/widgets/track_searcher.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class AlbumPage extends StatefulWidget {
  final CoreController coreController;
  final PlayerController playerController;
  final AlbumEntity album;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;
  final bool isAsync;

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
    required this.getTrackUsecase,
    this.isAsync = false,
    required this.getPlaylistUsecase,
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
        return LyPage(
          contextKey: 'AlbumPage_${widget.album.id}',
          ignoreFromStack: widget.isAsync,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: MusilyAppBar(
              backgroundColor:
                  context.themeData.scaffoldBackgroundColor.withValues(
                alpha: .002,
              ),
              actions: [
                widget.playerController.builder(
                  builder: (context, data) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: TrackSearcher(
                        getTrackUsecase: widget.getTrackUsecase,
                        tracks: widget.album.tracks,
                        getPlaylistUsecase: widget.getPlaylistUsecase,
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
                          late final List<TrackEntity> queueToPlay;
                          if (data.playingId == widget.album.id) {
                            queueToPlay = data.queue;
                          } else {
                            queueToPlay = widget.album.tracks;
                          }

                          final startIndex = queueToPlay.indexWhere(
                            (element) => element.hash == track.hash,
                          );

                          widget.playerController.methods.playPlaylist(
                            queueToPlay,
                            widget.album.id,
                            startFromTrackId: startIndex == -1
                                ? queueToPlay[0].id
                                : queueToPlay[startIndex].id,
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
            body: Builder(
              builder: (context) {
                return widget.playerController.builder(
                  builder: (context, data) {
                    final isAlbumPlaying = data.playingId == widget.album.id;
                    return ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 150),
                      children: [
                        // Album Banner Section
                        Stack(
                          children: [
                            if (widget.album.highResImg != null &&
                                widget.album.highResImg!.isNotEmpty) ...[
                              SizedBox(
                                height: 380,
                                width: context.display.width,
                                child: AppImage(
                                  widget.album.highResImg!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Multi-layer Gradient Overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: context.themeData.brightness ==
                                              Brightness.dark
                                          ? [
                                              context.themeData
                                                  .scaffoldBackgroundColor,
                                              context.themeData
                                                  .scaffoldBackgroundColor
                                                  .withValues(alpha: .9),
                                              context.themeData
                                                  .scaffoldBackgroundColor
                                                  .withValues(alpha: .5),
                                              context.themeData
                                                  .scaffoldBackgroundColor
                                                  .withValues(alpha: .1),
                                            ]
                                          : [
                                              context.themeData
                                                  .scaffoldBackgroundColor,
                                              context.themeData
                                                  .scaffoldBackgroundColor
                                                  .withValues(alpha: .9),
                                              context.themeData
                                                  .scaffoldBackgroundColor
                                                  .withValues(alpha: .5),
                                              context.themeData
                                                  .scaffoldBackgroundColor
                                                  .withValues(alpha: .1),
                                            ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              SizedBox(
                                height: 380,
                                width: context.display.width,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        context.themeData.colorScheme.primary
                                            .withValues(alpha: 0.3),
                                        context.themeData.colorScheme.secondary
                                            .withValues(alpha: 0.2),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            // Album Title and Info
                            Positioned(
                              bottom: 80,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.album.title,
                                        textAlign: TextAlign.center,
                                        style: context
                                            .themeData.textTheme.displayLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 48,
                                          letterSpacing: -2,
                                          height: 1.1,
                                          shadows: [
                                            Shadow(
                                              color: context.themeData
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.black
                                                      .withValues(alpha: 0.6)
                                                  : Colors.white
                                                      .withValues(alpha: 0.9),
                                              offset: const Offset(0, 2),
                                              blurRadius: 8,
                                            ),
                                            Shadow(
                                              color: context.themeData
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.black
                                                      .withValues(alpha: 0.4)
                                                  : Colors.white
                                                      .withValues(alpha: 0.7),
                                              offset: const Offset(0, 4),
                                              blurRadius: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${widget.album.year} • ${widget.album.artist.name}',
                                        textAlign: TextAlign.center,
                                        style: context
                                            .themeData.textTheme.bodyLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          shadows: [
                                            Shadow(
                                              color: context.themeData
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.black
                                                      .withValues(alpha: 0.4)
                                                  : Colors.white
                                                      .withValues(alpha: 0.7),
                                              offset: const Offset(0, 2),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              widget.downloaderController.builder(
                                builder: (context, data) {
                                  final isAlbumDownloading = data.queue
                                          .where(
                                            (e) =>
                                                e.status ==
                                                e.downloadDownloading,
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
                                          .where((e) =>
                                              e.status == e.downloadCompleted)
                                          .length ==
                                      widget.album.tracks.length;
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: context.themeData.brightness ==
                                                  Brightness.dark
                                              ? context
                                                  .themeData.colorScheme.primary
                                                  .withValues(alpha: 0.2)
                                              : context
                                                  .themeData.colorScheme.primary
                                                  .withValues(alpha: 0.15),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: LyTonalIconButton(
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
                                      fixedSize: const Size(58, 58),
                                      icon: Icon(
                                        isAlbumDownloading
                                            ? LucideIcons.x
                                            : isDone
                                                ? LucideIcons.circleCheckBig
                                                : LucideIcons.download,
                                        size: 22,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              widget.libraryController.builder(
                                builder: (context, data) => LibraryToggler(
                                  item: data.items
                                          .where((e) =>
                                              e.album?.id == widget.album.id)
                                          .firstOrNull ??
                                      LibraryItemEntity(
                                        id: '',
                                        synced: false,
                                        lastTimePlayed: DateTime.now(),
                                        createdAt: DateTime.now(),
                                        album: widget.album,
                                      ),
                                  libraryController: widget.libraryController,
                                  notInLibraryWidget: (context, addToLibrary) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: context
                                                        .themeData.brightness ==
                                                    Brightness.dark
                                                ? context.themeData.colorScheme
                                                    .primary
                                                    .withValues(alpha: 0.2)
                                                : context.themeData.colorScheme
                                                    .primary
                                                    .withValues(alpha: 0.15),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: LyTonalIconButton(
                                        onPressed: addToLibrary,
                                        onFocus: () {
                                          scrollToTop();
                                        },
                                        fixedSize: const Size(58, 58),
                                        icon: Icon(
                                          LucideIcons.circlePlus,
                                          size: 22,
                                        ),
                                      ),
                                    );
                                  },
                                  inLibraryWidget:
                                      (context, removeFromLibrary) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: context
                                                        .themeData.brightness ==
                                                    Brightness.dark
                                                ? context.themeData.colorScheme
                                                    .primary
                                                    .withValues(alpha: 0.2)
                                                : context.themeData.colorScheme
                                                    .primary
                                                    .withValues(alpha: 0.15),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: LyTonalIconButton(
                                        onPressed: removeFromLibrary,
                                        onFocus: () {
                                          scrollToTop();
                                        },
                                        fixedSize: const Size(58, 58),
                                        icon: Icon(
                                          LucideIcons.check,
                                          size: 22,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.themeData.brightness ==
                                              Brightness.dark
                                          ? context
                                              .themeData.colorScheme.primary
                                              .withValues(alpha: 0.4)
                                          : context
                                              .themeData.colorScheme.primary
                                              .withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                      spreadRadius: 0,
                                    ),
                                    BoxShadow(
                                      color: context.themeData.brightness ==
                                              Brightness.dark
                                          ? context
                                              .themeData.colorScheme.primary
                                              .withValues(alpha: 0.2)
                                          : context
                                              .themeData.colorScheme.primary
                                              .withValues(alpha: 0.15),
                                      blurRadius: 40,
                                      offset: const Offset(0, 12),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: LyFilledIconButton(
                                  onPressed: () async {
                                    if (isAlbumPlaying) {
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
                                        widget.album.tracks,
                                        widget.album.id,
                                        startFromTrackId:
                                            widget.album.tracks[0].id,
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
                                  iconSize: 32,
                                  fixedSize: const Size(70, 70),
                                  icon: Icon(
                                    isAlbumPlaying && data.isPlaying
                                        ? LucideIcons.pause
                                        : LucideIcons.play,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.themeData.brightness ==
                                              Brightness.dark
                                          ? context
                                              .themeData.colorScheme.primary
                                              .withValues(alpha: 0.2)
                                          : context
                                              .themeData.colorScheme.primary
                                              .withValues(alpha: 0.15),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: LyTonalIconButton(
                                  onFocus: () {
                                    scrollToTop();
                                  },
                                  onPressed: () async {
                                    final random = Random();
                                    final randomIndex = random.nextInt(
                                      widget.album.tracks.length,
                                    );
                                    widget.playerController.methods
                                        .playPlaylist(
                                      widget.album.tracks,
                                      widget.album.id,
                                      startFromTrackId:
                                          widget.album.tracks[randomIndex].id,
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
                                      widget.album.id,
                                    );
                                  },
                                  fixedSize: const Size(58, 58),
                                  icon: const Icon(
                                    LucideIcons.shuffle,
                                    size: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              AlbumOptions(
                                album: widget.album,
                                coreController: widget.coreController,
                                playerController: widget.playerController,
                                getAlbumUsecase: widget.getAlbumUsecase,
                                downloaderController:
                                    widget.downloaderController,
                                getPlaylistUsecase: widget.getPlaylistUsecase,
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
                                getTrackUsecase: widget.getTrackUsecase,
                                onFocus: scrollToTop,
                                tonal: true,
                              ),
                            ],
                          ),
                        ),
                        // Tracks Section Header
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: context.themeData.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                context.localization.songs,
                                style: context.themeData.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...widget.album.tracks.map(
                          (track) => TrackTile(
                            getTrackUsecase: widget.getTrackUsecase,
                            getPlaylistUsecase: widget.getPlaylistUsecase,
                            getAlbumUsecase: widget.getAlbumUsecase,
                            leading: isAlbumPlaying &&
                                    data.currentPlayingItem?.hash ==
                                        track.hash &&
                                    data.isPlaying
                                ? MusilyWaveLoading(
                                    color:
                                        context.themeData.colorScheme.primary,
                                    size: 20,
                                  )
                                : SizedBox(
                                    width: 20,
                                    child: Center(
                                      child: Text(
                                        '${widget.album.tracks.indexOf(track) + 1}',
                                        style: context
                                            .themeData.textTheme.bodyLarge
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
                            getArtistAlbumsUsecase:
                                widget.getArtistAlbumsUsecase,
                            getArtistSinglesUsecase:
                                widget.getArtistSinglesUsecase,
                            getArtistTracksUsecase:
                                widget.getArtistTracksUsecase,
                            getArtistUsecase: widget.getArtistUsecase,
                            getPlayableItemUsecase:
                                widget.getPlayableItemUsecase,
                            libraryController: widget.libraryController,
                            customAction: () {
                              late final List<TrackEntity> queueToPlay;
                              if (data.playingId == widget.album.id) {
                                queueToPlay = data.queue;
                              } else {
                                queueToPlay = widget.album.tracks;
                              }

                              final startIndex = queueToPlay.indexWhere(
                                (element) => element.hash == track.hash,
                              );

                              widget.playerController.methods.playPlaylist(
                                queueToPlay,
                                widget.album.id,
                                startFromTrackId: startIndex == -1
                                    ? queueToPlay[0].id
                                    : queueToPlay[startIndex].id,
                              );
                              widget.libraryController.methods
                                  .updateLastTimePlayed(
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
  final GetPlaylistUsecase getPlaylistUsecase;
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
  final GetTrackUsecase getTrackUsecase;

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
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
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
    return LyPage(
      contextKey: 'AsyncAlbumPage_${widget.albumId}',
      child: Scaffold(
        appBar: album == null ? const MusilyAppBar() : null,
        body: widget.libraryController.builder(
          builder: (context, data) {
            if (loadingAlbum || data.loading) {
              return Center(
                child: MusilyDotsLoading(
                  color: context.themeData.colorScheme.primary,
                  size: 50,
                ),
              );
            }
            if (album == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.info,
                      size: 50,
                      color: context.themeData.iconTheme.color
                          ?.withValues(alpha: .7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.localization.albumNotFound,
                    )
                  ],
                ),
              );
            }
            return AlbumPage(
              isAsync: true,
              getTrackUsecase: widget.getTrackUsecase,
              coreController: widget.coreController,
              getPlaylistUsecase: widget.getPlaylistUsecase,
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
      ),
    );
  }
}
