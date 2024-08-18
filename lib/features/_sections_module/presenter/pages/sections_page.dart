import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/presenter/widgets/app_flex.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/core/presenter/widgets/user_avatar.dart';
import 'package:musily/core/utils/display_helper.dart';
import 'package:musily/core/utils/generate_placeholder_string.dart';
import 'package:musily/core/utils/get_theme_mode.dart';
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
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/widgets/square_playlist_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final SettingsController settingsController;

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
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    return coreController.builder(
      eventListener: (context, event, data) {
        if (event.id == 'pushWidget') {
          if (data.pages.length > 1) {
            if (DisplayHelper(context).isDesktop) {
              Navigator.pop(context);
            }
          }
          Navigator.of(context).push(
            DownupRouter(
              builder: (context) => event.data,
            ),
          );
          if (DisplayHelper(context).isDesktop) {
            coreController.updateData(
              data.copyWith(
                pages: [event.data],
              ),
            );
          }
        }
      },
      builder: (context, data) {
        bool isDarkMode = getThemeMode(context) == ThemeMode.dark;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/musily_appbar_icon${isDarkMode ? '_dark' : ''}.svg',
                  width: 40,
                ),
                const SizedBox(
                  width: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Musily',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: isDarkMode
                              ? const Color(0xffe8def7)
                              : const Color(0xff68548f),
                        ),
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  right: 12,
                ),
                child: UserAvatar(
                  coreController: coreController,
                  settingsController: settingsController,
                ),
              ),
            ],
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
                                trackCount: 0,
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
                                      AppLocalizations.of(context)!
                                          .emptyLibrary,
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
                              final displayHelper = DisplayHelper(context);
                              final limit = displayHelper.isDesktop ? 6 : 4;
                              final items = data.items.length < limit
                                  ? data.items
                                  : (data.items
                                        ..sort(
                                          (a, b) => b.lastTimePlayed.compareTo(
                                            a.lastTimePlayed,
                                          ),
                                        ))
                                      .sublist(0, limit);
                              return AppFlex(
                                maxItemsPerRow: displayHelper.isDesktop ? 3 : 2,
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
                  PlayerSizedBox(
                    playerController: playerController,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
