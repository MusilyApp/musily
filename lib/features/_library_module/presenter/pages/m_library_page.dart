import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/pages/library_settings.dart';
import 'package:musily/features/_library_module/presenter/widgets/local_playlist_tile.dart';
import 'package:musily/features/_library_module/presenter/pages/local_library_playlist_page.dart';
import 'package:musily/features/album/presenter/widgets/album_item.dart';
import 'package:musily/features/artist/presenter/widgets/artist_item.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/widgets/offline_icon.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/pages/playlist_page.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_creator.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_tile.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class MLibraryPage extends StatelessWidget {
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

  const MLibraryPage({
    super.key,
    required this.playerController,
    required this.getAlbumUsecase,
    required this.coreController,
    required this.libraryController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getPlaylistUsecase,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
    required this.getTrackUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return libraryController.builder(
      builder: (context, data) {
        return downloaderController.builder(
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
            listClone.insert(0, offlinePlaylist);

            final albums = listClone.where((e) => e.album != null).toList();
            final playlists = listClone
                .where((e) => e.playlist != null && e.playlist?.id != 'offline')
                .toList();
            final artists = listClone.where((e) => e.artist != null).toList();
            final localFolders = libraryController.data.localPlaylists;

            return Scaffold(
              appBar: MusilyAppBar(
                autoImplyLeading: false,
                title: Text(context.localization.library),
                backgroundColor: context.themeData.scaffoldBackgroundColor,
                surfaceTintColor: context.themeData.scaffoldBackgroundColor,
                leading: data.loading
                    ? null
                    : PlaylistCreator(
                        libraryController,
                        getPlaylistUsecase: getPlaylistUsecase,
                        coreController: coreController,
                        builder: (context, showCreator) => IconButton(
                          onPressed: showCreator,
                          icon: const Icon(LucideIcons.plus, size: 20),
                        ),
                      ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      LyNavigator.push(
                        context,
                        LibrarySettingsPage(
                          downloaderController: downloaderController,
                          libraryController: libraryController,
                          coreController: coreController,
                          playerController: playerController,
                          getPlayableItemUsecase: getPlayableItemUsecase,
                          getAlbumUsecase: getAlbumUsecase,
                          getArtistUsecase: getArtistUsecase,
                          getArtistTracksUsecase: getArtistTracksUsecase,
                          getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                          getArtistSinglesUsecase: getArtistSinglesUsecase,
                          getPlaylistUsecase: getPlaylistUsecase,
                          getTrackUsecase: getTrackUsecase,
                        ),
                      );
                    },
                    icon: const Icon(LucideIcons.settings2, size: 20),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () => libraryController.methods.getLibraryItems(),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: context
                            .themeData.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: context.themeData.colorScheme.outline
                              .withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: LyListTile(
                        onTap: () => LyNavigator.push(
                          context.showingPageContext,
                          offlinePlaylist.playlist!.tracks.isNotEmpty
                              ? PlaylistPage(
                                  getTrackUsecase: getTrackUsecase,
                                  playlist: offlinePlaylist.playlist!,
                                  playerController: playerController,
                                  getPlaylistUsecase: getPlaylistUsecase,
                                  coreController: coreController,
                                  downloaderController: downloaderController,
                                  getPlayableItemUsecase:
                                      getPlayableItemUsecase,
                                  libraryController: libraryController,
                                  getAlbumUsecase: getAlbumUsecase,
                                  getArtistAlbumsUsecase:
                                      getArtistAlbumsUsecase,
                                  getArtistSinglesUsecase:
                                      getArtistSinglesUsecase,
                                  getArtistTracksUsecase:
                                      getArtistTracksUsecase,
                                  getArtistUsecase: getArtistUsecase,
                                )
                              : AsyncPlaylistPage(
                                  getTrackUsecase: getTrackUsecase,
                                  origin: ContentOrigin.library,
                                  playlistId: offlinePlaylist.id,
                                  coreController: coreController,
                                  getPlaylistUsecase: getPlaylistUsecase,
                                  playerController: playerController,
                                  downloaderController: downloaderController,
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
                          borderRadius: BorderRadius.circular(16),
                          child: const OfflineIcon(size: 50),
                        ),
                        title: Text(
                          context.localization.offline,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '${offlinePlaylist.playlist!.trackCount} ${context.localization.songs}',
                          style: TextStyle(
                            color: context.themeData.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          final scaffoldColor =
                              context.themeData.scaffoldBackgroundColor;
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              scaffoldColor,
                              scaffoldColor,
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.05, 0.95, 1],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: data.items.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        LucideIcons.library,
                                        size: 48,
                                        color: context
                                            .themeData.colorScheme.primary
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
                                        context.localization
                                            .emptyLibraryDescription,
                                        style: context
                                            .themeData.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: context
                                              .themeData.colorScheme.onSurface
                                              .withValues(alpha: 0.5),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      PlayerSizedBox(
                                          playerController: playerController),
                                    ],
                                  ),
                                ),
                              )
                            : Builder(builder: (context) {
                                return ListView(
                                  shrinkWrap: true,
                                  children: [
                                    if (localFolders.isNotEmpty) ...[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 8),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 4,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: context.themeData
                                                    .colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              context.localization
                                                  .localLibraryTitle,
                                              style: context.themeData.textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: context.themeData
                                                    .colorScheme.onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ...localFolders.map(
                                        (folder) => LocalPlaylistTile(
                                          playlist: folder,
                                          libraryController: libraryController,
                                          playerController: playerController,
                                          coreController: coreController,
                                          customClickAction: () {
                                            LyNavigator.push(
                                              context.showingPageContext,
                                              LocalLibraryPlaylistPage(
                                                playlistId: folder.id,
                                                libraryController:
                                                    libraryController,
                                                playerController:
                                                    playerController,
                                                coreController: coreController,
                                                downloaderController:
                                                    downloaderController,
                                                getPlayableItemUsecase:
                                                    getPlayableItemUsecase,
                                                getAlbumUsecase:
                                                    getAlbumUsecase,
                                                getArtistUsecase:
                                                    getArtistUsecase,
                                                getArtistTracksUsecase:
                                                    getArtistTracksUsecase,
                                                getArtistAlbumsUsecase:
                                                    getArtistAlbumsUsecase,
                                                getArtistSinglesUsecase:
                                                    getArtistSinglesUsecase,
                                                getPlaylistUsecase:
                                                    getPlaylistUsecase,
                                                getTrackUsecase:
                                                    getTrackUsecase,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                    if (artists.isNotEmpty) ...[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 8),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 4,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: context.themeData
                                                    .colorScheme.tertiary,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              context.localization.artists,
                                              style: context.themeData.textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: context.themeData
                                                    .colorScheme.onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 170,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          itemCount: artists.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(width: 12),
                                          itemBuilder: (context, index) {
                                            final artist =
                                                artists[index].artist!;
                                            return ArtistItem(
                                              artist: artist,
                                              onTap: () {
                                                LyNavigator.push(
                                                  context.showingPageContext,
                                                  artist.topTracks.isEmpty
                                                      ? AsyncArtistPage(
                                                          artistId: artist.id,
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
                                                          getArtistUsecase:
                                                              getArtistUsecase,
                                                          getPlaylistUsecase:
                                                              getPlaylistUsecase,
                                                          getArtistAlbumsUsecase:
                                                              getArtistAlbumsUsecase,
                                                          getArtistTracksUsecase:
                                                              getArtistTracksUsecase,
                                                          getArtistSinglesUsecase:
                                                              getArtistSinglesUsecase,
                                                          getTrackUsecase:
                                                              getTrackUsecase,
                                                        )
                                                      : ArtistPage(
                                                          getTrackUsecase:
                                                              getTrackUsecase,
                                                          getAlbumUsecase:
                                                              getAlbumUsecase,
                                                          artist: artist,
                                                          coreController:
                                                              coreController,
                                                          playerController:
                                                              playerController,
                                                          getPlaylistUsecase:
                                                              getPlaylistUsecase,
                                                          downloaderController:
                                                              downloaderController,
                                                          getPlayableItemUsecase:
                                                              getPlayableItemUsecase,
                                                          libraryController:
                                                              libraryController,
                                                          getArtistUsecase:
                                                              getArtistUsecase,
                                                          getArtistAlbumsUsecase:
                                                              getArtistAlbumsUsecase,
                                                          getArtistTracksUsecase:
                                                              getArtistTracksUsecase,
                                                          getArtistSinglesUsecase:
                                                              getArtistSinglesUsecase,
                                                        ),
                                                );
                                                libraryController.methods
                                                    .getLibraryItem(
                                                  artist.id,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                    if (albums.isNotEmpty) ...[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 8),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 4,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: context.themeData
                                                    .colorScheme.secondary,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              context.localization.albums,
                                              style: context.themeData.textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: context.themeData
                                                    .colorScheme.onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 160,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          shrinkWrap: true,
                                          itemCount: albums.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(width: 12),
                                          itemBuilder: (context, index) {
                                            final album = albums[index].album!;
                                            return AlbumItem(
                                              album: album,
                                              onTap: () {
                                                LyNavigator.push(
                                                  context.showingPageContext,
                                                  album.tracks.isNotEmpty
                                                      ? AlbumPage(
                                                          album: album,
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
                                                          albumId: album.id,
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
                                                libraryController.methods
                                                    .getLibraryItem(
                                                  album.id,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                    if (playlists.isNotEmpty) ...[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 8),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 4,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: context.themeData
                                                    .colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              context.localization.playlists,
                                              style: context.themeData.textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: context.themeData
                                                    .colorScheme.onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ...playlists
                                          .where((playlist) =>
                                              playlist.id != 'offline')
                                          .map(
                                            (item) => PlaylistTile(
                                              getTrackUsecase: getTrackUsecase,
                                              contentOrigin:
                                                  ContentOrigin.library,
                                              playlist: item.playlist!,
                                              libraryController:
                                                  libraryController,
                                              playerController:
                                                  playerController,
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
                                              getArtistUsecase:
                                                  getArtistUsecase,
                                            ),
                                          ),
                                    ],
                                  ],
                                );
                              }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
