import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/core/utils/display_helper.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_creator.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_tile.dart';
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
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Set<String> filters = {};

  @override
  Widget build(BuildContext context) {
    return widget.coreController.builder(
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
        return widget.libraryController.builder(
          builder: (context, data) {
            return widget.downloaderController.builder(
                builder: (context, dlData) {
              final List<LibraryItemEntity<dynamic>> listClone =
                  List.from(data.items);
              final offlinePlaylist = LibraryItemEntity(
                id: 'offline',
                lastTimePlayed: DateTime.now(),
                value: PlaylistEntity(
                  id: 'offline',
                  title: 'offline',
                  tracks: dlData.queue
                      .where((e) => e.status == e.downloadCompleted)
                      .map((e) => TrackModel.fromMusilyTrack(e.track))
                      .toList(),
                  trackCount: dlData.queue.length,
                ),
              );
              listClone.insert(
                0,
                offlinePlaylist,
              );
              final albums =
                  listClone.whereType<LibraryItemEntity<AlbumEntity>>();
              final playlists =
                  listClone.whereType<LibraryItemEntity<PlaylistEntity>>();
              final artists =
                  listClone.whereType<LibraryItemEntity<ArtistEntity>>();

              final filteredList = <LibraryItemEntity<dynamic>>[
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
                  title: Text(AppLocalizations.of(context)!.library),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  actions: [
                    PlaylistCreator(
                      widget.libraryController,
                      coreController: widget.coreController,
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
                              LyListTile(
                                onTap: () =>
                                    widget.coreController.methods.pushWidget(
                                  favoritesPlaylist.value.tracks.isNotEmpty
                                      ? PlaylistPage(
                                          playlist: favoritesPlaylist.value,
                                          playerController:
                                              widget.playerController,
                                          coreController: widget.coreController,
                                          downloaderController:
                                              widget.downloaderController,
                                          getPlayableItemUsecase:
                                              widget.getPlayableItemUsecase,
                                          libraryController:
                                              widget.libraryController,
                                          getAlbumUsecase:
                                              widget.getAlbumUsecase,
                                          getPlaylistUsecase:
                                              widget.getPlaylistUsecase,
                                          getArtistAlbumsUsecase:
                                              widget.getArtistAlbumsUsecase,
                                          getArtistSinglesUsecase:
                                              widget.getArtistSinglesUsecase,
                                          getArtistTracksUsecase:
                                              widget.getArtistTracksUsecase,
                                          getArtistUsecase:
                                              widget.getArtistUsecase,
                                        )
                                      : AsyncPlaylistPage(
                                          getPlaylistUsecase:
                                              widget.getPlaylistUsecase,
                                          playlistId: favoritesPlaylist.id,
                                          coreController: widget.coreController,
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
                                          getArtistSinglesUsecase:
                                              widget.getArtistSinglesUsecase,
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
                              LyListTile(
                                onTap: () =>
                                    widget.coreController.methods.pushWidget(
                                  offlinePlaylist.value.tracks.isNotEmpty
                                      ? PlaylistPage(
                                          playlist: offlinePlaylist.value,
                                          playerController:
                                              widget.playerController,
                                          coreController: widget.coreController,
                                          downloaderController:
                                              widget.downloaderController,
                                          getPlayableItemUsecase:
                                              widget.getPlayableItemUsecase,
                                          libraryController:
                                              widget.libraryController,
                                          getAlbumUsecase:
                                              widget.getAlbumUsecase,
                                          getPlaylistUsecase:
                                              widget.getPlaylistUsecase,
                                          getArtistAlbumsUsecase:
                                              widget.getArtistAlbumsUsecase,
                                          getArtistSinglesUsecase:
                                              widget.getArtistSinglesUsecase,
                                          getArtistTracksUsecase:
                                              widget.getArtistTracksUsecase,
                                          getArtistUsecase:
                                              widget.getArtistUsecase,
                                        )
                                      : AsyncPlaylistPage(
                                          getPlaylistUsecase:
                                              widget.getPlaylistUsecase,
                                          playlistId: offlinePlaylist.id,
                                          coreController: widget.coreController,
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
                                          getArtistSinglesUsecase:
                                              widget.getArtistSinglesUsecase,
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
                            const Divider(),
                            // const SizedBox(
                            //   height: 12,
                            // ),
                          ],
                        );
                      },
                    ),
                    if (itemList
                        .where(
                          (item) =>
                              !(['favorites', 'offline'].contains(item.id)),
                        )
                        .isEmpty)
                      widget.playerController.builder(
                        builder: (context, data) {
                          return Expanded(
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
                        },
                      )
                    else
                      Expanded(
                        child: ListView(
                          children: [
                            ...itemList
                                .where((item) =>
                                    item.id != 'favorites' &&
                                    item.id != 'offline')
                                .map(
                                  (item) => Builder(
                                    builder: (context) {
                                      if (item.value is AlbumEntity) {
                                        return AlbumTile(
                                          album: item.value,
                                          coreController: widget.coreController,
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
                                          getArtistSinglesUsecase:
                                              widget.getArtistSinglesUsecase,
                                          getArtistTracksUsecase:
                                              widget.getArtistTracksUsecase,
                                          getArtistUsecase:
                                              widget.getArtistUsecase,
                                        );
                                      }
                                      if (item.value is PlaylistEntity) {
                                        return PlaylistTile(
                                          playlist: item.value,
                                          libraryController:
                                              widget.libraryController,
                                          playerController:
                                              widget.playerController,
                                          getAlbumUsecase:
                                              widget.getAlbumUsecase,
                                          coreController: widget.coreController,
                                          downloaderController:
                                              widget.downloaderController,
                                          getPlayableItemUsecase:
                                              widget.getPlayableItemUsecase,
                                          getPlaylistUsecase:
                                              widget.getPlaylistUsecase,
                                          getArtistAlbumsUsecase:
                                              widget.getArtistAlbumsUsecase,
                                          getArtistSinglesUsecase:
                                              widget.getArtistSinglesUsecase,
                                          getArtistTracksUsecase:
                                              widget.getArtistTracksUsecase,
                                          getArtistUsecase:
                                              widget.getArtistUsecase,
                                        );
                                      }
                                      if (item.value is ArtistEntity) {
                                        return ArtistTile(
                                          artist: item.value,
                                          getAlbumUsecase:
                                              widget.getAlbumUsecase,
                                          coreController: widget.coreController,
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
                                          getArtistSinglesUsecase:
                                              widget.getArtistSinglesUsecase,
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
                ),
              );
            });
          },
        );
      },
    );
  }
}
