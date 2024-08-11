import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/utils/display_helper.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/playlist_creator.dart';
import 'package:musily/features/_library_module/presenter/widgets/playlist_tile.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/widgets/album_tile.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/widgets/artist_tile.dart';
import 'package:musily/features/downloader/presenter/widgets/offline_icon.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_icon.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/pages/playlist_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LibraryPage extends StatelessWidget {
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final CoreController coreController;
  final LibraryController libraryController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final DownloaderController downloaderController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const LibraryPage({
    required this.playerController,
    required this.getAlbumUsecase,
    required this.coreController,
    required this.libraryController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    super.key,
    required this.getPlaylistUsecase,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return coreController.builder(
      eventListener: (context, event, data) {
        final DisplayHelper displayHelper = DisplayHelper(context);
        if (displayHelper.isDesktop) {
          return;
        }
        if (event.id == 'pushWidget') {
          Navigator.of(context).push(
            DownupRouter(
              builder: (context) => event.data,
            ),
          );
        }
      },
      builder: (context, d) {
        return libraryController.builder(
          builder: (context, data) {
            return downloaderController.builder(builder: (context, dlData) {
              final List<LibraryItemEntity<dynamic>> listClone =
                  List.from(data.items);
              final offlinePlaylist = LibraryItemEntity(
                id: 'offline',
                lastTimePlayed: DateTime.now(),
                value: PlaylistEntity(
                  id: 'offline',
                  title: 'offline',
                  tracks: dlData.queue
                      .map((e) => TrackModel.fromMusilyTrack(e.track))
                      .toList(),
                  trackCount: dlData.queue.length,
                ),
              );
              listClone.insert(
                0,
                offlinePlaylist,
              );
              return Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.library),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  actions: [
                    PlaylistCreator(
                      libraryController,
                      builder: (context, showCreator) => IconButton(
                        onPressed: showCreator,
                        icon: const Icon(
                          Icons.add,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        bool showOffline = offlinePlaylist.value.trackCount > 0;
                        final favoritesPlaylistFiltered =
                            data.items.where((item) => item.id == 'favorites');
                        final favoritesPlaylist = (favoritesPlaylistFiltered
                            .lastOrNull as LibraryItemEntity<PlaylistEntity>?);
                        return Column(
                          children: [
                            if (favoritesPlaylist != null)
                              ListTile(
                                onTap: () => coreController.methods.pushWidget(
                                  favoritesPlaylist.value.tracks.isNotEmpty
                                      ? PlaylistPage(
                                          playlist: favoritesPlaylist.value,
                                          playerController: playerController,
                                          coreController: coreController,
                                          downloaderController:
                                              downloaderController,
                                          getPlayableItemUsecase:
                                              getPlayableItemUsecase,
                                          libraryController: libraryController,
                                          getAlbumUsecase: getAlbumUsecase,
                                          getPlaylistUsecase:
                                              getPlaylistUsecase,
                                          getArtistAlbumsUsecase:
                                              getArtistAlbumsUsecase,
                                          getArtistSinglesUsecase:
                                              getArtistSinglesUsecase,
                                          getArtistTracksUsecase:
                                              getArtistTracksUsecase,
                                          getArtistUsecase: getArtistUsecase,
                                        )
                                      : AsyncPlaylistPage(
                                          getPlaylistUsecase:
                                              getPlaylistUsecase,
                                          playlistId: favoritesPlaylist.id,
                                          coreController: coreController,
                                          playerController: playerController,
                                          downloaderController:
                                              downloaderController,
                                          getPlayableItemUsecase:
                                              getPlayableItemUsecase,
                                          libraryController: libraryController,
                                          getAlbumUsecase: getAlbumUsecase,
                                          getArtistUsecase: getArtistUsecase,
                                          getArtistTracksUsecase:
                                              getArtistTracksUsecase,
                                          getArtistAlbumsUsecase:
                                              getArtistAlbumsUsecase,
                                          getArtistSinglesUsecase:
                                              getArtistSinglesUsecase,
                                        ),
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: const FavoriteIcon(
                                    size: 50,
                                  ),
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.favorites,
                                ),
                                subtitle: Text(
                                  '${favoritesPlaylist.value.trackCount} ${AppLocalizations.of(context)!.songs}',
                                ),
                              ),
                            if (showOffline)
                              ListTile(
                                onTap: () => coreController.methods.pushWidget(
                                  offlinePlaylist.value.tracks.isNotEmpty
                                      ? PlaylistPage(
                                          playlist: offlinePlaylist.value,
                                          playerController: playerController,
                                          coreController: coreController,
                                          downloaderController:
                                              downloaderController,
                                          getPlayableItemUsecase:
                                              getPlayableItemUsecase,
                                          libraryController: libraryController,
                                          getAlbumUsecase: getAlbumUsecase,
                                          getPlaylistUsecase:
                                              getPlaylistUsecase,
                                          getArtistAlbumsUsecase:
                                              getArtistAlbumsUsecase,
                                          getArtistSinglesUsecase:
                                              getArtistSinglesUsecase,
                                          getArtistTracksUsecase:
                                              getArtistTracksUsecase,
                                          getArtistUsecase: getArtistUsecase,
                                        )
                                      : AsyncPlaylistPage(
                                          getPlaylistUsecase:
                                              getPlaylistUsecase,
                                          playlistId: offlinePlaylist.id,
                                          coreController: coreController,
                                          playerController: playerController,
                                          downloaderController:
                                              downloaderController,
                                          getPlayableItemUsecase:
                                              getPlayableItemUsecase,
                                          libraryController: libraryController,
                                          getAlbumUsecase: getAlbumUsecase,
                                          getArtistUsecase: getArtistUsecase,
                                          getArtistTracksUsecase:
                                              getArtistTracksUsecase,
                                          getArtistAlbumsUsecase:
                                              getArtistAlbumsUsecase,
                                          getArtistSinglesUsecase:
                                              getArtistSinglesUsecase,
                                        ),
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: const OfflineIcon(
                                    size: 50,
                                  ),
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.offline,
                                ),
                                subtitle: Text(
                                  '${offlinePlaylist.value.trackCount} ${AppLocalizations.of(context)!.songs}',
                                ),
                              ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                    if (listClone
                        .where((item) =>
                            item.id != 'favorites' || item.id != 'offline')
                        .isEmpty)
                      playerController.builder(builder: (context, data) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          height: MediaQuery.of(context).size.height -
                              (data.currentPlayingItem != null ? 373 : 305),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.library_music_rounded,
                                  size: 70,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outline
                                      .withOpacity(.9),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.emptyLibrary,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withOpacity(.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    else
                      Expanded(
                        child: ListView(
                          children: [
                            ...listClone
                                .where((item) =>
                                    item.id != 'favorites' &&
                                    item.id != 'offline')
                                .map(
                                  (item) => Builder(
                                    builder: (context) {
                                      if (item.value is AlbumEntity) {
                                        return AlbumTile(
                                          album: item.value,
                                          coreController: coreController,
                                          playerController: playerController,
                                          getAlbumUsecase: getAlbumUsecase,
                                          downloaderController:
                                              downloaderController,
                                          getPlayableItemUsecase:
                                              getPlayableItemUsecase,
                                          libraryController: libraryController,
                                          getArtistAlbumsUsecase:
                                              getArtistAlbumsUsecase,
                                          getArtistSinglesUsecase:
                                              getArtistSinglesUsecase,
                                          getArtistTracksUsecase:
                                              getArtistTracksUsecase,
                                          getArtistUsecase: getArtistUsecase,
                                        );
                                      }
                                      if (item.value is PlaylistEntity) {
                                        return PlaylistTile(
                                          playlist: item.value,
                                          libraryController: libraryController,
                                          playerController: playerController,
                                          getAlbumUsecase: getAlbumUsecase,
                                          coreController: coreController,
                                          downloaderController:
                                              downloaderController,
                                          getPlayableItemUsecase:
                                              getPlayableItemUsecase,
                                          getPlaylistUsecase:
                                              getPlaylistUsecase,
                                          getArtistAlbumsUsecase:
                                              getArtistAlbumsUsecase,
                                          getArtistSinglesUsecase:
                                              getArtistSinglesUsecase,
                                          getArtistTracksUsecase:
                                              getArtistTracksUsecase,
                                          getArtistUsecase: getArtistUsecase,
                                        );
                                      }
                                      if (item.value is ArtistEntity) {
                                        return ArtistTile(
                                          artist: item.value,
                                          getAlbumUsecase: getAlbumUsecase,
                                          coreController: coreController,
                                          downloaderController:
                                              downloaderController,
                                          getPlayableItemUsecase:
                                              getPlayableItemUsecase,
                                          libraryController: libraryController,
                                          playerController: playerController,
                                          getArtistUsecase: getArtistUsecase,
                                          getArtistAlbumsUsecase:
                                              getArtistAlbumsUsecase,
                                          getArtistTracksUsecase:
                                              getArtistTracksUsecase,
                                          getArtistSinglesUsecase:
                                              getArtistSinglesUsecase,
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ),
                            playerController.builder(
                              builder: (context, data) {
                                if (data.isPlaying) {
                                  return const SizedBox(
                                    height: 70,
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            });
          },
        );
      },
    );
  }
}
