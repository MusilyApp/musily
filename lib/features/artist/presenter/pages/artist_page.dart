import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_icon_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_tonal_icon_button.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/empty_state.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/core/presenter/widgets/musily_loading.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/library_toggler.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/album/presenter/widgets/album_item.dart';
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
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
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
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;
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
    required this.getTrackUsecase,
    this.isAsync = false,
    required this.getPlaylistUsecase,
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
      final tracks = await widget.getArtistTracksUsecase.exec(widget.artist.id);
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
      contextKey: 'ArtistPage_${widget.artist.id}',
      ignoreFromStack: widget.isAsync,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MusilyAppBar(
          backgroundColor: context.themeData.scaffoldBackgroundColor.withValues(
            alpha: .002,
          ),
        ),
        body: Builder(
          builder: (context) {
            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 150),
              children: [
                Stack(
                  children: [
                    // Artist Image with Parallax Effect
                    SizedBox(
                      height: 380,
                      width: context.display.width,
                      child: widget.artist.highResImg == null
                          ? Container(
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
                            )
                          : AppImage(
                              widget.artist.highResImg!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    // Multi-layer Gradient Overlay for Depth
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: context.themeData.brightness ==
                                    Brightness.dark
                                ? [
                                    context.themeData.scaffoldBackgroundColor,
                                    context.themeData.scaffoldBackgroundColor
                                        .withValues(alpha: .9),
                                    context.themeData.scaffoldBackgroundColor
                                        .withValues(alpha: .5),
                                    context.themeData.scaffoldBackgroundColor
                                        .withValues(alpha: .1),
                                  ]
                                : [
                                    context.themeData.scaffoldBackgroundColor,
                                    context.themeData.scaffoldBackgroundColor
                                        .withValues(alpha: .9),
                                    context.themeData.scaffoldBackgroundColor
                                        .withValues(alpha: .5),
                                    context.themeData.scaffoldBackgroundColor
                                        .withValues(alpha: .1),
                                  ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            // stops: const [0.0, 0.3, 0.6, 0.9],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 32,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: InfinityMarquee(
                            child: Text(
                              widget.artist.name,
                              textAlign: TextAlign.center,
                              style: context.themeData.textTheme.displayLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 52,
                                letterSpacing: -2,
                                height: 1.1,
                                shadows: [
                                  Shadow(
                                    color: context.themeData.brightness ==
                                            Brightness.dark
                                        ? Colors.black.withValues(alpha: 0.6)
                                        : Colors.white.withValues(alpha: 0.9),
                                    offset: const Offset(0, 2),
                                    blurRadius: 8,
                                  ),
                                  Shadow(
                                    color: context.themeData.brightness ==
                                            Brightness.dark
                                        ? Colors.black.withValues(alpha: 0.4)
                                        : Colors.white.withValues(alpha: 0.7),
                                    offset: const Offset(0, 4),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 12),
                  child: widget.playerController.builder(
                    builder: (context, data) {
                      final isArtistPlaying =
                          data.playingId == widget.artist.id;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: context.themeData.brightness ==
                                          Brightness.dark
                                      ? context.themeData.colorScheme.primary
                                          .withValues(alpha: 0.2)
                                      : context.themeData.colorScheme.primary
                                          .withValues(alpha: 0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: LyTonalIconButton(
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
                                        allTracks,
                                        widget.artist.id,
                                        startFromTrackId:
                                            allTracks[randomIndex].id,
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
                                              widget.artist.id);
                                    },
                              fixedSize: const Size(58, 58),
                              icon: const Icon(LucideIcons.shuffle, size: 22),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Play/Pause Button with Enhanced Shadow
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: context.themeData.brightness ==
                                          Brightness.dark
                                      ? context.themeData.colorScheme.primary
                                          .withValues(alpha: 0.4)
                                      : context.themeData.colorScheme.primary
                                          .withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: context.themeData.brightness ==
                                          Brightness.dark
                                      ? context.themeData.colorScheme.primary
                                          .withValues(alpha: 0.2)
                                      : context.themeData.colorScheme.primary
                                          .withValues(alpha: 0.15),
                                  blurRadius: 40,
                                  offset: const Offset(0, 12),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: LyFilledIconButton(
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
                                          startFromTrackId: allTracks[0].id,
                                        );
                                        widget.libraryController.methods
                                            .updateLastTimePlayed(
                                          widget.artist.id,
                                        );
                                      }
                                    },
                              fixedSize: const Size(70, 70),
                              iconSize: 32,
                              icon: loadingTracks
                                  ? CircularProgressIndicator(
                                      color: context
                                          .themeData.colorScheme.onPrimary,
                                      strokeWidth: 3,
                                    )
                                  : Icon(
                                      isArtistPlaying && data.isPlaying
                                          ? LucideIcons.pause
                                          : LucideIcons.play,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Share Button
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: context.themeData.brightness ==
                                          Brightness.dark
                                      ? context.themeData.colorScheme.primary
                                          .withValues(alpha: 0.2)
                                      : context.themeData.colorScheme.primary
                                          .withValues(alpha: 0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: LyTonalIconButton(
                              onPressed: () {
                                widget.coreController.methods.shareArtist(
                                  widget.artist,
                                );
                              },
                              fixedSize: const Size(58, 58),
                              icon: const Icon(LucideIcons.share2, size: 22),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: widget.libraryController.builder(
                        builder: (context, data) => LibraryToggler(
                          libraryController: widget.libraryController,
                          notInLibraryWidget: (context, addToLibrary) {
                            return LyTonalIconButton(
                              onPressed: addToLibrary,
                              iconSpacing: 0,
                              density: LyDensity.normal,
                              icon: const SizedBox.shrink(),
                              label: Text(context.localization.follow),
                            );
                          },
                          inLibraryWidget: (context, removeFromLibrary) {
                            return LyTonalIconButton(
                              onPressed: removeFromLibrary,
                              density: LyDensity.normal,
                              label: Text(context.localization.following),
                              icon: const Icon(LucideIcons.check, size: 20),
                            );
                          },
                          item: widget.libraryController.data.items
                                  .where(
                                    (e) => e.artist?.id == widget.artist.id,
                                  )
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
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color:
                                        context.themeData.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  context.localization.topSongs,
                                  style: context
                                      .themeData.textTheme.headlineSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              DownupRouter(
                                builder: (context) => ArtistTracksPage(
                                  tracks: allTracks,
                                  artist: widget.artist,
                                  getTrackUsecase: widget.getTrackUsecase,
                                  getPlaylistUsecase: widget.getPlaylistUsecase,
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
                          style: TextButton.styleFrom(
                            foregroundColor:
                                context.themeData.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                context.localization.more,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(LucideIcons.chevronRight, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...widget.artist.topTracks.map(
                    (track) => TrackTile(
                      getTrackUsecase: widget.getTrackUsecase,
                      getAlbumUsecase: widget.getAlbumUsecase,
                      track: track,
                      coreController: widget.coreController,
                      playerController: widget.playerController,
                      getPlaylistUsecase: widget.getPlaylistUsecase,
                      downloaderController: widget.downloaderController,
                      getPlayableItemUsecase: widget.getPlayableItemUsecase,
                      libraryController: widget.libraryController,
                      getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                      getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                      getArtistTracksUsecase: widget.getArtistTracksUsecase,
                      getArtistUsecase: widget.getArtistUsecase,
                      hideOptions: const [TrackTileOptions.seeArtist],
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
                          startFromTrackId: startIndex == -1
                              ? queueToPlay[0].id
                              : queueToPlay[startIndex].id,
                        );
                        widget.libraryController.methods.updateLastTimePlayed(
                          widget.artist.id,
                        );
                      },
                    ),
                  ),
                ],
                if (widget.artist.topAlbums.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  // Albums Section Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: context.themeData.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              context.localization.topAlbums,
                              style: context.themeData.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              DownupRouter(
                                builder: (context) => ArtistAlbumsPage(
                                  albums: allAlbums,
                                  artist: widget.artist,
                                  getTrackUsecase: widget.getTrackUsecase,
                                  getPlaylistUsecase: widget.getPlaylistUsecase,
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
                          style: TextButton.styleFrom(
                            foregroundColor:
                                context.themeData.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                context.localization.more,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(LucideIcons.chevronRight, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 170,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...widget.artist.topAlbums.map(
                          (album) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: AlbumItem(
                              album: album,
                              onTap: () {
                                LyNavigator.push(
                                  context.showingPageContext,
                                  album.tracks.isNotEmpty
                                      ? AlbumPage(
                                          album: album,
                                          getTrackUsecase:
                                              widget.getTrackUsecase,
                                          getPlaylistUsecase:
                                              widget.getPlaylistUsecase,
                                          coreController: widget.coreController,
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
                                          getArtistSinglesUsecase:
                                              widget.getArtistSinglesUsecase,
                                          getArtistTracksUsecase:
                                              widget.getArtistTracksUsecase,
                                          getArtistUsecase:
                                              widget.getArtistUsecase,
                                        )
                                      : AsyncAlbumPage(
                                          getTrackUsecase:
                                              widget.getTrackUsecase,
                                          albumId: album.id,
                                          getPlaylistUsecase:
                                              widget.getPlaylistUsecase,
                                          coreController: widget.coreController,
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
                                          getArtistSinglesUsecase:
                                              widget.getArtistSinglesUsecase,
                                          getArtistTracksUsecase:
                                              widget.getArtistTracksUsecase,
                                          getArtistUsecase:
                                              widget.getArtistUsecase,
                                        ),
                                );
                                widget.libraryController.methods.getLibraryItem(
                                  album.id,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (widget.artist.topSingles.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  // Singles Section Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: context.themeData.colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              context.localization.topSingles,
                              style: context.themeData.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              DownupRouter(
                                builder: (context) => ArtistSinglesPage(
                                  getTrackUsecase: widget.getTrackUsecase,
                                  getPlaylistUsecase: widget.getPlaylistUsecase,
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
                          style: TextButton.styleFrom(
                            foregroundColor:
                                context.themeData.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                context.localization.more,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(LucideIcons.chevronRight, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 170,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...widget.artist.topSingles.map(
                          (album) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: AlbumItem(
                              album: album,
                              onTap: () {
                                LyNavigator.push(
                                  context.showingPageContext,
                                  album.tracks.isNotEmpty
                                      ? AlbumPage(
                                          album: album,
                                          getTrackUsecase:
                                              widget.getTrackUsecase,
                                          getPlaylistUsecase:
                                              widget.getPlaylistUsecase,
                                          coreController: widget.coreController,
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
                                          getArtistSinglesUsecase:
                                              widget.getArtistSinglesUsecase,
                                          getArtistTracksUsecase:
                                              widget.getArtistTracksUsecase,
                                          getArtistUsecase:
                                              widget.getArtistUsecase,
                                        )
                                      : AsyncAlbumPage(
                                          getTrackUsecase:
                                              widget.getTrackUsecase,
                                          albumId: album.id,
                                          getPlaylistUsecase:
                                              widget.getPlaylistUsecase,
                                          coreController: widget.coreController,
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
                                          getArtistSinglesUsecase:
                                              widget.getArtistSinglesUsecase,
                                          getArtistTracksUsecase:
                                              widget.getArtistTracksUsecase,
                                          getArtistUsecase:
                                              widget.getArtistUsecase,
                                        ),
                                );
                                widget.libraryController.methods.getLibraryItem(
                                  album.id,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (widget.artist.similarArtists.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  // Similar Artists Section Header
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: context.themeData.colorScheme.error,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          context.localization.similarArtists,
                          style: context.themeData.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ...widget.artist.similarArtists.map(
                        (similarArtist) => ArtistTile(
                          getTrackUsecase: widget.getTrackUsecase,
                          contentOrigin: ContentOrigin.dataFetch,
                          getPlaylistUsecase: widget.getPlaylistUsecase,
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
                PlayerSizedBox(playerController: widget.playerController),
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
  final String? trackId;
  final CoreController coreController;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final GetArtistUsecase getArtistUsecase;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;

  const AsyncArtistPage({
    super.key,
    required this.artistId,
    this.trackId,
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
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
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
      TrackEntity? track;
      print('LOADING ARTIST -> ${widget.artistId.isEmpty}');
      if (widget.artistId.isEmpty) {
        track = await widget.getTrackUsecase.exec(widget.trackId ?? '');
        print('TRACK -> ${track?.artist.id}');
      }
      final fetchedArtist = await widget.getArtistUsecase.exec(
        track?.artist.id ?? widget.artistId,
      );
      setState(() {
        artist = fetchedArtist;
      });
    } catch (e, stackTrace) {
      print('ERROR -> $e');
      print('STACK TRACE -> $stackTrace');
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
      contextKey: 'AsyncArtistPage_${widget.artistId}',
      child: Scaffold(
        appBar: artist == null ? const MusilyAppBar() : null,
        body: widget.libraryController.builder(
          builder: (context, data) {
            if (loadingArtist || data.loading) {
              return Center(
                child: MusilyDotsLoading(
                  color: context.themeData.colorScheme.primary,
                  size: 50,
                ),
              );
            }
            if (artist == null) {
              return Center(
                child: EmptyState(
                  title: context.localization.artistNotFound,
                  message: context.localization.artistNotFoundDescription,
                  icon: const Icon(LucideIcons.micVocal, size: 50),
                ),
              );
            }
            return ArtistPage(
              artist: artist!,
              isAsync: true,
              coreController: widget.coreController,
              playerController: widget.playerController,
              downloaderController: widget.downloaderController,
              getPlaylistUsecase: widget.getPlaylistUsecase,
              getPlayableItemUsecase: widget.getPlayableItemUsecase,
              libraryController: widget.libraryController,
              getAlbumUsecase: widget.getAlbumUsecase,
              getArtistUsecase: widget.getArtistUsecase,
              getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
              getArtistTracksUsecase: widget.getArtistTracksUsecase,
              getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
              getTrackUsecase: widget.getTrackUsecase,
            );
          },
        ),
      ),
    );
  }
}
