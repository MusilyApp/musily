import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/domain/entities/app_menu_entry.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/duration.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_icon_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_tonal_icon_button.dart';
import 'package:musily/core/presenter/widgets/image_collection.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/core/presenter/widgets/musily_loading.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/widgets/offline_icon.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_icon.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_editor.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_options.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:musily/features/track/presenter/widgets/track_searcher.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';

class MPlaylistPage extends StatefulWidget {
  final PlaylistEntity playlist;
  final CoreController coreController;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetTrackUsecase getTrackUsecase;

  const MPlaylistPage({
    super.key,
    required this.playlist,
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
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<MPlaylistPage> createState() => _MPlaylistPageState();
}

class _MPlaylistPageState extends State<MPlaylistPage> {
  late List<String> imageUrls;

  String playlistHash(List<TrackEntity> tracks) {
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
    return widget.playerController.builder(
      builder: (context, data) {
        return Scaffold(
          appBar: MusilyAppBar(
            title: Text(context.localization.playlist),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TrackSearcher(
                  getTrackUsecase: widget.getTrackUsecase,
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
                    late final List<TrackEntity> queueToPlay;
                    if (data.playingId == widget.playlist.id) {
                      queueToPlay = data.queue;
                      if (!queueToPlay
                          .any((element) => element.id == track.id)) {
                        queueToPlay.add(track);
                      }
                    } else {
                      queueToPlay = widget.playlist.tracks;
                    }

                    final startIndex = queueToPlay.indexWhere(
                      (element) => element.hash == track.hash,
                    );

                    widget.playerController.methods.playPlaylist(
                      queueToPlay,
                      widget.playlist.id,
                      startFromTrackId: startIndex == -1
                          ? queueToPlay[0].id
                          : queueToPlay[startIndex].id,
                    );
                    widget.libraryController.methods.updateLastTimePlayed(
                      widget.playlist.id,
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
                        child: widget.playlist.id == UserService.favoritesId
                            ? FavoriteIcon(
                                size: 150,
                                animated: data.isPlaying &&
                                    data.playingId.startsWith('favorites'),
                                iconSize: 80,
                              )
                            : widget.playlist.id == 'offline'
                                ? const OfflineIcon(size: 150, iconSize: 80)
                                : ImageCollection(urls: imageUrls, size: 150),
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
                            widget.playlist.id == UserService.favoritesId
                                ? context.localization.favorites
                                : widget.playlist.id == 'offline'
                                    ? context.localization.offline
                                    : widget.playlist.title,
                            textAlign: TextAlign.center,
                            style: context.themeData.textTheme.headlineSmall
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
                                color: context
                                    .themeData.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.playlist.tracks.length} ${context.localization.songs}',
                                style: context.themeData.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: context
                                      .themeData.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            getFormattedTracksTime(widget.playlist, context),
                            style:
                                context.themeData.textTheme.bodySmall?.copyWith(
                              color: context
                                  .themeData.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.downloaderController.builder(
                      builder: (context, data) {
                        final isPlaylistDownloading = data.queue
                                .where((e) => e.status == e.downloadDownloading)
                                .isNotEmpty &&
                            data.downloadingKey == widget.playlist.id;
                        final isDone = data.queue
                                .where(
                                  (e) => widget.playlist.tracks
                                      .where(
                                        (item) => item.hash == e.track.hash,
                                      )
                                      .isNotEmpty,
                                )
                                .where((e) => e.status == e.downloadCompleted)
                                .length ==
                            widget.playlist.tracks.length;
                        return LyTonalIconButton(
                          fixedSize: const Size(55, 55),
                          onPressed: widget.playlist.id == 'offline' ||
                                  widget.playlist.tracks.isEmpty
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
                          icon: Icon(
                            isPlaylistDownloading
                                ? LucideIcons.x
                                : isDone
                                    ? LucideIcons.circleCheckBig
                                    : LucideIcons.download,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    PlaylistEditor(
                      onFinished: (name) {
                        widget.playlist.title = name;
                      },
                      builder: (context, showEditor) {
                        return LyTonalIconButton(
                          onPressed:
                              widget.playlist.id == UserService.favoritesId ||
                                      widget.playlist.id == 'offline'
                                  ? null
                                  : showEditor,
                          fixedSize: const Size(55, 55),
                          icon: const Icon(LucideIcons.pencil),
                        );
                      },
                      libraryController: widget.libraryController,
                      playlistEntity: widget.playlist,
                    ),
                    const SizedBox(width: 8),
                    LyFilledIconButton(
                      iconSize: 30,
                      fixedSize: const Size(60, 60),
                      onPressed: widget.playlist.tracks.isEmpty
                          ? null
                          : () async {
                              final isPlaylistPlaying =
                                  data.playingId == widget.playlist.id;
                              if (isPlaylistPlaying) {
                                if (data.isPlaying) {
                                  await widget.playerController.methods.pause();
                                } else {
                                  await widget.playerController.methods
                                      .resume();
                                }
                              } else {
                                await widget.playerController.methods
                                    .playPlaylist(
                                  widget.playlist.tracks,
                                  widget.playlist.id,
                                  startFromTrackId:
                                      widget.playlist.tracks[0].id,
                                );
                                widget.libraryController.methods
                                    .updateLastTimePlayed(widget.playlist.id);
                              }
                            },
                      icon: Icon(
                        data.isPlaying && data.playingId == widget.playlist.id
                            ? LucideIcons.pause
                            : LucideIcons.play,
                      ),
                    ),
                    widget.playerController.builder(
                      builder: (context, data) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 8),
                            LyTonalIconButton(
                              onPressed: widget.playlist.tracks.isNotEmpty
                                  ? () async {
                                      final random = Random();
                                      final randomIndex = random.nextInt(
                                        widget.playlist.tracks.length,
                                      );
                                      widget.playerController.methods
                                          .playPlaylist(
                                        widget.playlist.tracks,
                                        widget.playlist.id,
                                        startFromTrackId: widget
                                            .playlist.tracks[randomIndex].id,
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
                                        widget.playlist.id,
                                      );
                                    }
                                  : null,
                              fixedSize: const Size(55, 55),
                              icon: const Icon(LucideIcons.shuffle),
                            ),
                            const SizedBox(width: 8),
                          ],
                        );
                      },
                    ),
                    PlaylistOptions(
                      playlist: widget.playlist,
                      coreController: widget.coreController,
                      playerController: widget.playerController,
                      getAlbumUsecase: widget.getAlbumUsecase,
                      downloaderController: widget.downloaderController,
                      getPlayableItemUsecase: widget.getPlayableItemUsecase,
                      libraryController: widget.libraryController,
                      tonal: true,
                      getPlaylistUsecase: widget.getPlaylistUsecase,
                    ),
                  ],
                ),
              ),
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
                      style:
                          context.themeData.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...widget.playlist.tracks.map(
                (track) => widget.playerController.builder(
                  builder: (context, playerData) {
                    return widget.libraryController.builder(
                      builder: (context, libraryData) {
                        return TrackTile(
                          getTrackUsecase: widget.getTrackUsecase,
                          getPlaylistUsecase: widget.getPlaylistUsecase,
                          track: track,
                          getAlbumUsecase: widget.getAlbumUsecase,
                          coreController: widget.coreController,
                          playerController: widget.playerController,
                          downloaderController: widget.downloaderController,
                          getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                          getArtistSinglesUsecase:
                              widget.getArtistSinglesUsecase,
                          getArtistTracksUsecase: widget.getArtistTracksUsecase,
                          getArtistUsecase: widget.getArtistUsecase,
                          getPlayableItemUsecase: widget.getPlayableItemUsecase,
                          libraryController: widget.libraryController,
                          leading: playerData.playingId == widget.playlist.id &&
                                  playerData.currentPlayingItem?.hash ==
                                      track.hash &&
                                  playerData.isPlaying
                              ? SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: MusilyWaveLoading(
                                      color:
                                          context.themeData.colorScheme.primary,
                                      size: 20,
                                    ),
                                  ),
                                )
                              : null,
                          customAction: () {
                            late final List<TrackEntity> queueToPlay;
                            if (playerData.playingId == widget.playlist.id) {
                              queueToPlay = playerData.queue;
                              if (!queueToPlay
                                  .any((element) => element.id == track.id)) {
                                queueToPlay.add(track);
                              }
                            } else {
                              queueToPlay = widget.playlist.tracks;
                            }

                            final startIndex = queueToPlay.indexWhere(
                              (element) => element.hash == track.hash,
                            );

                            widget.playerController.methods.playPlaylist(
                              queueToPlay,
                              widget.playlist.id,
                              startFromTrackId: startIndex == -1
                                  ? queueToPlay[0].id
                                  : queueToPlay[startIndex].id,
                            );
                            widget.libraryController.methods
                                .updateLastTimePlayed(widget.playlist.id);
                          },
                          customOptions: (context) {
                            final isInLibrary = libraryData.items
                                .where(
                                  (element) => element.id == widget.playlist.id,
                                )
                                .isNotEmpty;
                            return [
                              if (widget.playlist.id != 'offline' &&
                                  isInLibrary)
                                AppMenuEntry(
                                  onTap: () {
                                    if (widget.playerController.data
                                            .currentPlayingItem?.hash ==
                                        track.hash) {
                                      widget.playerController.updateData(
                                        widget.playerController.data.copyWith(
                                          playingId: '',
                                        ),
                                      );
                                    }
                                    widget.libraryController.methods
                                        .removeTracksFromPlaylist(
                                      widget.playlist.id,
                                      [track.id],
                                    );
                                    setState(() {
                                      if (widget.playlist.tracks.any(
                                        (element) => element.hash == track.hash,
                                      )) {
                                        widget.playlist.tracks.removeWhere(
                                          (element) =>
                                              element.hash == track.hash,
                                        );
                                      }
                                    });
                                  },
                                  title: Text(
                                    context.localization.removeFromPlaylist,
                                  ),
                                  leading: Icon(
                                    LucideIcons.trash,
                                    color: context.themeData.buttonTheme
                                        .colorScheme?.primary,
                                  ),
                                ),
                            ];
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String getFormattedTracksTime(PlaylistEntity playlist, BuildContext context) {
  int seconds = 0;
  for (var track in playlist.tracks) {
    seconds += track.duration.inSeconds;
  }

  final totalDuration = Duration(seconds: seconds);

  return totalDuration.toLocalizedString(context);
}
