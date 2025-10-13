import 'package:flutter/material.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/core/utils/generate_placeholder_string.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/pages/backup_page.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_creator.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_tile.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/widgets/album_tile.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/widgets/artist_tile.dart';
import 'package:musily/features/downloader/presenter/widgets/offline_icon.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/pages/playlist_page.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class LibraryPage extends StatefulWidget {
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
  final GetTrackUsecase getTrackUsecase;

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
    required this.getTrackUsecase,
  });

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Set<String> filters = {};

  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'LibraryPage',
      ignoreFromStack: context.display.isDesktop,
      child: widget.libraryController.builder(
        builder: (context, data) {
          return widget.downloaderController.builder(
            builder: (context, dlData) {
              final List<LibraryItemEntity> listClone = List.from(data.items);
              final offlinePlaylist = LibraryItemEntity(
                id: 'offline',
                synced: false,
                lastTimePlayed: DateTime.now(),
                playlist: PlaylistEntity(
                  id: 'offline',
                  title: 'offline',
                  tracks: dlData.queue
                      .where((e) => e.status == e.downloadCompleted)
                      .map((e) => e.track)
                      .toList(),
                  trackCount: dlData.queue.length,
                ),
                createdAt: DateTime.now(),
              );
              listClone.insert(
                0,
                offlinePlaylist,
              );
              final albums = listClone.where((e) => e.album != null);
              final playlists = listClone.where((e) => e.playlist != null);
              final artists = listClone.where((e) => e.artist != null);

              final filteredList = <LibraryItemEntity>[
                if (filters.contains('album') || filters.isEmpty) ...albums,
                if (filters.contains('playlist') || filters.isEmpty)
                  ...playlists,
                if (filters.contains('artist') || filters.isEmpty) ...artists,
              ];

              final itemList = (filters.isEmpty || filters.length == 3)
                  ? listClone
                  : filteredList;

              return Scaffold(
                appBar: AppBar(
                  title: Text(context.localization.library),
                  backgroundColor: context.themeData.scaffoldBackgroundColor,
                  surfaceTintColor: context.themeData.scaffoldBackgroundColor,
                  actions: [
                    if (!data.loading)
                      PlaylistCreator(
                        widget.libraryController,
                        getPlaylistUsecase: widget.getPlaylistUsecase,
                        coreController: widget.coreController,
                        builder: (context, showCreator) => IconButton(
                          onPressed: showCreator,
                          icon: const Icon(
                            Icons.add,
                          ),
                        ),
                      ),
                    IconButton(
                      onPressed: () async {
                        LyNavigator.push(
                          context,
                          BackupPage(
                            downloaderController: widget.downloaderController,
                            libraryController: widget.libraryController,
                            coreController: widget.coreController,
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings_backup_restore),
                    ),
                  ],
                ),
                body: RefreshIndicator(
                  onRefresh: () {
                    return widget.libraryController.methods.getLibraryItems();
                  },
                  child: Builder(builder: (context) {
                    if (data.loading) {
                      return ListView(
                        children: [
                          ...List<Widget>.generate(
                            15,
                            (index) => Skeletonizer(
                              child: LyListTile(
                                leading: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      360,
                                    ),
                                    side: BorderSide(
                                      strokeAlign: 1,
                                      color: context.themeData.dividerColor
                                          .withValues(alpha: .1),
                                    ),
                                  ),
                                  child: const SizedBox(
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                title: Text(generatePlaceholderString()),
                                subtitle: Text(generatePlaceholderString()),
                              ),
                            ),
                          ),
                          PlayerSizedBox(
                            playerController: widget.playerController,
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        Builder(
                          builder: (context) {
                            bool showOffline =
                                offlinePlaylist.playlist!.trackCount > 0;
                            return Column(
                              children: [
                                if (showOffline)
                                  LyListTile(
                                    onTap: () => LyNavigator.push(
                                      context.showingPageContext,
                                      offlinePlaylist
                                              .playlist!.tracks.isNotEmpty
                                          ? PlaylistPage(
                                              getTrackUsecase:
                                                  widget.getTrackUsecase,
                                              playlist:
                                                  offlinePlaylist.playlist!,
                                              playerController:
                                                  widget.playerController,
                                              getPlaylistUsecase:
                                                  widget.getPlaylistUsecase,
                                              coreController:
                                                  widget.coreController,
                                              downloaderController:
                                                  widget.downloaderController,
                                              getPlayableItemUsecase:
                                                  widget.getPlayableItemUsecase,
                                              libraryController:
                                                  widget.libraryController,
                                              getAlbumUsecase:
                                                  widget.getAlbumUsecase,
                                              getArtistAlbumsUsecase:
                                                  widget.getArtistAlbumsUsecase,
                                              getArtistSinglesUsecase: widget
                                                  .getArtistSinglesUsecase,
                                              getArtistTracksUsecase:
                                                  widget.getArtistTracksUsecase,
                                              getArtistUsecase:
                                                  widget.getArtistUsecase,
                                            )
                                          : AsyncPlaylistPage(
                                              getTrackUsecase:
                                                  widget.getTrackUsecase,
                                              origin: ContentOrigin.library,
                                              playlistId: offlinePlaylist.id,
                                              coreController:
                                                  widget.coreController,
                                              getPlaylistUsecase:
                                                  widget.getPlaylistUsecase,
                                              playerController:
                                                  widget.playerController,
                                              downloaderController:
                                                  widget.downloaderController,
                                              getPlayableItemUsecase:
                                                  widget.getPlayableItemUsecase,
                                              libraryController:
                                                  widget.libraryController,
                                              getAlbumUsecase:
                                                  widget.getAlbumUsecase,
                                              getArtistUsecase:
                                                  widget.getArtistUsecase,
                                              getArtistTracksUsecase:
                                                  widget.getArtistTracksUsecase,
                                              getArtistAlbumsUsecase:
                                                  widget.getArtistAlbumsUsecase,
                                              getArtistSinglesUsecase: widget
                                                  .getArtistSinglesUsecase,
                                            ),
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: const OfflineIcon(
                                        size: 50,
                                      ),
                                    ),
                                    title: Text(
                                      context.localization.offline,
                                    ),
                                    subtitle: Text(
                                      '${offlinePlaylist.playlist!.trackCount} ${context.localization.songs}',
                                    ),
                                  ),
                                if (showOffline && data.items.isNotEmpty)
                                  const Divider(),
                                if (data.items.isNotEmpty) ...[
                                  SegmentedButton(
                                    emptySelectionAllowed: true,
                                    segments: const [
                                      ButtonSegment(
                                        value: 'album',
                                        label: Icon(
                                          Icons.album_rounded,
                                        ),
                                        icon: Icon(
                                          Icons.filter_alt_rounded,
                                        ),
                                      ),
                                      ButtonSegment(
                                        value: 'artist',
                                        label: Icon(
                                          Icons.person_rounded,
                                        ),
                                        icon: Icon(
                                          Icons.filter_alt_rounded,
                                        ),
                                      ),
                                      ButtonSegment(
                                        value: 'playlist',
                                        label: Icon(
                                          Icons.playlist_play_rounded,
                                        ),
                                        icon: Icon(
                                          Icons.filter_alt_rounded,
                                        ),
                                      ),
                                    ],
                                    selected: filters,
                                    onSelectionChanged: (value) {
                                      setState(() {
                                        filters = value;
                                      });
                                    },
                                    multiSelectionEnabled: true,
                                  ),
                                  const Divider()
                                ],
                              ],
                            );
                          },
                        ),
                        if (data.items
                            .where(
                              (item) => item.id != 'offline',
                            )
                            .isEmpty)
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.library_music_rounded,
                                    size: 70,
                                    color: context.themeData.colorScheme.outline
                                        .withValues(alpha: .9),
                                  ),
                                  Text(
                                    context.localization.emptyLibrary,
                                    style: TextStyle(
                                      color: context
                                          .themeData.colorScheme.outline
                                          .withValues(alpha: .9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (itemList
                            .where((e) => e.id != 'offline')
                            .isEmpty)
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.filter_alt_off,
                                    size: 70,
                                    color: context.themeData.colorScheme.outline
                                        .withValues(alpha: .9),
                                  ),
                                  Text(
                                    context.localization.noResults,
                                    style: TextStyle(
                                      color: context
                                          .themeData.colorScheme.outline
                                          .withValues(alpha: .9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: ListView(
                              children: [
                                ...itemList
                                    .where((item) => item.id != 'offline')
                                    .map(
                                      (item) => Builder(
                                        builder: (context) {
                                          if (item.album != null) {
                                            return AlbumTile(
                                              getTrackUsecase:
                                                  widget.getTrackUsecase,
                                              contentOrigin:
                                                  ContentOrigin.library,
                                              getPlaylistUsecase:
                                                  widget.getPlaylistUsecase,
                                              album: item.album!,
                                              coreController:
                                                  widget.coreController,
                                              playerController:
                                                  widget.playerController,
                                              getAlbumUsecase:
                                                  widget.getAlbumUsecase,
                                              downloaderController:
                                                  widget.downloaderController,
                                              getPlayableItemUsecase:
                                                  widget.getPlayableItemUsecase,
                                              libraryController:
                                                  widget.libraryController,
                                              getArtistAlbumsUsecase:
                                                  widget.getArtistAlbumsUsecase,
                                              getArtistSinglesUsecase: widget
                                                  .getArtistSinglesUsecase,
                                              getArtistTracksUsecase:
                                                  widget.getArtistTracksUsecase,
                                              getArtistUsecase:
                                                  widget.getArtistUsecase,
                                            );
                                          }
                                          if (item.playlist != null) {
                                            return PlaylistTile(
                                              getTrackUsecase:
                                                  widget.getTrackUsecase,
                                              contentOrigin:
                                                  ContentOrigin.library,
                                              playlist: item.playlist!,
                                              libraryController:
                                                  widget.libraryController,
                                              playerController:
                                                  widget.playerController,
                                              getAlbumUsecase:
                                                  widget.getAlbumUsecase,
                                              coreController:
                                                  widget.coreController,
                                              downloaderController:
                                                  widget.downloaderController,
                                              getPlayableItemUsecase:
                                                  widget.getPlayableItemUsecase,
                                              getPlaylistUsecase:
                                                  widget.getPlaylistUsecase,
                                              getArtistAlbumsUsecase:
                                                  widget.getArtistAlbumsUsecase,
                                              getArtistSinglesUsecase: widget
                                                  .getArtistSinglesUsecase,
                                              getArtistTracksUsecase:
                                                  widget.getArtistTracksUsecase,
                                              getArtistUsecase:
                                                  widget.getArtistUsecase,
                                            );
                                          }
                                          if (item.artist != null) {
                                            return ArtistTile(
                                              contentOrigin:
                                                  ContentOrigin.library,
                                              artist: item.artist!,
                                              getAlbumUsecase:
                                                  widget.getAlbumUsecase,
                                              getPlaylistUsecase:
                                                  widget.getPlaylistUsecase,
                                              coreController:
                                                  widget.coreController,
                                              downloaderController:
                                                  widget.downloaderController,
                                              getPlayableItemUsecase:
                                                  widget.getPlayableItemUsecase,
                                              libraryController:
                                                  widget.libraryController,
                                              playerController:
                                                  widget.playerController,
                                              getArtistUsecase:
                                                  widget.getArtistUsecase,
                                              getArtistAlbumsUsecase:
                                                  widget.getArtistAlbumsUsecase,
                                              getArtistTracksUsecase:
                                                  widget.getArtistTracksUsecase,
                                              getArtistSinglesUsecase: widget
                                                  .getArtistSinglesUsecase,
                                              getTrackUsecase:
                                                  widget.getTrackUsecase,
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                    ),
                                PlayerSizedBox(
                                  playerController: widget.playerController,
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
