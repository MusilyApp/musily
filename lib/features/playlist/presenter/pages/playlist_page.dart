import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/core_base_widget.dart';
import 'package:musily/core/presenter/widgets/image_collection.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/widgets/offline_icon.dart';
import 'package:musily/features/track/presenter/widgets/track_searcher.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_icon.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_editor.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_options.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';
import 'package:musily_player/musily_entities.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaylistPage extends StatefulWidget {
  final PlaylistEntity playlist;
  final CoreController coreController;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final LibraryController libraryController;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const PlaylistPage({
    required this.playlist,
    required this.coreController,
    required this.playerController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    super.key,
    required this.getAlbumUsecase,
    required this.getPlaylistUsecase,
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

  String playlistHash(List<MusilyTrack> tracks) {
    final sortedList =
        tracks.map((track) => track.hash).whereType<String>().toList()..sort();
    return sortedList.join('');
  }

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
    return CoreBaseWidget(
      coreController: widget.coreController,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.playlist.id == 'favorites'
                ? AppLocalizations.of(context)!.favorites
                : widget.playlist.id == 'offline'
                    ? AppLocalizations.of(context)!.offline
                    : widget.playlist.title,
          ),
          actions: [
            widget.playerController.builder(builder: (context, data) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: TrackSearcher(
                  tracks: widget.playlist.tracks,
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
                    if (data.playingId == widget.playlist.id) {
                      queueToPlay = data.queue;
                    } else {
                      queueToPlay = [
                        ...widget.playlist.tracks
                            .map((element) => TrackModel.toMusilyTrack(element))
                      ];
                    }

                    final startIndex = queueToPlay.indexWhere(
                      (element) => element.hash == track.hash,
                    );

                    widget.playerController.methods.playPlaylist(
                      queueToPlay,
                      widget.playlist.id,
                      startFrom: startIndex == -1 ? 0 : startIndex,
                    );
                    widget.libraryController.methods.updateLastTimePlayed(
                      widget.playlist.id,
                    );
                    controller.closeView(controller.text);
                  },
                ),
              );
            }),
          ],
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.playlist.id == 'favorites'
                      ? const FavoriteIcon(
                          size: 250,
                          iconSize: 150,
                        )
                      : widget.playlist.id == 'offline'
                          ? const OfflineIcon(
                              size: 250,
                              iconSize: 150,
                            )
                          : ImageCollection(
                              urls: imageUrls,
                              size: 250,
                            ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 26,
              ),
              child: Text(
                widget.playlist.id == 'favorites'
                    ? AppLocalizations.of(context)!.favorites
                    : widget.playlist.id == 'offline'
                        ? AppLocalizations.of(context)!.offline
                        : widget.playlist.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.downloaderController.builder(
                  builder: (context, data) {
                    final isPlaylistDownloading = data.queue
                            .where(
                              (e) => e.status == e.downloadDownloading,
                            )
                            .isNotEmpty &&
                        data.downloadingKey == widget.playlist.id;
                    final isDone = data.queue
                            .where(
                              (e) => widget.playlist.tracks
                                  .where((item) => item.hash == e.track.hash)
                                  .isNotEmpty,
                            )
                            .where((e) => e.status == e.downloadCompleted)
                            .length ==
                        widget.playlist.tracks.length;
                    return IconButton.filledTonal(
                      onPressed: widget.playlist.id == 'offline'
                          ? null
                          : () {
                              if (isDone) {
                                return;
                              }
                              if (isPlaylistDownloading) {
                                widget.libraryController.methods
                                    .cancelCollectionDownload(
                                  widget.playlist.tracks,
                                  widget.playlist.id,
                                );
                              } else {
                                widget.libraryController.methods
                                    .downloadCollection(
                                  widget.playlist.tracks,
                                  widget.playlist.id,
                                );
                              }
                            },
                      style: const ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(
                          Size(50, 50),
                        ),
                      ),
                      icon: Icon(
                        isPlaylistDownloading
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
                PlaylistEditor(
                  onFinished: (name) {
                    widget.playlist.title = name;
                  },
                  builder: (context, showEditor) {
                    return IconButton.filledTonal(
                      onPressed: widget.playlist.id == 'favorites' ||
                              widget.playlist.id == 'offline'
                          ? null
                          : showEditor,
                      style: const ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(
                          Size(50, 50),
                        ),
                      ),
                      icon: const Icon(
                        Icons.edit_rounded,
                      ),
                    );
                  },
                  libraryController: widget.libraryController,
                  playlistEntity: widget.playlist,
                ),
                const SizedBox(
                  width: 8,
                ),
                widget.playerController.builder(
                  builder: (context, data) {
                    final isPlaylistPlaying =
                        data.playingId == widget.playlist.id;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton.filled(
                          onPressed: () async {
                            if (isPlaylistPlaying) {
                              if (data.isPlaying) {
                                await widget.playerController.methods.pause();
                              } else {
                                await widget.playerController.methods.resume();
                              }
                            } else {
                              await widget.playerController.methods
                                  .playPlaylist(
                                [
                                  ...widget.playlist.tracks.map(
                                    (track) => TrackModel.toMusilyTrack(
                                      track,
                                    ),
                                  ),
                                ],
                                widget.playlist.id,
                                startFrom: 0,
                              );
                              widget.libraryController.methods
                                  .updateLastTimePlayed(
                                widget.playlist.id,
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
                            isPlaylistPlaying && data.isPlaying
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
                              widget.playlist.tracks.length,
                            );
                            widget.playerController.methods.playPlaylist(
                              [
                                ...widget.playlist.tracks.map(
                                  (element) =>
                                      TrackModel.toMusilyTrack(element),
                                ),
                              ],
                              widget.playlist.id,
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
                              widget.playlist.id,
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
                      ],
                    );
                  },
                ),
                PlaylistOptionsBuilder(
                  playlistEntity: widget.playlist,
                  coreController: widget.coreController,
                  playerController: widget.playerController,
                  getAlbumUsecase: widget.getAlbumUsecase,
                  downloaderController: widget.downloaderController,
                  getPlayableItemUsecase: widget.getPlayableItemUsecase,
                  libraryController: widget.libraryController,
                  getPlaylistUsecase: widget.getPlaylistUsecase,
                  onPlaylistDeleted: () => Navigator.pop(context),
                  builder: (context, showOptions) {
                    return IconButton.filledTonal(
                      onPressed: showOptions,
                      style: const ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(
                          Size(50, 50),
                        ),
                      ),
                      icon: const Icon(
                        Icons.more_vert_outlined,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ...widget.playlist.tracks.map(
              (track) =>
                  widget.playerController.builder(builder: (context, data) {
                return TrackTile(
                  track: track,
                  getAlbumUsecase: widget.getAlbumUsecase,
                  coreController: widget.coreController,
                  playerController: widget.playerController,
                  downloaderController: widget.downloaderController,
                  getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                  getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                  getArtistTracksUsecase: widget.getArtistTracksUsecase,
                  getArtistUsecase: widget.getArtistUsecase,
                  getPlayableItemUsecase: widget.getPlayableItemUsecase,
                  libraryController: widget.libraryController,
                  leading: data.playingId == widget.playlist.id &&
                          data.currentPlayingItem?.hash == track.hash &&
                          data.isPlaying
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                          ),
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        )
                      : null,
                  customAction: () {
                    late final List<MusilyTrack> queueToPlay;
                    if (data.playingId == widget.playlist.id) {
                      queueToPlay = data.queue;
                    } else {
                      queueToPlay = [
                        ...widget.playlist.tracks
                            .map((element) => TrackModel.toMusilyTrack(element))
                      ];
                    }

                    final startIndex = queueToPlay.indexWhere(
                      (element) => element.hash == track.hash,
                    );

                    widget.playerController.methods.playPlaylist(
                      queueToPlay,
                      widget.playlist.id,
                      startFrom: startIndex == -1 ? 0 : startIndex,
                    );
                    widget.libraryController.methods.updateLastTimePlayed(
                      widget.playlist.id,
                    );
                  },
                  customOptions: (context) => [
                    if (widget.playlist.id != 'offline')
                      ListTile(
                        onTap: () {
                          if (widget.playerController.data.currentPlayingItem
                                  ?.hash ==
                              track.hash) {
                            widget.playerController.updateData(
                              widget.playerController.data
                                  .copyWith(playingId: ''),
                            );
                          }
                          widget.libraryController.methods.removeFromPlaylist(
                            widget.playlist.id,
                            track,
                          );
                          setState(() {
                            if (widget.playlist.tracks
                                .where(
                                  (element) => element.hash == track.hash,
                                )
                                .isNotEmpty) {
                              widget.playlist.tracks.removeWhere(
                                (element) => element.hash == track.hash,
                              );
                            }
                          });
                          Navigator.pop(context);
                        },
                        title: Text(
                            AppLocalizations.of(context)!.removeFromPlaylist),
                        leading: Icon(
                          Icons.delete_rounded,
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme
                              ?.primary,
                        ),
                      ),
                  ],
                );
              }),
            ),
            PlayerSizedBox(
              playerController: widget.playerController,
            ),
          ],
        ),
      ),
    );
  }
}

