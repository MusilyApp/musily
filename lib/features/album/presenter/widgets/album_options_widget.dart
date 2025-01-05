import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musily/core/domain/entities/app_menu_entry.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/buttons/ly_tonal_icon_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_menu.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/widgets/album_static_tile.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_adder.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class AlbumOptions extends StatelessWidget {
  final AlbumEntity album;
  final CoreController coreController;
  final void Function()? onFocus;
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
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
    required this.getPlaylistUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return playerController.builder(builder: (context, playerData) {
      final isAlbumPlaying = playerData.playingId == album.id;
      return downloaderController.builder(builder: (context, downloaderData) {
        final isAlbumDownloading = downloaderData.queue.isNotEmpty &&
            downloaderData.downloadingKey == album.id;
        return libraryController.builder(builder: (context, libraryData) {
          final isAlbumInLibrary = libraryData.items
              .where((e) => e.album?.id == album.id)
              .isNotEmpty;
          return AppMenu(
            modalHeader: AlbumStaticTile(album: album),
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
                  color: context.themeData.buttonTheme.colorScheme?.primary,
                ),
                title: Text(
                  isAlbumDownloading
                      ? context.localization.cancelDownload
                      : context.localization.download,
                ),
              ),
              AppMenuEntry(
                onTap: () {
                  coreController.updateData(
                    coreController.data.copyWith(
                      isShowingDialog: false,
                    ),
                  );
                  LyNavigator.push(
                    context.showingPageContext,
                    AsyncArtistPage(
                      artistId: album.artist.id,
                      coreController: coreController,
                      playerController: playerController,
                      downloaderController: downloaderController,
                      getPlayableItemUsecase: getPlayableItemUsecase,
                      libraryController: libraryController,
                      getAlbumUsecase: getAlbumUsecase,
                      getArtistUsecase: getArtistUsecase,
                      getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                      getArtistTracksUsecase: getArtistTracksUsecase,
                      getArtistSinglesUsecase: getArtistSinglesUsecase,
                      getPlaylistUsecase: getPlaylistUsecase,
                    ),
                  );
                },
                title: Text(context.localization.goToArtist),
                leading: Icon(
                  Icons.person_rounded,
                  color: context.themeData.buttonTheme.colorScheme?.primary,
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
                        ...album.tracks,
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
                  color: context.themeData.buttonTheme.colorScheme?.primary,
                ),
                title: Text(
                  isAlbumPlaying && playerData.isPlaying
                      ? context.localization.pause
                      : context.localization.play,
                ),
              ),
              AppMenuEntry(
                onTap: () async {
                  final random = Random();
                  final randomIndex = random.nextInt(
                    album.tracks.length,
                  );
                  playerController.methods.playPlaylist(
                    album.tracks,
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
                  color: context.themeData.buttonTheme.colorScheme?.primary,
                ),
                title: Text(
                  context.localization.shufflePlay,
                ),
              ),
              AppMenuEntry(
                onTap: () async {
                  late final List<TrackEntity> tracksToAdd;
                  if (album.tracks.isEmpty) {
                    final asyncAlbum = await getAlbumUsecase.exec(album.id);
                    tracksToAdd = asyncAlbum?.tracks ?? [];
                  } else {
                    tracksToAdd = album.tracks;
                  }
                  playerController.methods.addToQueue(tracksToAdd);
                },
                leading: Icon(
                  Icons.playlist_add,
                  color: context.themeData.buttonTheme.colorScheme?.primary,
                ),
                title: Text(
                  context.localization.addToQueue,
                  style: const TextStyle(
                    color: null,
                  ),
                ),
              ),
              AppMenuEntry(
                leading: Icon(
                  Icons.queue_music,
                  color: context.themeData.buttonTheme.colorScheme?.primary,
                ),
                title: Text(
                  context.localization.addToPlaylist,
                ),
                onTap: () {
                  LyNavigator.push(
                    coreController.coreContext!,
                    PlaylistAdderWidget(
                      coreController: coreController,
                      getPlaylistUsecase: getPlaylistUsecase,
                      asyncTracks: () async {
                        final asyncAlbum = await getAlbumUsecase.exec(album.id);
                        final tracks = asyncAlbum?.tracks ?? [];
                        return tracks;
                      },
                      libraryController: libraryController,
                      tracks: album.tracks,
                    ),
                  );
                },
              ),
              AppMenuEntry(
                onTap: () async {
                  if (isAlbumInLibrary) {
                    await libraryController.methods.removeAlbumFromLibrary(
                      album.id,
                    );
                  } else {
                    await libraryController.methods.addAlbumToLibrary(
                      album,
                    );
                  }
                },
                leading: Icon(
                  isAlbumInLibrary
                      ? Icons.delete_rounded
                      : Icons.library_add_rounded,
                  color: context.themeData.buttonTheme.colorScheme?.primary,
                ),
                title: Text(
                  isAlbumInLibrary
                      ? context.localization.removeFromLibrary
                      : context.localization.addToLibrary,
                ),
              ),
              AppMenuEntry(
                onTap: () {
                  coreController.methods.shareAlbum(album);
                },
                leading: Icon(
                  Icons.share_rounded,
                  color: Theme.of(context).buttonTheme.colorScheme?.primary,
                ),
                title: Text(context.localization.share),
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
    });
  }
}
