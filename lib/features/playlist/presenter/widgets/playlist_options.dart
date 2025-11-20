import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/domain/entities/app_menu_entry.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_tonal_icon_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_menu.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_adder.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_static_tile.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class PlaylistOptions extends StatelessWidget {
  final PlaylistEntity playlist;
  final CoreController coreController;
  final PlayerController playerController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final void Function()? onPlaylistDeleted;
  final bool tonal;
  final double? iconSize;

  const PlaylistOptions({
    super.key,
    required this.playlist,
    required this.coreController,
    required this.playerController,
    required this.getAlbumUsecase,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    this.onPlaylistDeleted,
    this.tonal = false,
    required this.getPlaylistUsecase,
    this.iconSize,
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
                    .where((element) => element.id == playlist.id)
                    .isNotEmpty;
                return AppMenu(
                  coreController: coreController,
                  modalHeader: PlaylistStaticTile(playlist: playlist),
                  toggler: (context, invoke) {
                    if (tonal) {
                      return LyTonalIconButton(
                        onPressed: invoke,
                        fixedSize: const Size(55, 55),
                        icon: Icon(
                          LucideIcons.ellipsis,
                          size: iconSize ?? 20,
                          color: context.themeData.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      );
                    }
                    return IconButton(
                      onPressed: invoke,
                      icon: Icon(
                        LucideIcons.ellipsisVertical,
                        size: iconSize ?? 20,
                        color: context.themeData.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    );
                  },
                  entries: [
                    if (playlist.id != 'offline')
                      AppMenuEntry(
                        leading: Icon(
                          isDownloadCompleted
                              ? LucideIcons.circleCheckBig
                              : isPlaylistDownloading
                                  ? LucideIcons.circleX
                                  : LucideIcons.download,
                          color: context
                              .themeData.buttonTheme.colorScheme?.primary,
                          size: 20,
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
                              ? context.localization.downloadCompleted
                              : isPlaylistDownloading
                                  ? context.localization.cancelDownload
                                  : context.localization.download,
                        ),
                      ),
                    if (playlist.tracks.isNotEmpty) ...[
                      AppMenuEntry(
                        leading: Icon(
                          isPlaylistPlaying && playerData.isPlaying
                              ? LucideIcons.pause
                              : LucideIcons.play,
                          size: 20,
                          color: context
                              .themeData.buttonTheme.colorScheme?.primary,
                        ),
                        onTap: playlist.tracks.isEmpty
                            ? null
                            : () async {
                                if (isPlaylistPlaying) {
                                  if (playerData.isPlaying) {
                                    await playerController.methods.pause();
                                  } else {
                                    await playerController.methods.resume();
                                  }
                                } else {
                                  await playerController.methods.playPlaylist(
                                    playlist.tracks,
                                    playlist.id,
                                    startFromTrackId: playlist.tracks[0].id,
                                  );
                                  libraryController.methods
                                      .updateLastTimePlayed(playlist.id);
                                }
                              },
                        title: Text(
                          isPlaylistPlaying && playerData.isPlaying
                              ? context.localization.pause
                              : context.localization.play,
                        ),
                      ),
                      AppMenuEntry(
                        onTap: () async {
                          final random = Random();
                          final randomIndex = random.nextInt(
                            playlist.tracks.length,
                          );
                          playerController.methods.playPlaylist(
                            playlist.tracks,
                            playlist.id,
                            startFromTrackId: playlist.tracks[randomIndex].id,
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
                          LucideIcons.shuffle,
                          size: 20,
                          color: context
                              .themeData.buttonTheme.colorScheme?.primary,
                        ),
                        title: Text(context.localization.shufflePlay),
                      ),
                      AppMenuEntry(
                        onTap: () {
                          playerController.methods.addToQueue(playlist.tracks);
                        },
                        leading: Icon(
                          LucideIcons.listPlus,
                          size: 20,
                          color: context
                              .themeData.buttonTheme.colorScheme?.primary,
                        ),
                        title: Text(
                          context.localization.addToQueue,
                          style: const TextStyle(color: null),
                        ),
                      ),
                      AppMenuEntry(
                        title: Text(context.localization.addToPlaylist),
                        leading: Icon(
                          LucideIcons.listMusic,
                          size: 20,
                          color: context
                              .themeData.buttonTheme.colorScheme?.primary,
                        ),
                        onTap: () {
                          // TODO AsynTracks
                          if (context.display.isDesktop) {
                            LyNavigator.showLyDialog(
                              context: context,
                              builder: (context) => Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * .7,
                                  height:
                                      MediaQuery.of(context).size.height * .7,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ),
                                      side: BorderSide(
                                        color: context.themeData.dividerColor
                                            .withValues(alpha: .3),
                                      ),
                                    ),
                                    child: PlaylistAdderWidget(
                                      coreController: coreController,
                                      libraryController: libraryController,
                                      getPlaylistUsecase: getPlaylistUsecase,
                                      tracks: playlist.tracks,
                                    ),
                                  ),
                                ),
                              ),
                            );
                            return;
                          }
                          LyNavigator.push(
                            coreController.coreContext!,
                            PlaylistAdderWidget(
                              coreController: coreController,
                              getPlaylistUsecase: getPlaylistUsecase,
                              libraryController: libraryController,
                              tracks: playlist.tracks,
                            ),
                          );
                        },
                      ),
                    ],
                    if (playlist.id != UserService.favoritesId &&
                        playlist.id != 'offline' &&
                        isInLibrary)
                      AppMenuEntry(
                        leading: Icon(
                          LucideIcons.trash,
                          color: context
                              .themeData.buttonTheme.colorScheme?.primary,
                        ),
                        onTap: () async {
                          final deleteDialog =
                              await LyNavigator.showLyCardDialog<bool>(
                            context: context,
                            title: Text(
                              context.localization.doYouWantToDeleteThePlaylist,
                            ),
                            actions: (context) => [
                              LyFilledButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Text(
                                  context.localization.cancel,
                                ),
                              ),
                              LyFilledButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                color: Colors.red,
                                child: Text(
                                  context.localization.delete,
                                ),
                              ),
                            ],
                            builder: (context) => Text(
                              context.localization.theActionCannotBeUndone,
                            ),
                          );
                          if (deleteDialog != null && deleteDialog) {
                            onPlaylistDeleted?.call();
                            await libraryController.methods
                                .removePlaylistFromLibrary(playlist.id);
                          }
                        },
                        title: Text(context.localization.deletePlaylist),
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
