import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
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
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/pages/playlist_page.dart';

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
            return Scaffold(
              appBar: AppBar(
                title: const Text('Bibilioteca'),
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
                      final favoritesPlaylistFiltered =
                          data.items.where((item) => item.id == 'favorites');
                      if (favoritesPlaylistFiltered.isEmpty) {
                        return Container();
                      }
                      final favoritesPlaylist = (favoritesPlaylistFiltered.first
                          as LibraryItemEntity<PlaylistEntity>);
                      if (favoritesPlaylist.value.tracks.isEmpty) {
                        return Container();
                      }
                      return Column(
                        children: [
                          ListTile(
                            onTap: () => Navigator.push(
                              context,
                              DownupRouter(
                                builder: (context) => PlaylistPage(
                                  playlist: favoritesPlaylist.value,
                                  playerController: playerController,
                                  coreController: coreController,
                                  downloaderController: downloaderController,
                                  getPlayableItemUsecase:
                                      getPlayableItemUsecase,
                                  libraryController: libraryController,
                                  getAlbumUsecase: getAlbumUsecase,
                                  getPlaylistUsecase: getPlaylistUsecase,
                                  getArtistAlbumsUsecase:
                                      getArtistAlbumsUsecase,
                                  getArtistSinglesUsecase:
                                      getArtistSinglesUsecase,
                                  getArtistTracksUsecase:
                                      getArtistTracksUsecase,
                                  getArtistUsecase: getArtistUsecase,
                                ),
                              ),
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.transparent,
                                    Theme.of(context)
                                            .buttonTheme
                                            .colorScheme
                                            ?.primary ??
                                        Colors.white,
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            title: const Text('Favoritos'),
                            subtitle: Text(
                              '${favoritesPlaylist.value.tracks.length} músicas',
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...data.items
                              .where((item) => item.id != 'favorites')
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
                                        getPlaylistUsecase: getPlaylistUsecase,
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
