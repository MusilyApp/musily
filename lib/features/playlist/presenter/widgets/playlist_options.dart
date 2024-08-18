import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/core_base_dialog.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/library_toggler.dart';
import 'package:musily/features/_library_module/presenter/widgets/playlist_adder.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_static_tile.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaylistOptions extends StatelessWidget {
  final PlaylistEntity playlistEntity;
  final CoreController coreController;
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final void Function()? onPlaylistDeleted;

  const PlaylistOptions({
    required this.playlistEntity,
    required this.coreController,
    required this.playerController,
    required this.getAlbumUsecase,
    super.key,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getPlaylistUsecase,
    this.onPlaylistDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PlaylistStaticTile(
            playlist: playlistEntity,
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                if (playlistEntity.id != 'offline')
                  downloaderController.builder(
                    builder: (context, data) {
                      final isPlaylistDownloading = data.queue.isNotEmpty &&
                          data.downloadingKey == playlistEntity.id;
                      final isDownloadCompleted = data.queue
                          .where(
                            (e) => playlistEntity.tracks
                                .map((item) => item.hash)
                                .contains(e.track.hash),
                          )
                          .every(
                            (e) => e.status == e.downloadCompleted,
                          );
                      return ListTile(
                        onTap: isDownloadCompleted
                            ? null
                            : () {
                                if (isPlaylistDownloading) {
                                  libraryController.methods
                                      .cancelCollectionDownload(
                                    playlistEntity.tracks,
                                    playlistEntity.id,
                                  );
                                } else {
                                  libraryController.methods.downloadCollection(
                                    playlistEntity.tracks,
                                    playlistEntity.id,
                                  );
                                }
                                Navigator.pop(context);
                              },
                        leading: Icon(
                          isDownloadCompleted
                              ? Icons.download_done_rounded
                              : isPlaylistDownloading
                                  ? Icons.cancel_rounded
                                  : Icons.download_rounded,
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme
                              ?.primary,
                        ),
                        title: Text(
                          isDownloadCompleted
                              ? AppLocalizations.of(context)!.downloadCompleted
                              : isPlaylistDownloading
                                  ? AppLocalizations.of(context)!.cancelDownload
                                  : AppLocalizations.of(context)!.download,
                        ),
                      );
                    },
                  ),
                playerController.builder(
                  builder: (context, data) {
                    final isPlaylistPlaying =
                        data.playingId == playlistEntity.id;
                    return Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            if (isPlaylistPlaying) {
                              if (data.isPlaying) {
                                await playerController.methods.pause();
                              } else {
                                await playerController.methods.resume();
                              }
                            } else {
                              await playerController.methods.playPlaylist(
                                [
                                  ...playlistEntity.tracks.map(
                                    (track) => TrackModel.toMusilyTrack(track),
                                  ),
                                ],
                                playlistEntity.id,
                                startFrom: 0,
                              );
                              libraryController.methods.updateLastTimePlayed(
                                playlistEntity.id,
                              );
                            }
                          },
                          leading: Icon(
                            isPlaylistPlaying && data.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                ?.primary,
                          ),
                          title: Text(
                            isPlaylistPlaying && data.isPlaying
                                ? AppLocalizations.of(context)!.pause
                                : AppLocalizations.of(context)!.play,
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            final random = Random();
                            final randomIndex = random.nextInt(
                              playlistEntity.tracks.length,
                            );
                            playerController.methods.playPlaylist(
                              [
                                ...playlistEntity.tracks.map(
                                  (element) =>
                                      TrackModel.toMusilyTrack(element),
                                ),
                              ],
                              playlistEntity.id,
                              startFrom: randomIndex,
                            );
                            Navigator.pop(context);
                            if (!data.shuffleEnabled) {
                              playerController.methods.toggleShuffle();
                            } else {
                              await playerController.methods.toggleShuffle();
                              playerController.methods.toggleShuffle();
                            }
                            libraryController.methods.updateLastTimePlayed(
                              playlistEntity.id,
                            );
                          },
                          leading: Icon(
                            Icons.shuffle_rounded,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                ?.primary,
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.shufflePlay,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            playerController.methods.addToQueue(
                              [
                                ...playlistEntity.tracks.map(
                                  (track) => TrackModel.toMusilyTrack(track),
                                ),
                              ],
                            );
                            Navigator.pop(context);
                          },
                          leading: Icon(
                            Icons.playlist_add,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                ?.primary,
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.addToQueue,
                            style: const TextStyle(
                              color: null,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                PlaylistAdder(
                  libraryController,
                  asyncTracks: () async {
                    if (playlistEntity.tracks.isNotEmpty) {
                      return playlistEntity.tracks;
                    }
                    final fetchedPlaylist = await getPlaylistUsecase.exec(
                      playlistEntity.id,
                    );
                    return fetchedPlaylist?.tracks ?? [];
                  },
                  builder: (context, showAdder) => ListTile(
                    onTap: showAdder,
                    leading: Icon(
                      Icons.queue_music,
                      color: Theme.of(context).buttonTheme.colorScheme?.primary,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.addToPlaylist,
                    ),
                  ),
                ),
                LibraryToggler(
                  item: playlistEntity,
                  libraryController: libraryController,
                  notInLibraryWidget: (context, addToLibrary) {
                    return Container();
                  },
                  inLibraryWidget: (context, removeFromLibrary) {
                    return ListTile(
                      enabled: playlistEntity.id != 'favorites',
                      onTap: () async {
                        final deleteDialog = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                AppLocalizations.of(context)!
                                    .doYouWantToDeleteThePlaylist,
                              ),
                              content: Text(
                                AppLocalizations.of(context)!
                                    .theActionCannotBeUndone,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                      false,
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                  ),
                                ),
                                TextButton(
                                  style: const ButtonStyle(
                                    foregroundColor: WidgetStatePropertyAll(
                                      Colors.red,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                      true,
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.delete,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (deleteDialog != null && deleteDialog) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          onPlaylistDeleted?.call();
                          removeFromLibrary();
                        }
                      },
                      leading: Icon(
                        Icons.delete,
                        color:
                            Theme.of(context).buttonTheme.colorScheme?.primary,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.deletePlaylist,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlaylistOptionsBuilder extends StatelessWidget {
  final CoreController coreController;
  final PlayerController playerController;
  final PlaylistEntity playlistEntity;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final void Function()? onPlaylistDeleted;
  final Widget Function(BuildContext context, void Function() showOptions)
      builder;

  const PlaylistOptionsBuilder({
    required this.playlistEntity,
    required this.coreController,
    required this.builder,
    required this.playerController,
    required this.getAlbumUsecase,
    super.key,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getPlaylistUsecase,
    this.onPlaylistDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, () {
      coreController.methods.pushModal(
        CoreBaseDialog(
          coreController: coreController,
          child: PlaylistOptions(
            playlistEntity: playlistEntity,
            getPlaylistUsecase: getPlaylistUsecase,
            coreController: coreController,
            playerController: playerController,
            getAlbumUsecase: getAlbumUsecase,
            downloaderController: downloaderController,
            getPlayableItemUsecase: getPlayableItemUsecase,
            libraryController: libraryController,
            onPlaylistDeleted: onPlaylistDeleted,
          ),
        ),
      );
    });
  }
}
