import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_text_field.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/empty_state.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';
import 'package:musily/features/album/presenter/widgets/album_item.dart';
import 'package:musily/features/artist/presenter/widgets/artist_item.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ResultsPage extends StatefulWidget {
  final String searchQuery;
  final ResultsPageController resultsPageController;
  final CoreController coreController;
  final GetAlbumUsecase getAlbumUsecase;
  final LibraryController libraryController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistUsecase getArtistUsecase;
  final PlayerController playerController;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;

  const ResultsPage({
    required this.searchQuery,
    required this.resultsPageController,
    required this.getAlbumUsecase,
    required this.coreController,
    required this.libraryController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getArtistUsecase,
    required this.playerController,
    super.key,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchTextController.text = widget.searchQuery;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = widget.resultsPageController;
      if (!ctrl.data.keepSearchArtistState) {
        ctrl.methods.searchArtists(widget.searchQuery);
      }
      if (!ctrl.data.keepSearchAlbumState) {
        ctrl.methods.searchAlbums(widget.searchQuery);
      }
      if (!ctrl.data.keepSearchTrackState) {
        ctrl.methods.searchTracks(widget.searchQuery, limit: 15, page: 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'SearchResultsPage',
      child: Scaffold(
        appBar: MusilyAppBar(
          height: 70,
          surfaceTintColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: LyTextField(
                    density: LyDensity.dense,
                    prefixIcon: const Icon(LucideIcons.search),
                    onFocus: () {
                      Navigator.pop(context, 'edit');
                    },
                    controller: searchTextController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(300),
                    onTap: () {
                      Navigator.pop(context, 'clear');
                    },
                    child: const Icon(LucideIcons.x),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: widget.resultsPageController.builder(
          allowAlertDialog: true,
          builder: (context, data) {
            final hasTracks = data.tracksResult.items.isNotEmpty;
            final hasAlbums = data.albumsResult.items.isNotEmpty;
            final hasArtists = data.artistsResult.items.isNotEmpty;
            final isSearching = data.searchingTracks ||
                data.searchingAlbums ||
                data.searchingArtists;

            if (!isSearching && !hasTracks && !hasAlbums && !hasArtists) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    EmptyState(
                      icon: const Icon(LucideIcons.scanSearch, size: 50),
                      title: context.localization.noResults,
                      message: context.localization.tryDifferentKeywords,
                    ),
                    PlayerSizedBox(
                      playerController: widget.playerController,
                    ),
                  ],
                ),
              );
            }

            return ListView(
              children: [
                if (hasArtists || isSearching) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: context.themeData.colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          context.localization.artists,
                          style: context.themeData.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 170,
                    child: Skeletonizer(
                      enabled: isSearching,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount:
                            isSearching ? 8 : data.artistsResult.items.length,
                        itemBuilder: (context, index) {
                          final fakeArtists = List<ArtistEntity>.generate(
                            8,
                            (index) => ArtistEntity(
                              name: 'Fake Artist',
                              id: 'fake_$index',
                            ),
                          );
                          final artist = isSearching
                              ? fakeArtists[index]
                              : data.artistsResult.items[index];
                          return ArtistItem(
                            artist: artist,
                            onTap: () {
                              LyNavigator.push(
                                context.showingPageContext,
                                artist.topTracks.isEmpty
                                    ? AsyncArtistPage(
                                        artistId: artist.id,
                                        coreController: widget.coreController,
                                        playerController:
                                            widget.playerController,
                                        downloaderController:
                                            widget.downloaderController,
                                        getPlayableItemUsecase:
                                            widget.getPlayableItemUsecase,
                                        libraryController:
                                            widget.libraryController,
                                        getAlbumUsecase: widget.getAlbumUsecase,
                                        getArtistUsecase:
                                            widget.getArtistUsecase,
                                        getPlaylistUsecase:
                                            widget.getPlaylistUsecase,
                                        getArtistAlbumsUsecase:
                                            widget.getArtistAlbumsUsecase,
                                        getArtistTracksUsecase:
                                            widget.getArtistTracksUsecase,
                                        getArtistSinglesUsecase:
                                            widget.getArtistSinglesUsecase,
                                        getTrackUsecase: widget.getTrackUsecase,
                                      )
                                    : ArtistPage(
                                        getTrackUsecase: widget.getTrackUsecase,
                                        getAlbumUsecase: widget.getAlbumUsecase,
                                        artist: artist,
                                        coreController: widget.coreController,
                                        playerController:
                                            widget.playerController,
                                        getPlaylistUsecase:
                                            widget.getPlaylistUsecase,
                                        downloaderController:
                                            widget.downloaderController,
                                        getPlayableItemUsecase:
                                            widget.getPlayableItemUsecase,
                                        libraryController:
                                            widget.libraryController,
                                        getArtistUsecase:
                                            widget.getArtistUsecase,
                                        getArtistAlbumsUsecase:
                                            widget.getArtistAlbumsUsecase,
                                        getArtistTracksUsecase:
                                            widget.getArtistTracksUsecase,
                                        getArtistSinglesUsecase:
                                            widget.getArtistSinglesUsecase,
                                      ),
                              );
                              widget.libraryController.methods
                                  .getLibraryItem(artist.id);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
                if (hasAlbums || isSearching) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: context.themeData.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          context.localization.albums,
                          style: context.themeData.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 170,
                    child: Skeletonizer(
                      enabled: isSearching,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount:
                            isSearching ? 8 : data.albumsResult.items.length,
                        itemBuilder: (context, index) {
                          final fakeAlbums = List.generate(
                            8,
                            (index) => AlbumEntity(
                              id: 'fake_$index',
                              title: 'Fake Album',
                              artist: SimplifiedArtist(id: '', name: ''),
                              tracks: [],
                              year: DateTime.now().year,
                            ),
                          );
                          final album = isSearching
                              ? fakeAlbums[index]
                              : data.albumsResult.items[index];
                          return AlbumItem(
                            album: album,
                            onTap: () {
                              LyNavigator.push(
                                context.showingPageContext,
                                album.tracks.isNotEmpty
                                    ? AlbumPage(
                                        album: album,
                                        getTrackUsecase: widget.getTrackUsecase,
                                        getPlaylistUsecase:
                                            widget.getPlaylistUsecase,
                                        coreController: widget.coreController,
                                        playerController:
                                            widget.playerController,
                                        getAlbumUsecase: widget.getAlbumUsecase,
                                        downloaderController:
                                            widget.downloaderController,
                                        getPlayableItemUsecase:
                                            widget.getPlayableItemUsecase,
                                        libraryController:
                                            widget.libraryController,
                                        getArtistAlbumsUsecase:
                                            widget.getArtistAlbumsUsecase,
                                        getArtistSinglesUsecase:
                                            widget.getArtistSinglesUsecase,
                                        getArtistTracksUsecase:
                                            widget.getArtistTracksUsecase,
                                        getArtistUsecase:
                                            widget.getArtistUsecase,
                                      )
                                    : AsyncAlbumPage(
                                        getTrackUsecase: widget.getTrackUsecase,
                                        albumId: album.id,
                                        getPlaylistUsecase:
                                            widget.getPlaylistUsecase,
                                        coreController: widget.coreController,
                                        playerController:
                                            widget.playerController,
                                        getAlbumUsecase: widget.getAlbumUsecase,
                                        downloaderController:
                                            widget.downloaderController,
                                        getPlayableItemUsecase:
                                            widget.getPlayableItemUsecase,
                                        libraryController:
                                            widget.libraryController,
                                        getArtistAlbumsUsecase:
                                            widget.getArtistAlbumsUsecase,
                                        getArtistSinglesUsecase:
                                            widget.getArtistSinglesUsecase,
                                        getArtistTracksUsecase:
                                            widget.getArtistTracksUsecase,
                                        getArtistUsecase:
                                            widget.getArtistUsecase,
                                      ),
                              );
                              widget.libraryController.methods
                                  .getLibraryItem(album.id);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
                if (hasTracks || isSearching) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: context.themeData.colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          context.localization.songs,
                          style: context.themeData.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...<TrackEntity>[
                    if (isSearching)
                      ...List<TrackEntity>.generate(
                        8,
                        (index) => TrackEntity(
                          id: 'fake_$index',
                          title: 'Fake Track Name',
                          artist: SimplifiedArtist(
                            id: '',
                            name: 'Fake Artist',
                          ),
                          album: SimplifiedAlbum(id: '', title: ''),
                          duration: Duration.zero,
                          hash: '',
                          highResImg: null,
                          lowResImg: null,
                          fromSmartQueue: false,
                        ),
                      )
                    else
                      ...data.tracksResult.items,
                  ].map((track) {
                    return Skeletonizer(
                      enabled: isSearching,
                      child: TrackTile(
                        getTrackUsecase: widget.getTrackUsecase,
                        track: track,
                        getAlbumUsecase: widget.getAlbumUsecase,
                        coreController: widget.coreController,
                        playerController: widget.playerController,
                        getPlaylistUsecase: widget.getPlaylistUsecase,
                        downloaderController: widget.downloaderController,
                        getPlayableItemUsecase: widget.getPlayableItemUsecase,
                        libraryController: widget.libraryController,
                        getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                        getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                        getArtistTracksUsecase: widget.getArtistTracksUsecase,
                        getArtistUsecase: widget.getArtistUsecase,
                      ),
                    );
                  }),
                ],
                PlayerSizedBox(playerController: widget.playerController),
              ],
            );
          },
        ),
      ),
    );
  }
}
