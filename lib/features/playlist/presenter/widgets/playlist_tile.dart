import 'package:flutter/material.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_tile_thumb.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_options.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/pages/playlist_page.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlaylistTile extends StatelessWidget {
  final PlaylistEntity playlist;
  final PlayerController playerController;
  final CoreController coreController;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  final void Function()? customClickAction;
  const PlaylistTile({
    required this.playlist,
    required this.libraryController,
    required this.playerController,
    required this.coreController,
    required this.getAlbumUsecase,
    this.customClickAction,
    super.key,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getPlaylistUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return libraryController.builder(builder: (context, data) {
      final asyncOperation = data.itemsAddingToLibrary.contains(playlist.id);
      return LyListTile(
        onTap: () {
          if (customClickAction != null) {
            customClickAction!.call();
            return;
          }
          LyNavigator.push(
            context.showingPageContext,
            playlist.tracks.isNotEmpty
                ? PlaylistPage(
                    coreController: coreController,
                    playlist: playlist,
                    playerController: playerController,
                    downloaderController: downloaderController,
                    getPlayableItemUsecase: getPlayableItemUsecase,
                    libraryController: libraryController,
                    getAlbumUsecase: getAlbumUsecase,
                    getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                    getArtistSinglesUsecase: getArtistSinglesUsecase,
                    getArtistTracksUsecase: getArtistTracksUsecase,
                    getArtistUsecase: getArtistUsecase,
                  )
                : AsyncPlaylistPage(
                    origin: ContentOrigin.library,
                    playlistId: playlist.id,
                    coreController: coreController,
                    playerController: playerController,
                    downloaderController: downloaderController,
                    getPlayableItemUsecase: getPlayableItemUsecase,
                    libraryController: libraryController,
                    getAlbumUsecase: getAlbumUsecase,
                    getArtistUsecase: getArtistUsecase,
                    getArtistTracksUsecase: getArtistTracksUsecase,
                    getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                    getArtistSinglesUsecase: getArtistSinglesUsecase,
                  ),
          );
        },
        leading: PlaylistTileThumb(
          playlist: playlist,
        ),
        title: Text(
          playlist.title,
        ),
        subtitle: Builder(
          builder: (context) {
            if (asyncOperation) {
              return Skeletonizer(
                child: Text(
                  '${context.localization.playlist} · ${playlist.trackCount} ${context.localization.songs}',
                ),
              );
            }
            return Text(
              '${context.localization.playlist} · ${playlist.trackCount} ${context.localization.songs}',
            );
          },
        ),
        trailing: asyncOperation
            ? null
            : PlaylistOptions(
                playlist: playlist,
                coreController: coreController,
                playerController: playerController,
                getAlbumUsecase: getAlbumUsecase,
                downloaderController: downloaderController,
                getPlayableItemUsecase: getPlayableItemUsecase,
                libraryController: libraryController,
              ),
      );
    });
  }
}
