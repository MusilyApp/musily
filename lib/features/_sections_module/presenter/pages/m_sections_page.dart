import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_flex.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/core/utils/generate_placeholder_string.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';
import 'package:musily/features/_sections_module/presenter/widgets/library_tile.dart';
import 'package:musily/features/_sections_module/presenter/widgets/recommended_track_tile.dart';
import 'package:musily/features/_sections_module/presenter/widgets/vertical_track_tile.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/album/presenter/widgets/album_item.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/playlist/presenter/pages/playlist_page.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_item.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:responsive_breakpoint/core/responsive_value.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MSectionsPage extends StatelessWidget {
  final SectionsController sectionsController;
  final LibraryController libraryController;
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final CoreController coreController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;

  const MSectionsPage({
    super.key,
    required this.sectionsController,
    required this.libraryController,
    required this.playerController,
    required this.getAlbumUsecase,
    required this.getPlaylistUsecase,
    required this.getArtistUsecase,
    required this.coreController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
    required this.getTrackUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return playerController.builder(
      builder: (context, playerData) {
        return sectionsController.builder(
          builder: (context, dataSections) {
            return Stack(
              children: [
                // Background with artwork
                if (playerData.currentPlayingItem != null &&
                    playerData.currentPlayingItem!.highResImg != null &&
                    playerData.currentPlayingItem!.highResImg!.isNotEmpty)
                  Positioned.fill(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AppImage(
                          playerData.currentPlayingItem!.highResImg!,
                          fit: BoxFit.cover,
                        ),
                        // Dark overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                context.themeData.scaffoldBackgroundColor
                                    .withValues(alpha: 1),
                                context.themeData.scaffoldBackgroundColor
                                    .withValues(alpha: 0.8),
                                context.themeData.scaffoldBackgroundColor
                                    .withValues(alpha: 0.9),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Content
                RefreshIndicator(
                  onRefresh: () async {
                    libraryController.methods.getLibraryItems();
                    await sectionsController.methods.getSections();
                    await sectionsController.methods.generateRecommendations();
                  },
                  child: ListView(
                    children: [
                      libraryController.builder(
                        builder: (context, data) {
                          if (data.loading) {
                            final loadingPlaceholderItems = List.filled(
                              context.display.isDesktop ? 6 : 4,
                              LibraryTile(
                                getTrackUsecase: getTrackUsecase,
                                item: LibraryItemEntity(
                                  id: 'id',
                                  synced: false,
                                  lastTimePlayed: DateTime.now(),
                                  playlist: PlaylistEntity(
                                    id: 'id',
                                    title: 'title',
                                    trackCount: 0,
                                    tracks: [],
                                  ),
                                  createdAt: DateTime.now(),
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
                                getArtistSinglesUsecase:
                                    getArtistSinglesUsecase,
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
                                  maxItemsPerRow:
                                      context.display.isDesktop ? 3 : 2,
                                  children: loadingPlaceholderItems,
                                ),
                              ),
                            );
                          }
                          if (data.items.isEmpty) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: context.themeData.colorScheme
                                    .surfaceContainerHighest
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: context.themeData.colorScheme.outline
                                      .withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    LucideIcons.library,
                                    size: 48,
                                    color: context.themeData.colorScheme.primary
                                        .withValues(alpha: 0.6),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    context.localization.emptyLibrary,
                                    style: context
                                        .themeData.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: context
                                          .themeData.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    context
                                        .localization.emptyLibraryDescription,
                                    style: context
                                        .themeData.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: context
                                          .themeData.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
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
                                color: context.themeData.colorScheme.primary
                                    .withValues(alpha: .01),
                                child: Builder(
                                  builder: (context) {
                                    final limit =
                                        context.display.isDesktop ? 6 : 4;
                                    final items = data.items.length < limit
                                        ? data.items
                                        : data.items.sublist(0, limit);
                                    return AppFlex(
                                      spacing: AppFlexSpacing.all(8),
                                      maxItemsPerRow:
                                          context.display.isDesktop ? 3 : 2,
                                      children: [
                                        ...items.map(
                                          (item) => LibraryTile(
                                            getTrackUsecase: getTrackUsecase,
                                            coreController: coreController,
                                            playerController: playerController,
                                            downloaderController:
                                                downloaderController,
                                            getPlayableItemUsecase:
                                                getPlayableItemUsecase,
                                            libraryController:
                                                libraryController,
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
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                      if (dataSections.carouselRecommendedTracks.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                top: 16,
                                bottom: 12,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color:
                                          context.themeData.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    context.localization.recommendedMusic,
                                    style: context
                                        .themeData.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: SizedBox(
                                height: 140,
                                child: CarouselView.weighted(
                                  flexWeights: context.responsive(
                                          ResponsiveValue(
                                              sm: [8, 1], md: [4, 4])) ??
                                      [8, 1],
                                  onTap: null,
                                  enableSplash: false,
                                  shrinkExtent: 200,
                                  padding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  children: [
                                    ...dataSections.carouselRecommendedTracks
                                        .map((model) {
                                      return RecommendedTrackTile(
                                        recommendation: model,
                                        sectionsController: sectionsController,
                                        playerController: playerController,
                                        libraryController: libraryController,
                                        downloaderController:
                                            downloaderController,
                                        coreController: coreController,
                                        getPlayableItemUsecase:
                                            getPlayableItemUsecase,
                                        getAlbumUsecase: getAlbumUsecase,
                                        getPlaylistUsecase: getPlaylistUsecase,
                                        getArtistUsecase: getArtistUsecase,
                                        getArtistAlbumsUsecase:
                                            getArtistAlbumsUsecase,
                                        getArtistTracksUsecase:
                                            getArtistTracksUsecase,
                                        getArtistSinglesUsecase:
                                            getArtistSinglesUsecase,
                                        getTrackUsecase: getTrackUsecase,
                                        backgroundColor: model.backgroundColor,
                                        textColor: model.textColor,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (dataSections.gridRecommendedTracks.isNotEmpty) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                top: 32,
                                bottom: 12,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: context
                                          .themeData.colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    context.localization.moreRecommendations,
                                    style: context
                                        .themeData.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.35,
                                ),
                                itemCount:
                                    dataSections.gridRecommendedTracks.length,
                                itemBuilder: (context, index) {
                                  final recommendation =
                                      dataSections.gridRecommendedTracks[index];
                                  return VerticalTrackTile(
                                    recommendation: recommendation,
                                    sectionsController: sectionsController,
                                    playerController: playerController,
                                    libraryController: libraryController,
                                    downloaderController: downloaderController,
                                    coreController: coreController,
                                    getPlayableItemUsecase:
                                        getPlayableItemUsecase,
                                    getAlbumUsecase: getAlbumUsecase,
                                    getPlaylistUsecase: getPlaylistUsecase,
                                    getArtistUsecase: getArtistUsecase,
                                    getArtistAlbumsUsecase:
                                        getArtistAlbumsUsecase,
                                    getArtistTracksUsecase:
                                        getArtistTracksUsecase,
                                    getArtistSinglesUsecase:
                                        getArtistSinglesUsecase,
                                    getTrackUsecase: getTrackUsecase,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
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
                                          style: context
                                              .themeData.textTheme.headlineSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 275,
                                    child: Builder(
                                      builder: (context) {
                                        return ListView(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Album Title'),
                                                        Text('2000'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                            return Skeletonizer(
                              child: Column(children: loadingPlaceholderItems),
                            );
                          }
                          return Column(
                            children: [
                              ...dataSections.sections.map(
                                (section) => Column(
                                  children: section.content.isEmpty
                                      ? []
                                      : [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 16,
                                              bottom: 12,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 4,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: context.themeData
                                                        .colorScheme.tertiary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: InfinityMarquee(
                                                    child: Text(
                                                      section.title,
                                                      style: context
                                                          .themeData
                                                          .textTheme
                                                          .headlineSmall
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        letterSpacing: -0.5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 160,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                ...section.content.map((
                                                  content,
                                                ) {
                                                  if (content is AlbumEntity) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 12,
                                                      ),
                                                      child: AlbumItem(
                                                        album: content,
                                                        onTap: () {
                                                          LyNavigator.push(
                                                            context
                                                                .showingPageContext,
                                                            content.tracks
                                                                    .isNotEmpty
                                                                ? AlbumPage(
                                                                    album:
                                                                        content,
                                                                    getTrackUsecase:
                                                                        getTrackUsecase,
                                                                    getPlaylistUsecase:
                                                                        getPlaylistUsecase,
                                                                    coreController:
                                                                        coreController,
                                                                    playerController:
                                                                        playerController,
                                                                    getAlbumUsecase:
                                                                        getAlbumUsecase,
                                                                    downloaderController:
                                                                        downloaderController,
                                                                    getPlayableItemUsecase:
                                                                        getPlayableItemUsecase,
                                                                    libraryController:
                                                                        libraryController,
                                                                    getArtistAlbumsUsecase:
                                                                        getArtistAlbumsUsecase,
                                                                    getArtistSinglesUsecase:
                                                                        getArtistSinglesUsecase,
                                                                    getArtistTracksUsecase:
                                                                        getArtistTracksUsecase,
                                                                    getArtistUsecase:
                                                                        getArtistUsecase,
                                                                  )
                                                                : AsyncAlbumPage(
                                                                    getTrackUsecase:
                                                                        getTrackUsecase,
                                                                    albumId:
                                                                        content
                                                                            .id,
                                                                    getPlaylistUsecase:
                                                                        getPlaylistUsecase,
                                                                    coreController:
                                                                        coreController,
                                                                    playerController:
                                                                        playerController,
                                                                    getAlbumUsecase:
                                                                        getAlbumUsecase,
                                                                    downloaderController:
                                                                        downloaderController,
                                                                    getPlayableItemUsecase:
                                                                        getPlayableItemUsecase,
                                                                    libraryController:
                                                                        libraryController,
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
                                                          libraryController
                                                              .methods
                                                              .getLibraryItem(
                                                            content.id,
                                                          );
                                                        },
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
                                                      child: PlaylistItem(
                                                        playlist: content,
                                                        onTap: () {
                                                          LyNavigator.push(
                                                            context
                                                                .showingPageContext,
                                                            content.tracks
                                                                    .isEmpty
                                                                ? AsyncPlaylistPage(
                                                                    getTrackUsecase:
                                                                        getTrackUsecase,
                                                                    getPlaylistUsecase:
                                                                        getPlaylistUsecase,
                                                                    origin: ContentOrigin
                                                                        .dataFetch,
                                                                    playlistId:
                                                                        content
                                                                            .id,
                                                                    coreController:
                                                                        coreController,
                                                                    playerController:
                                                                        playerController,
                                                                    downloaderController:
                                                                        downloaderController,
                                                                    getPlayableItemUsecase:
                                                                        getPlayableItemUsecase,
                                                                    libraryController:
                                                                        libraryController,
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
                                                                  )
                                                                : PlaylistPage(
                                                                    getTrackUsecase:
                                                                        getTrackUsecase,
                                                                    getPlaylistUsecase:
                                                                        getPlaylistUsecase,
                                                                    playlist:
                                                                        content,
                                                                    coreController:
                                                                        coreController,
                                                                    playerController:
                                                                        playerController,
                                                                    downloaderController:
                                                                        downloaderController,
                                                                    getPlayableItemUsecase:
                                                                        getPlayableItemUsecase,
                                                                    libraryController:
                                                                        libraryController,
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
                                                        },
                                                      ),
                                                    );
                                                  }
                                                  return Container();
                                                }),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 32),
                                        ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
