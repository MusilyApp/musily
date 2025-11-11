import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/color_scheme.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/ui/window/draggable_box.dart';
import 'package:musily/core/presenter/ui/window/window_controls.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/pages/backup_page.dart';
import 'package:musily/features/_library_module/presenter/widgets/backup_progress_card.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/widgets/album_tile.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/widgets/artist_tile.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/domain/enums/player_mode.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_creator.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_tile.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:musily/features/player/presenter/widgets/desktop_player_panel.dart';
import 'package:musily/features/player/presenter/widgets/desktop_mini_player.dart';

class DCorePage extends StatefulWidget {
  final CoreController coreController;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetTrackUsecase getTrackUsecase;

  const DCorePage({
    super.key,
    required this.coreController,
    required this.playerController,
    required this.downloaderController,
    required this.libraryController,
    required this.getAlbumUsecase,
    required this.getPlayableItemUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistUsecase,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<DCorePage> createState() => _DCorePageState();
}

class _DCorePageState extends State<DCorePage> {
  int _selected = 0;
  final routes = [
    NavigatorPages.sectionsPage,
    NavigatorPages.searchPage,
    NavigatorPages.downloaderPage,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: context.themeData.scaffoldBackgroundColor,
              border: Border(
                right: BorderSide(
                  color: (context.themeData.iconTheme.color ?? Colors.white)
                      .withValues(alpha: .1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DraggableBox(
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: context.themeData.scaffoldBackgroundColor,
                    child: const Center(
                      child: Row(
                        children: [
                          WindowControls(),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _NavMenuItem(
                        icon: LucideIcons.house,
                        label: context.localization.home,
                        isSelected: _selected == 0,
                        onTap: () {
                          setState(() {
                            _selected = 0;
                          });
                          LyNavigator.navigateTo(routes[0]);
                        },
                      ),
                      const SizedBox(height: 8),
                      _NavMenuItem(
                        icon: LucideIcons.search,
                        label: context.localization.search,
                        isSelected: _selected == 1,
                        onTap: () {
                          setState(() {
                            _selected = 1;
                          });
                          LyNavigator.navigateTo(routes[1]);
                        },
                      ),
                      const SizedBox(height: 8),
                      _NavMenuItem(
                        icon: LucideIcons.download,
                        label: context.localization.downloads,
                        isSelected: _selected == 2,
                        onTap: () {
                          setState(() {
                            _selected = 2;
                          });
                          LyNavigator.navigateTo(routes[2]);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: BackupProgressCard(
                          libraryController: widget.libraryController,
                          isDesktop: true,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          decoration: BoxDecoration(
                            color: context.themeData.colorScheme.onScaffold,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(
                                      LucideIcons.library,
                                      size: 20,
                                      color: context
                                          .themeData.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      context.localization.library,
                                      style: TextStyle(
                                        color: context
                                            .themeData.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    PlaylistCreator(
                                      widget.libraryController,
                                      getPlaylistUsecase:
                                          widget.getPlaylistUsecase,
                                      coreController: widget.coreController,
                                      builder: (context, showCreator) =>
                                          IconButton(
                                        onPressed: showCreator,
                                        icon: Icon(
                                          LucideIcons.plus,
                                          size: 18,
                                          color: context
                                              .themeData.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    IconButton(
                                      onPressed: () async {
                                        LyNavigator.push(
                                          context.showingPageContext,
                                          BackupPage(
                                            downloaderController:
                                                widget.downloaderController,
                                            libraryController:
                                                widget.libraryController,
                                            coreController:
                                                widget.coreController,
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        LucideIcons.databaseBackup,
                                        size: 18,
                                        color: context
                                            .themeData.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: widget.libraryController.builder(
                                  builder: (context, data) {
                                    return widget.downloaderController.builder(
                                      builder: (context, dlData) {
                                        final List<LibraryItemEntity>
                                            listClone = List.from(data.items);

                                        // Add offline playlist
                                        final offlinePlaylist =
                                            LibraryItemEntity(
                                          id: 'offline',
                                          synced: false,
                                          lastTimePlayed: DateTime.now(),
                                          playlist: PlaylistEntity(
                                            id: 'offline',
                                            title: 'offline',
                                            tracks: dlData.queue
                                                .where(
                                                  (e) =>
                                                      e.status ==
                                                      e.downloadCompleted,
                                                )
                                                .map((e) => e.track)
                                                .toList(),
                                            trackCount: dlData.queue.length,
                                          ),
                                          createdAt: DateTime.now(),
                                        );

                                        return ShaderMask(
                                          shaderCallback: (Rect bounds) {
                                            return const LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.white,
                                                Colors.white,
                                                Colors.transparent,
                                              ],
                                              stops: [0.0, 0.05, 0.95, 1],
                                            ).createShader(bounds);
                                          },
                                          blendMode: BlendMode.dstIn,
                                          child: ListView(
                                            children: [
                                              // Offline playlist
                                              PlaylistTile(
                                                leadingSize: 48,
                                                density: LyDensity.dense,
                                                playlist:
                                                    offlinePlaylist.playlist!,
                                                libraryController:
                                                    widget.libraryController,
                                                playerController:
                                                    widget.playerController,
                                                coreController:
                                                    widget.coreController,
                                                getAlbumUsecase:
                                                    widget.getAlbumUsecase,
                                                downloaderController:
                                                    widget.downloaderController,
                                                getPlayableItemUsecase: widget
                                                    .getPlayableItemUsecase,
                                                getPlaylistUsecase:
                                                    widget.getPlaylistUsecase,
                                                getTrackUsecase:
                                                    widget.getTrackUsecase,
                                                getArtistAlbumsUsecase: widget
                                                    .getArtistAlbumsUsecase,
                                                getArtistSinglesUsecase: widget
                                                    .getArtistSinglesUsecase,
                                                getArtistTracksUsecase: widget
                                                    .getArtistTracksUsecase,
                                                getArtistUsecase:
                                                    widget.getArtistUsecase,
                                                contentOrigin:
                                                    ContentOrigin.library,
                                              ),
                                              ...listClone.map((item) {
                                                if (item.playlist != null) {
                                                  final playlist =
                                                      item.playlist!;
                                                  return PlaylistTile(
                                                    density: LyDensity.dense,
                                                    playlist: playlist,
                                                    libraryController: widget
                                                        .libraryController,
                                                    playerController:
                                                        widget.playerController,
                                                    coreController:
                                                        widget.coreController,
                                                    getAlbumUsecase:
                                                        widget.getAlbumUsecase,
                                                    downloaderController: widget
                                                        .downloaderController,
                                                    getPlayableItemUsecase: widget
                                                        .getPlayableItemUsecase,
                                                    getPlaylistUsecase: widget
                                                        .getPlaylistUsecase,
                                                    getTrackUsecase:
                                                        widget.getTrackUsecase,
                                                    getArtistAlbumsUsecase: widget
                                                        .getArtistAlbumsUsecase,
                                                    getArtistSinglesUsecase: widget
                                                        .getArtistSinglesUsecase,
                                                    getArtistTracksUsecase: widget
                                                        .getArtistTracksUsecase,
                                                    getArtistUsecase:
                                                        widget.getArtistUsecase,
                                                    contentOrigin:
                                                        ContentOrigin.library,
                                                  );
                                                }
                                                if (item.album != null) {
                                                  final album = item.album!;
                                                  return AlbumTile(
                                                    density: LyDensity.dense,
                                                    album: album,
                                                    libraryController: widget
                                                        .libraryController,
                                                    playerController:
                                                        widget.playerController,
                                                    coreController:
                                                        widget.coreController,
                                                    getAlbumUsecase:
                                                        widget.getAlbumUsecase,
                                                    downloaderController: widget
                                                        .downloaderController,
                                                    getPlayableItemUsecase: widget
                                                        .getPlayableItemUsecase,
                                                    getArtistUsecase:
                                                        widget.getArtistUsecase,
                                                    getArtistAlbumsUsecase: widget
                                                        .getArtistAlbumsUsecase,
                                                    getArtistTracksUsecase: widget
                                                        .getArtistTracksUsecase,
                                                    getArtistSinglesUsecase: widget
                                                        .getArtistSinglesUsecase,
                                                    contentOrigin:
                                                        ContentOrigin.library,
                                                    getPlaylistUsecase: widget
                                                        .getPlaylistUsecase,
                                                    getTrackUsecase:
                                                        widget.getTrackUsecase,
                                                  );
                                                }
                                                if (item.artist != null) {
                                                  final artist = item.artist!;
                                                  return ArtistTile(
                                                    density: LyDensity.dense,
                                                    artist: artist,
                                                    libraryController: widget
                                                        .libraryController,
                                                    playerController:
                                                        widget.playerController,
                                                    coreController:
                                                        widget.coreController,
                                                    getAlbumUsecase:
                                                        widget.getAlbumUsecase,
                                                    downloaderController: widget
                                                        .downloaderController,
                                                    getPlayableItemUsecase: widget
                                                        .getPlayableItemUsecase,
                                                    getArtistUsecase:
                                                        widget.getArtistUsecase,
                                                    getArtistAlbumsUsecase: widget
                                                        .getArtistAlbumsUsecase,
                                                    getArtistTracksUsecase: widget
                                                        .getArtistTracksUsecase,
                                                    getArtistSinglesUsecase: widget
                                                        .getArtistSinglesUsecase,
                                                    contentOrigin:
                                                        ContentOrigin.library,
                                                    getPlaylistUsecase: widget
                                                        .getPlaylistUsecase,
                                                    getTrackUsecase:
                                                        widget.getTrackUsecase,
                                                  );
                                                }
                                                return const SizedBox.shrink();
                                              }),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Container(
              color: context.themeData.scaffoldBackgroundColor,
              child: const RouterOutlet(),
            ),
          ),
          Container(
            width: 320,
            decoration: BoxDecoration(
              color: context.themeData.scaffoldBackgroundColor,
              border: Border(
                left: BorderSide(
                  color: (context.themeData.iconTheme.color ?? Colors.white)
                      .withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: widget.playerController.builder(
              builder: (context, data) {
                return DesktopPlayerPanel(
                  playerController: widget.playerController,
                  downloaderController: widget.downloaderController,
                  libraryController: widget.libraryController,
                  getAlbumUsecase: widget.getAlbumUsecase,
                  getPlayableItemUsecase: widget.getPlayableItemUsecase,
                  getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                  getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                  getArtistTracksUsecase: widget.getArtistTracksUsecase,
                  coreController: widget.coreController,
                  getPlaylistUsecase: widget.getPlaylistUsecase,
                  getArtistUsecase: widget.getArtistUsecase,
                  getTrackUsecase: widget.getTrackUsecase,
                  mode: data.playerMode,
                  track: data.currentPlayingItem,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.playerController.builder(
        builder: (context, data) {
          if (data.currentPlayingItem == null) {
            return const SizedBox.shrink();
          }
          return DesktopMiniPlayer(
            playerController: widget.playerController,
            libraryController: widget.libraryController,
            downloaderController: widget.downloaderController,
            coreController: widget.coreController,
            getPlayableItemUsecase: widget.getPlayableItemUsecase,
            getAlbumUsecase: widget.getAlbumUsecase,
            getArtistUsecase: widget.getArtistUsecase,
            getArtistTracksUsecase: widget.getArtistTracksUsecase,
            getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
            getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
            getTrackUsecase: widget.getTrackUsecase,
            getPlaylistUsecase: widget.getPlaylistUsecase,
            onModeTap: () {
              setState(() {
                if (data.playerMode == PlayerMode.queue) {
                  widget.playerController.methods
                      .setPlayerMode(PlayerMode.lyrics);
                  widget.playerController.methods.getLyrics(
                    data.currentPlayingItem?.id ?? '',
                  );
                } else {
                  widget.playerController.methods
                      .setPlayerMode(PlayerMode.queue);
                }
              });
            },
          );
        },
      ),
    );
  }
}

class _NavMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavMenuItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? context.themeData.colorScheme.onScaffold
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                  ? context.themeData.colorScheme.onSurface
                  : context.themeData.colorScheme.onSurface
                      .withValues(alpha: 0.6),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? context.themeData.colorScheme.onSurface
                    : context.themeData.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
