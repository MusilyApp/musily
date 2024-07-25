import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/presenter/widgets/app_flex.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';
import 'package:musily/features/_sections_module/presenter/widgets/library_tile.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/widgets/square_album_tile.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/widgets/square_playlist_tile.dart';

class SectionsPage extends StatelessWidget {
  final SectionsController sectionsController;
  final CoreController coreController;
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const SectionsPage({
    required this.sectionsController,
    required this.coreController,
    required this.playerController,
    required this.getAlbumUsecase,
    required this.getPlaylistUsecase,
    super.key,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
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
      builder: (context, data) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Musily'),
          ),
          body: sectionsController.builder(
            builder: (context, dataSections) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    libraryController.builder(
                      builder: (context, data) {
                        if (data.loading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 24,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (dataSections.sections.isEmpty &&
                            data.items.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.album_rounded,
                                  size: 70,
                                  color: Theme.of(context)
                                      .iconTheme
                                      .color
                                      ?.withOpacity(.6),
                                ),
                                const Text('Sem conteúdo'),
                              ],
                            ),
                          );
                        }
                        if (data.items.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 12,
                              bottom: 26,
                              left: 8,
                              right: 8,
                            ),
                            child: Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.01),
                              child: AppFlex(
                                maxItemsPerRow: 2,
                                children: [
                                  ...(data.items
                                        ..sort(
                                          (a, b) => b.lastTimePlayed.compareTo(
                                            a.lastTimePlayed,
                                          ),
                                        ))
                                      .sublist(0, 4)
                                      .map(
                                        (item) => LibraryTile(
                                          coreController: coreController,
                                          playerController: playerController,
                                          downloaderController:
                                              downloaderController,
                                          getPlayableItemUsecase:
                                              getPlayableItemUsecase,
                                          libraryController: libraryController,
                                          item: item,
                                          getAlbumUsecase: getAlbumUsecase,
                                          getPlaylistUsecase:
                                              getPlaylistUsecase,
                                          getArtistUsecase: getArtistUsecase,
                                          getArtistAlbumsUsecase:
                                              getArtistAlbumsUsecase,
                                          getArtistTracksUsecase:
                                              getArtistTracksUsecase,
                                          getArtistSinglesUsecase:
                                              getArtistSinglesUsecase,
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                    Builder(
                      builder: (context) {
                        if (dataSections.loadingSections) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 24,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            ...dataSections.sections.map(
                              (section) => Column(
                                children: section.content.isEmpty
                                    ? []
                                    : [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                bottom: 16,
                                              ),
                                              child: Text(
                                                section.title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              ...section.content.map(
                                                (content) {
                                                  if (content is AlbumEntity) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 12,
                                                      ),
                                                      child: SquareAlbumTile(
                                                        album: content,
                                                        coreController:
                                                            coreController,
                                                        getAlbumUsecase:
                                                            getAlbumUsecase,
                                                        downloaderController:
                                                            downloaderController,
                                                        getPlayableItemUsecase:
                                                            getPlayableItemUsecase,
                                                        libraryController:
                                                            libraryController,
                                                        playerController:
                                                            playerController,
                                                        getArtistAlbumsUsecase:
                                                            getArtistAlbumsUsecase,
                                                        getArtistSinglesUsecase:
                                                            getArtistSinglesUsecase,
                                                        getArtistTracksUsecase:
                                                            getArtistTracksUsecase,
                                                        getArtistUsecase:
                                                            getArtistUsecase,
                                                      ),
                                                    );
                                                  }
                                                  if (content
                                                      is PlaylistEntity) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 12,
                                                      ),
                                                      child: SquarePlaylistTile(
                                                        playlist: content,
                                                        coreController:
                                                            coreController,
                                                        getPlaylistUsecase:
                                                            getPlaylistUsecase,
                                                        downloaderController:
                                                            downloaderController,
                                                        getPlayableItemUsecase:
                                                            getPlayableItemUsecase,
                                                        libraryController:
                                                            libraryController,
                                                        playerController:
                                                            playerController,
                                                        getAlbumUsecase:
                                                            getAlbumUsecase,
                                                        getArtistAlbumsUsecase:
                                                            getArtistAlbumsUsecase,
                                                        getArtistSinglesUsecase:
                                                            getArtistSinglesUsecase,
                                                        getArtistTracksUsecase:
                                                            getArtistTracksUsecase,
                                                        getArtistUsecase:
                                                            getArtistUsecase,
                                                      ),
                                                    );
                                                  }
                                                  return Container();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    playerController.builder(
                      builder: (context, data) {
                        if (data.currentPlayingItem != null) {
                          return const SizedBox(
                            height: 75,
                          );
                        }
                        return Container();
                      },
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
