import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musily/core/domain/entities/app_menu_entry.dart';
import 'package:musily/core/domain/entities/identifiable.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/buttons/ly_tonal_icon_button.dart';
import 'package:musily/core/presenter/widgets/app_menu.dart';
import 'package:musily/core/utils/display_helper.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_adder.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_static_tile.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaylistOptions extends StatelessWidget {
  final PlaylistEntity playlist;
  final CoreController coreController;
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final void Function()? onPlaylistDeleted;
  final bool tonal;

  const PlaylistOptions({
    super.key,
    required this.playlist,
    required this.coreController,
    required this.playerController,
    required this.getAlbumUsecase,
    required this.getPlaylistUsecase,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    this.onPlaylistDeleted,
    this.tonal = false,
  });

  @override
  Widget build(BuildContext context) {
    return downloaderController.builder(
      builder: (context, downloaderData) {
        final isPlaylistDownloading = downloaderData.queue.isNotEmpty &&
            downloaderData.downloadingKey == playlist.id;
        final isDownloadCompleted = downloaderData.queue
                .where(
                  (e) => playlist.tracks
                      .where((item) => item.hash == e.track.hash)
                      .isNotEmpty,
                )
                .where((e) => e.status == e.downloadCompleted)
                .length ==
            playlist.tracks.length;
        return playerController.builder(
          builder: (context, playerData) {
            final isPlaylistPlaying = playerData.playingId == playlist.id;
            return libraryController.builder(
              builder: (context, libraryData) {
                final isInLibrary = libraryData.items
                    .where((element) =>
                        (element.value as Identifiable).id == playlist.id)
                    .isNotEmpty;
                return AppMenu(
                  coreController: coreController,
                  modalHeader: PlaylistStaticTile(
                    playlist: playlist,
                  ),
                  toggler: (context, invoke) {
                    if (tonal) {
                      return LyTonalIconButton(
                        onPressed: invoke,
                        fixedSize: const Size(55, 55),
                        icon: const Icon(
                          Icons.more_vert,
                        ),
                      );
                    }
                    return IconButton(
                      onPressed: invoke,
                      icon: const Icon(
                        Icons.more_vert,
                      ),
                    );
                  },
                  entries: [
                    if (playlist.id != 'offline')
                      AppMenuEntry(
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
                        onTap: isDownloadCompleted
                            ? null
                            : () {
                                if (isPlaylistDownloading) {
                                  libraryController.methods
                                      .cancelCollectionDownload(
                                    playlist.tracks,
                                    playlist.id,
                                  );
                                } else {
                                  libraryController.methods.downloadCollection(
                                    playlist.tracks,
                                    playlist.id,
                                  );
                                }
                              },
                        title: Text(
                          isDownloadCompleted
                              ? AppLocalizations.of(context)!.downloadCompleted
                              : isPlaylistDownloading
                                  ? AppLocalizations.of(context)!.cancelDownload
                                  : AppLocalizations.of(context)!.download,
                        ),
                      ),
                    AppMenuEntry(
                      leading: Icon(
                        isPlaylistPlaying && playerData.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color:
                            Theme.of(context).buttonTheme.colorScheme?.primary,
                      ),
                      onTap: () async {
                        if (isPlaylistPlaying) {
                          if (playerData.isPlaying) {
                            await playerController.methods.pause();
                          } else {
                            await playerController.methods.resume();
                          }
                        } else {
                          await playerController.methods.playPlaylist(
                            [
                              ...playlist.tracks.map(
                                (track) => TrackModel.toMusilyTrack(track),
                              ),
                            ],
                            playlist.id,
                            startFrom: 0,
                          );
                          libraryController.methods.updateLastTimePlayed(
                            playlist.id,
                          );
                        }
                      },
                      title: Text(
                        isPlaylistPlaying && playerData.isPlaying
                            ? AppLocalizations.of(context)!.pause
                            : AppLocalizations.of(context)!.play,
                      ),
                    ),
                    AppMenuEntry(
                      onTap: () async {
                        final random = Random();
                        final randomIndex = random.nextInt(
                          playlist.tracks.length,
                        );
                        playerController.methods.playPlaylist(
                          [
                            ...playlist.tracks.map(
                              (element) => TrackModel.toMusilyTrack(element),
                            ),
                          ],
                          playlist.id,
                          startFrom: randomIndex,
                        );
                        if (!playerData.shuffleEnabled) {
                          playerController.methods.toggleShuffle();
                        } else {
                          await playerController.methods.toggleShuffle();
                          playerController.methods.toggleShuffle();
                        }
                        libraryController.methods.updateLastTimePlayed(
                          playlist.id,
                        );
                      },
                      leading: Icon(
                        Icons.shuffle_rounded,
                        color:
                            Theme.of(context).buttonTheme.colorScheme?.primary,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.shufflePlay,
                      ),
                    ),
                    AppMenuEntry(
                      onTap: () {
                        playerController.methods.addToQueue(
                          [
                            ...playlist.tracks.map(
                              (track) => TrackModel.toMusilyTrack(track),
                            ),
                          ],
                        );
                      },
                      leading: Icon(
                        Icons.playlist_add,
                        color:
                            Theme.of(context).buttonTheme.colorScheme?.primary,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.addToQueue,
                        style: const TextStyle(
                          color: null,
                        ),
                      ),
                    ),
                    AppMenuEntry(
                      title: Text(
                        AppLocalizations.of(context)!.addToPlaylist,
                      ),
                      leading: Icon(
                        Icons.queue_music,
                        color:
                            Theme.of(context).buttonTheme.colorScheme?.primary,
                      ),
                      onTap: () {
                        // TODO AsynTracks
                        if (DisplayHelper(context).isDesktop) {
                          showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * .7,
                                height: MediaQuery.of(context).size.height * .7,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(
                                            .3,
                                          ),
                                    ),
                                  ),
                                  child: PlaylistAdderWidget(
                                    coreController: coreController,
                                    libraryController: libraryController,
                                    tracks: playlist.tracks,
                                  ),
                                ),
                              ),
                            ),
                          );
                          return;
                        }
                        coreController.methods.pushModal(
                          PlaylistAdderWidget(
                            coreController: coreController,
                            libraryController: libraryController,
                            tracks: playlist.tracks,
                          ),
                          // overlayMainPage: true,
                        );
                      },
                    ),
                    if (playlist.id != 'favorites' &&
                        playlist.id != 'offline' &&
                        isInLibrary)
                      AppMenuEntry(
                        leading: Icon(
                          Icons.delete,
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme
                              ?.primary,
                        ),
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
                            await libraryController.methods.deleteLibraryItem(
                              playlist.id,
                            );
                          }
                        },
                        title: Text(
                          AppLocalizations.of(context)!.deletePlaylist,
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