class AsyncPlaylistPage extends StatefulWidget {
  final GetPlaylistUsecase getPlaylistUsecase;
  final CoreController coreController;
  final PlayerController playerController;
  final String playlistId;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const AsyncPlaylistPage({
    super.key,
    required this.getPlaylistUsecase,
    required this.playlistId,
    required this.coreController,
    required this.playerController,
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
  State<AsyncPlaylistPage> createState() => _AsyncPlaylistPageState();
}

class _AsyncPlaylistPageState extends State<AsyncPlaylistPage> {
  bool loadingPlaylist = true;
  PlaylistEntity? playlist;

  loadPlaylist() async {
    setState(() {
      loadingPlaylist = true;
    });
    try {
      final fetchedPlaylist = await widget.getPlaylistUsecase.exec(
        widget.playlistId,
      );
      setState(() {
        playlist = fetchedPlaylist;
      });
    } catch (e) {
      setState(() {
        playlist = null;
      });
    }
    setState(() {
      loadingPlaylist = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: playlist == null ? AppBar() : null,
      body: Builder(
        builder: (context) {
          if (loadingPlaylist) {
            return Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Theme.of(context).colorScheme.primary,
                size: 50,
              ),
            );
          }
          if (playlist == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_rounded,
                    size: 50,
                    color: Theme.of(context).iconTheme.color?.withOpacity(.7),
                  ),
                  Text(AppLocalizations.of(context)!.playlistNotFound)
                ],
              ),
            );
          }
          return PlaylistPage(
            playlist: playlist!,
            coreController: widget.coreController,
            playerController: widget.playerController,
            downloaderController: widget.downloaderController,
            getPlayableItemUsecase: widget.getPlayableItemUsecase,
            libraryController: widget.libraryController,
            getAlbumUsecase: widget.getAlbumUsecase,
            getPlaylistUsecase: widget.getPlaylistUsecase,
            getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
            getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
            getArtistTracksUsecase: widget.getArtistTracksUsecase,
            getArtistUsecase: widget.getArtistUsecase,
          );
        },
      ),
    );
  }
}
