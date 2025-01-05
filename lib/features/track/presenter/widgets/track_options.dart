import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:musily/core/domain/entities/app_menu_entry.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_menu.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_adder.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/downloader/presenter/widgets/downloader_menu_entry.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';
import 'package:musily/features/track/presenter/widgets/track_tile_static.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class TrackOptions extends StatelessWidget {
  final CoreController coreController;

  final TrackEntity track;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final List<AppMenuEntry> Function(BuildContext context)? customActions;
  final List<TrackTileOptions> hideOptions;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const TrackOptions({
    super.key,
    required this.coreController,
    required this.track,
    required this.playerController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getAlbumUsecase,
    this.customActions,
    this.hideOptions = const [],
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getPlaylistUsecase,
  });

  @override
  Widget build(BuildContext context) {
    final downloaderMenuEntry = (DownloaderMenuEntry(
      downloaderController: downloaderController,
    )).builder(
      context,
      track,
    );
    return AppMenu(
      modalHeader: TrackTileStatic(
        track: track,
      ),
      entries: [
        if (customActions != null) ...customActions!.call(context),
        if (!hideOptions.contains(TrackTileOptions.download)) ...[
          AppMenuEntry(
            leading: downloaderMenuEntry.leading,
            title: downloaderMenuEntry.child,
            onTap: downloaderMenuEntry.onPressed,
          ),
          if (downloaderController.methods.getItem(track)?.status ==
              DownloadStatus.completed)
            AppMenuEntry(
              onTap: () {
                coreController.methods.saveTrackToDownload(track);
              },
              title: Text(
                context.localization.saveToDownloads,
              ),
              leading: Icon(
                Icons.folder_copy_rounded,
                color: context.themeData.buttonTheme.colorScheme?.primary,
              ),
            )
        ],
        if (!hideOptions.contains(TrackTileOptions.addToPlaylist))
          AppMenuEntry(
            leading: Icon(
              Icons.playlist_add_rounded,
              color: context.themeData.buttonTheme.colorScheme?.primary,
            ),
            onTap: () {
              if (context.display.isDesktop) {
                LyNavigator.showLyDialog(
                  context: context,
                  builder: (context) => Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      height: MediaQuery.of(context).size.height * .6,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color:
                                context.themeData.dividerColor.withOpacity(.3),
                            width: 1,
                          ),
                        ),
                        child: PlaylistAdderWidget(
                          getPlaylistUsecase: getPlaylistUsecase,
                          coreController: coreController,
                          libraryController: libraryController,
                          tracks: [track],
                        ),
                      ),
                    ),
                  ),
                );
                return;
              }
              LyNavigator.push(
                coreController.coreContext!,
                PlaylistAdderWidget(
                  coreController: coreController,
                  getPlaylistUsecase: getPlaylistUsecase,
                  libraryController: libraryController,
                  tracks: [track],
                ),
              );
            },
            title: Text(
              context.localization.addToPlaylist,
            ),
          ),
        if (!hideOptions.contains(TrackTileOptions.addToQueue))
          AppMenuEntry(
            onTap: () {
              playerController.methods.addToQueue([track]);
              coreController.updateData(
                coreController.data.copyWith(
                  isShowingDialog: false,
                ),
              );
            },
            title: Text(
              context.localization.addToQueue,
            ),
            leading: Icon(
              Icons.queue_music_rounded,
              color: context.themeData.buttonTheme.colorScheme?.primary,
            ),
          ),
        if (!hideOptions.contains(TrackTileOptions.seeAlbum))
          if (track.album.id.isNotEmpty)
            AppMenuEntry(
              onTap: () {
                coreController.updateData(
                  coreController.data.copyWith(
                    isShowingDialog: false,
                  ),
                );
                LyNavigator.push(
                  context.showingPageContext,
                  AsyncAlbumPage(
                    albumId: track.album.id,
                    coreController: coreController,
                    playerController: playerController,
                    getAlbumUsecase: getAlbumUsecase,
                    downloaderController: downloaderController,
                    getPlaylistUsecase: getPlaylistUsecase,
                    getPlayableItemUsecase: getPlayableItemUsecase,
                    libraryController: libraryController,
                    getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                    getArtistSinglesUsecase: getArtistSinglesUsecase,
                    getArtistTracksUsecase: getArtistTracksUsecase,
                    getArtistUsecase: getArtistUsecase,
                  ),
                );
              },
              title: Text(context.localization.goToAlbum),
              leading: Icon(
                Icons.album_rounded,
                color: context.themeData.buttonTheme.colorScheme?.primary,
              ),
            ),
        if (!hideOptions.contains(TrackTileOptions.seeArtist))
          AppMenuEntry(
            onTap: () {
              coreController.updateData(
                coreController.data.copyWith(
                  isShowingDialog: false,
                ),
              );
              LyNavigator.push(
                context.showingPageContext,
                AsyncArtistPage(
                  artistId: track.artist.id,
                  coreController: coreController,
                  playerController: playerController,
                  downloaderController: downloaderController,
                  getPlayableItemUsecase: getPlayableItemUsecase,
                  getPlaylistUsecase: getPlaylistUsecase,
                  libraryController: libraryController,
                  getAlbumUsecase: getAlbumUsecase,
                  getArtistUsecase: getArtistUsecase,
                  getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                  getArtistTracksUsecase: getArtistTracksUsecase,
                  getArtistSinglesUsecase: getArtistSinglesUsecase,
                ),
              );
            },
            title: Text(context.localization.goToArtist),
            leading: Icon(
              Icons.person_rounded,
              color: context.themeData.buttonTheme.colorScheme?.primary,
            ),
          ),
        if (!hideOptions.contains(TrackTileOptions.share))
          AppMenuEntry(
            title: Text(context.localization.share),
            onTap: () {
              coreController.methods.shareSong(track);
            },
            leading: Icon(
              Icons.share_rounded,
              color: context.themeData.buttonTheme.colorScheme?.primary,
            ),
          ),
      ],
      coreController: coreController,
      toggler: (context, invoke) {
        return IconButton(
          onPressed: invoke,
          style: ButtonStyle(
            iconSize: WidgetStatePropertyAll(
              context.display.isDesktop ? 20 : null,
            ),
          ),
          icon: const Icon(
            Icons.more_vert,
          ),
        );
      },
    );
  }
}
