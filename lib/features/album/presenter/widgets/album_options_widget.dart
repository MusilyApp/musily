import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musily/core/domain/entities/app_menu_entry.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/buttons/ly_tonal_icon_button.dart';
import 'package:musily/core/presenter/widgets/app_menu.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlbumOptions extends StatelessWidget {
  final AlbumEntity album;
  final CoreController coreController;
  final void Function()? onFocus;
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final LibraryController libraryController;
  final bool tonal;

  const AlbumOptions({
    super.key,
    required this.album,
    required this.coreController,
    required this.playerController,
    required this.getAlbumUsecase,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
    required this.libraryController,
    this.onFocus,
    this.tonal = false,
  });

  @override
  Widget build(BuildContext context) {
    return playerController.builder(builder: (context, playerData) {
      final isAlbumPlaying = playerData.playingId == album.id;
      return downloaderController.builder(builder: (context, downloaderData) {
        final isAlbumDownloading = downloaderData.queue.isNotEmpty &&
            downloaderData.downloadingKey == album.id;
        return AppMenu(
          entries: [
            AppMenuEntry(
              onTap: () {
                if (isAlbumDownloading) {
                  libraryController.methods.cancelCollectionDownload(
                    album.tracks,
                    album.id,
                  );
                } else {
                  libraryController.methods.downloadCollection(
                    album.tracks,
                    album.id,
                  );
                }
              },
              leading: Icon(
                isAlbumDownloading
                    ? Icons.cancel_rounded
                    : Icons.download_rounded,
                color: Theme.of(context).buttonTheme.colorScheme?.primary,
              ),
              title: Text(
                isAlbumDownloading
                    ? AppLocalizations.of(context)!.cancelDownload
                    : AppLocalizations.of(context)!.download,
              ),
            ),
            AppMenuEntry(
              onTap: () async {
                if (isAlbumPlaying) {
                  if (playerData.isPlaying) {
                    await playerController.methods.pause();
                  } else {
                    await playerController.methods.resume();
                  }
                } else {
                  await playerController.methods.playPlaylist(
                    [
                      ...album.tracks.map(
                        (track) => TrackModel.toMusilyTrack(track),
                      ),
                    ],
                    album.id,
                    startFrom: 0,
                  );
                  libraryController.methods.updateLastTimePlayed(
                    album.id,
                  );
                }
              },
              leading: Icon(
                isAlbumPlaying && playerData.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Theme.of(context).buttonTheme.colorScheme?.primary,
              ),
              title: Text(
                isAlbumPlaying && playerData.isPlaying
                    ? AppLocalizations.of(context)!.pause
                    : AppLocalizations.of(context)!.play,
              ),
            ),
            AppMenuEntry(
              onTap: () async {
                final random = Random();
                final randomIndex = random.nextInt(
                  album.tracks.length,
                );
                playerController.methods.playPlaylist(
                  [
                    ...album.tracks.map(
                      (element) => TrackModel.toMusilyTrack(element),
                    ),
                  ],
                  album.id,
                  startFrom: randomIndex,
                );
                if (!playerData.shuffleEnabled) {
                  playerController.methods.toggleShuffle();
                } else {
                  await playerController.methods.toggleShuffle();
                  playerController.methods.toggleShuffle();
                }
                libraryController.methods.updateLastTimePlayed(
                  album.id,
                );
              },
              leading: Icon(
                Icons.shuffle_rounded,
                color: Theme.of(context).buttonTheme.colorScheme?.primary,
              ),
              title: Text(
                AppLocalizations.of(context)!.shufflePlay,
              ),
            ),
            AppMenuEntry(
              onTap: () {
                playerController.methods.addToQueue(
                  [
                    ...album.tracks.map(
                      (track) => TrackModel.toMusilyTrack(track),
                    ),
                  ],
                );
              },
              leading: Icon(
                Icons.playlist_add,
                color: Theme.of(context).buttonTheme.colorScheme?.primary,
              ),
              title: Text(
                AppLocalizations.of(context)!.addToQueue,
                style: const TextStyle(
                  color: null,
                ),
              ),
            ),
          ],
          coreController: coreController,
          toggler: (context, invoke) {
            if (tonal) {
              return LyTonalIconButton(
                onPressed: invoke,
                fixedSize: const Size(55, 55),
                onFocus: onFocus,
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
        );
      });
    });
  }
}
