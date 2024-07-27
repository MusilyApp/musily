import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/presenter/widgets/app_flex.dart';
import 'package:musily/core/utils/generate_placeholder_string.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
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
import 'package:skeletonizer/skeletonizer.dart';

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
              return ListView(
                children: [
                  libraryController.builder(
                    builder: (context, data) {
                      if (data.loading) {
                        final loadingPlaceholderItems = List.filled(
                          4,
                          LibraryTile(
                            item: LibraryItemEntity(
                              id: 'id',
                              lastTimePlayed: DateTime.now(),
                              value: PlaylistEntity(
                                id: 'id',
                                title: 'title',
                                tracks: [],
                              ),
                            ),
                            coreController: coreController,
                            playerController: playerController,
                            getAlbumUsecase: getAlbumUsecase,
                            downloaderController: downloaderController,
                            getPlayableItemUsecase: getPlayableItemUsecase,
                            libraryController: libraryController,
                            getPlaylistUsecase: getPlaylistUsecase,
                            getArtistUsecase: getArtistUsecase,
                            getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                            getArtistTracksUsecase: getArtistTracksUsecase,
                            getArtistSinglesUsecase: getArtistSinglesUsecase,
                          ),
                        );
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                            bottom: 26,
                            left: 8,
                            right: 8,
                          ),
                          child: Skeletonizer(
                            child: AppFlex(
                              maxItemsPerRow: 2,
                              children: loadingPlaceholderItems,
                            ),
                          ),
                        );
                      }
                      if (data.items.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: DottedBorder(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(
                                  .2,
                                ),
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(12),
                            padding: const EdgeInsets.all(12),
                            strokeWidth: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.library_music_rounded,
                                      size: 70,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(
                                            .6,
                                          ),
                                    ),
                                    Text(
                                      'Sua bibilioteca está vazia',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withOpacity(
                                              .6,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                            child: Builder(builder: (context) {
                              final items = data.items.length < 4
                                  ? data.items
                                  : (data.items
                                        ..sort(
                                          (a, b) => b.lastTimePlayed.compareTo(
                                            a.lastTimePlayed,
                                          ),
                                        ))
                                      .sublist(0, 4);
                              return AppFlex(
                                maxItemsPerRow: 2,
                                children: [
                                  ...items.map(
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
                                      getPlaylistUsecase: getPlaylistUsecase,
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
                              );
                            }),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  Builder(
                    builder: (context) {
                      if (dataSections.loadingSections) {
                        final loadingPlaceholderItems = List.generate(
                          5,
                          (index) => Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      bottom: 16,
                                    ),
                                    child: Text(
                                      generatePlaceholderString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 275,
                                child: Builder(builder: (context) {
                                  return ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: List.filled(
                                      6,
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Card(
                                              child: SizedBox(
                                                height: 200,
                                                width: 200,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Album Title',
                                                  ),
                                                  Text(
                                                    '2000',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        );
                        return Skeletonizer(
                          child: Column(
                            children: loadingPlaceholderItems,
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
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 275,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
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
                                                if (content is PlaylistEntity) {
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
              );
            },
          ),
        );
      },
    );
  }
}
