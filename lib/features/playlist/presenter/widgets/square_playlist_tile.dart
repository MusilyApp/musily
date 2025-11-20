import 'package:flutter/material.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/pages/playlist_page.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class SquarePlaylistTile extends StatelessWidget {
  final PlaylistEntity playlist;
  final CoreController coreController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;
  const SquarePlaylistTile({
    super.key,
    required this.playlist,
    required this.coreController,
    required this.getPlaylistUsecase,
    required this.playerController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getTrackUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        LyNavigator.push(
          context.showingPageContext,
          playlist.tracks.isEmpty
              ? AsyncPlaylistPage(
                  getTrackUsecase: getTrackUsecase,
                  getPlaylistUsecase: getPlaylistUsecase,
                  origin: ContentOrigin.dataFetch,
                  playlistId: playlist.id,
                  coreController: coreController,
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
              : PlaylistPage(
                  getTrackUsecase: getTrackUsecase,
                  getPlaylistUsecase: getPlaylistUsecase,
                  playlist: playlist,
                  coreController: coreController,
                  playerController: playerController,
                  downloaderController: downloaderController,
                  getPlayableItemUsecase: getPlayableItemUsecase,
                  libraryController: libraryController,
                  getAlbumUsecase: getAlbumUsecase,
                  getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                  getArtistSinglesUsecase: getArtistSinglesUsecase,
                  getArtistTracksUsecase: getArtistTracksUsecase,
                  getArtistUsecase: getArtistUsecase,
                ),
        );
      },
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            if (playlist.highResImg != null)
              SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                  child: AppImage(
                    playlist.highResImg!,
                  ),
                ),
              ),
            LyListTile(
              title: InfinityMarquee(
                child: Text(playlist.title),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
