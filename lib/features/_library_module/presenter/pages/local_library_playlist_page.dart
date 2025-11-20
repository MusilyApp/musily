import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_icon_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_tonal_icon_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/core/presenter/widgets/musily_loading.dart';
import 'package:musily/features/_library_module/domain/entities/local_library_playlist.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/local_playlist_icon.dart';
import 'package:musily/features/_library_module/presenter/widgets/local_playlist_options.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:musily/features/track/presenter/widgets/track_searcher.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';

class LocalLibraryPlaylistPage extends StatefulWidget {
  final String playlistId;
  final LibraryController libraryController;
  final PlayerController playerController;
  final CoreController coreController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetTrackUsecase getTrackUsecase;

  const LocalLibraryPlaylistPage({
    super.key,
    required this.playlistId,
    required this.libraryController,
    required this.playerController,
    required this.coreController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<LocalLibraryPlaylistPage> createState() =>
      _LocalLibraryPlaylistPageState();
}

class _LocalLibraryPlaylistPageState extends State<LocalLibraryPlaylistPage> {
  bool _loading = true;
  List<TrackEntity> _tracks = [];
  bool _directoryExists = true;

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    setState(() {
      _loading = true;
    });
    final playlist = _currentPlaylist;
    if (playlist == null) {
      setState(() {
        _tracks = [];
        _loading = false;
      });
      return;
    }
    final directory = Directory(playlist.directoryPath);
    final exists = await directory.exists();
    if (!exists) {
      setState(() {
        _tracks = [];
        _directoryExists = false;
        _loading = false;
      });
      return;
    }
    final tracks = await widget.libraryController.methods
        .getLocalPlaylistTracks(widget.playlistId);
    if (!mounted) return;
    setState(() {
      _tracks = tracks;
      _directoryExists = true;
      _loading = false;
    });
  }

  LocalLibraryPlaylist? get _currentPlaylist {
    return widget.libraryController.data.localPlaylists
        .firstWhereOrNull((element) => element.id == widget.playlistId);
  }

  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'LocalLibraryPlaylist_${widget.playlistId}',
      child: widget.libraryController.builder(
        builder: (context, libraryData) {
          final playlist = libraryData.localPlaylists
              .firstWhereOrNull((element) => element.id == widget.playlistId);

          if (_loading) {
            return Scaffold(
              appBar: MusilyAppBar(
                title: Text(
                    playlist?.name ?? context.localization.localLibraryTitle),
              ),
              body: Center(
                child: MusilyDotsLoading(
                  color: context.themeData.colorScheme.primary,
                  size: 50,
                ),
              ),
            );
          }

          if (!_directoryExists || playlist == null) {
            return Scaffold(
              appBar: MusilyAppBar(
                title: Text(
                    playlist?.name ?? context.localization.localLibraryTitle),
              ),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.triangleAlert,
                      size: 50,
                      color: context.themeData.iconTheme.color?.withValues(
                        alpha: .7,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(context.localization.invalidDirectory),
                  ],
                ),
              ),
            );
          }

          return widget.playerController.builder(
            builder: (context, playerData) {
              return Scaffold(
                appBar: MusilyAppBar(
                  title: Text(context.localization.localLibraryTitle),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TrackSearcher(
                        getTrackUsecase: widget.getTrackUsecase,
                        tracks: _tracks,
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
                          if (playerData.playingId == widget.playlistId) {
                            queueToPlay = playerData.queue;
                            if (!queueToPlay
                                .any((element) => element.id == track.id)) {
                              queueToPlay.add(track);
                            }
                          } else {
                            queueToPlay = _tracks;
                          }

                          final startIndex = queueToPlay.indexWhere(
                            (element) => element.hash == track.hash,
                          );

                          widget.playerController.methods.playPlaylist(
                            queueToPlay,
                            widget.playlistId,
                            startFromTrackId: startIndex == -1
                                ? queueToPlay[0].id
                                : queueToPlay[startIndex].id,
                          );
                          controller.closeView(controller.text);
                        },
                        getPlaylistUsecase: widget.getPlaylistUsecase,
                      ),
                    ),
                  ],
                ),
                body: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 16),
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LocalPlaylistIcon(
                                size: 150,
                                animated: playerData.isPlaying &&
                                    playerData.playingId == widget.playlistId,
                                iconSize: 80,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: SizedBox(
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playlist.name,
                                  textAlign: TextAlign.center,
                                  style: context
                                      .themeData.textTheme.headlineSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      LucideIcons.music,
                                      size: 14,
                                      color: context.themeData.colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.7),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_tracks.length} ${context.localization.songs}',
                                      style: context
                                          .themeData.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: context.themeData.colorScheme
                                            .onSurfaceVariant
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LyTonalIconButton(
                            onPressed: _tracks.isEmpty ? null : _shufflePlay,
                            fixedSize: const Size(55, 55),
                            icon: const Icon(LucideIcons.shuffle, size: 20),
                          ),
                          const SizedBox(width: 12),
                          LyFilledIconButton(
                            onPressed: _tracks.isEmpty
                                ? null
                                : () => _handlePlayButton(playlist, playerData),
                            fixedSize: const Size(70, 70),
                            iconSize: 32,
                            icon: Icon(
                              playerData.playingId == widget.playlistId &&
                                      playerData.isPlaying
                                  ? LucideIcons.pause
                                  : LucideIcons.play,
                            ),
                          ),
                          const SizedBox(width: 12),
                          LocalPlaylistOptions(
                            playlist: playlist,
                            coreController: widget.coreController,
                            playerController: widget.playerController,
                            libraryController: widget.libraryController,
                            tonal: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    if (_tracks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.music4,
                                size: 50,
                                color: context.themeData.iconTheme.color
                                    ?.withValues(alpha: .7),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                context.localization.emptyLocalPlaylist,
                                style: context.themeData.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._tracks.map(
                        (track) => TrackTile(
                          getTrackUsecase: widget.getTrackUsecase,
                          getPlaylistUsecase: widget.getPlaylistUsecase,
                          getAlbumUsecase: widget.getAlbumUsecase,
                          leading: playerData.playingId == widget.playlistId &&
                                  playerData.currentPlayingItem?.hash ==
                                      track.hash &&
                                  playerData.isPlaying
                              ? SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: MusilyWaveLoading(
                                    color:
                                        context.themeData.colorScheme.primary,
                                    size: 20,
                                  ),
                                )
                              : null,
                          hideOptions: const [],
                          downloaderController: widget.downloaderController,
                          getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                          getArtistSinglesUsecase:
                              widget.getArtistSinglesUsecase,
                          getArtistTracksUsecase: widget.getArtistTracksUsecase,
                          getArtistUsecase: widget.getArtistUsecase,
                          getPlayableItemUsecase: widget.getPlayableItemUsecase,
                          libraryController: widget.libraryController,
                          customAction: () {
                            late final List<TrackEntity> queueToPlay;
                            if (playerData.playingId == widget.playlistId) {
                              queueToPlay = playerData.queue;
                              if (!queueToPlay
                                  .any((element) => element.id == track.id)) {
                                queueToPlay.add(track);
                              }
                            } else {
                              queueToPlay = _tracks;
                            }

                            final startIndex = queueToPlay.indexWhere(
                              (element) => element.hash == track.hash,
                            );

                            widget.playerController.methods.playPlaylist(
                              queueToPlay,
                              widget.playlistId,
                              startFromTrackId: startIndex == -1
                                  ? queueToPlay[0].id
                                  : queueToPlay[startIndex].id,
                            );
                          },
                          track: track,
                          coreController: widget.coreController,
                          playerController: widget.playerController,
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _shufflePlay() async {
    if (_tracks.isEmpty) return;
    final randomIndex = Random().nextInt(_tracks.length);
    await widget.playerController.methods.playPlaylist(
      _tracks,
      widget.playlistId,
      startFromTrackId: _tracks[randomIndex].id,
    );
    if (!widget.playerController.data.shuffleEnabled) {
      widget.playerController.methods.toggleShuffle();
    } else {
      await widget.playerController.methods.toggleShuffle();
      widget.playerController.methods.toggleShuffle();
    }
  }

  Future<void> _handlePlayButton(
    LocalLibraryPlaylist playlist,
    dynamic playerData,
  ) async {
    final isCurrent = playerData.playingId == playlist.id;
    if (isCurrent) {
      if (playerData.isPlaying) {
        await widget.playerController.methods.pause();
      } else {
        await widget.playerController.methods.resume();
      }
    } else {
      await widget.playerController.methods.playPlaylist(
        _tracks,
        widget.playlistId,
        startFromTrackId: _tracks.first.id,
      );
    }
  }
}
