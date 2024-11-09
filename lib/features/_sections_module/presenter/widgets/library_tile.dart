import 'package:flutter/material.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/card_outlined.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_icon.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/enums/playlist_origin.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/pages/playlist_page.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class LibraryTile extends StatelessWidget {
  final LibraryItemEntity item;
  final CoreController coreController;
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const LibraryTile({
    required this.item,
    required this.coreController,
    required this.playerController,
    required this.getAlbumUsecase,
    super.key,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getPlaylistUsecase,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return CardOutlined(
      child: Builder(builder: (context) {
        if (item.album != null) {
          return LyListTile(
            paddingOnFocus: false,
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              LyNavigator.push(
                context.showingPageContext,
                item.album!.tracks.isEmpty
                    ? AsyncAlbumPage(
                        albumId: item.album!.id,
                        coreController: coreController,
                        playerController: playerController,
                        getAlbumUsecase: getAlbumUsecase,
                        downloaderController: downloaderController,
                        getPlayableItemUsecase: getPlayableItemUsecase,
                        libraryController: libraryController,
                        getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                        getArtistSinglesUsecase: getArtistSinglesUsecase,
                        getArtistTracksUsecase: getArtistTracksUsecase,
                        getArtistUsecase: getArtistUsecase,
                      )
                    : AlbumPage(
                        coreController: coreController,
                        album: item.album!,
                        playerController: playerController,
                        getAlbumUsecase: getAlbumUsecase,
                        downloaderController: downloaderController,
                        getPlayableItemUsecase: getPlayableItemUsecase,
                        libraryController: libraryController,
                        getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                        getArtistSinglesUsecase: getArtistSinglesUsecase,
                        getArtistTracksUsecase: getArtistTracksUsecase,
                        getArtistUsecase: getArtistUsecase,
                      ),
              );
            },
            minTileHeight: 60,
            contentPadding: const EdgeInsets.only(
              left: 5,
            ),
            leading: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: AppImage(
                width: 48,
                height: 48,
                item.album!.lowResImg ?? '',
                fit: BoxFit.cover,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: InfinityMarquee(
                child: Text(
                  item.album!.title,
                ),
              ),
            ),
          );
        }
        if (item.playlist != null) {
          return LyListTile(
            paddingOnFocus: false,
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              LyNavigator.push(
                context.showingPageContext,
                item.playlist!.tracks.isEmpty
                    ? AsyncPlaylistPage(
                        origin: PlaylistOrigin.library,
                        playlistId: item.playlist!.id,
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
                      )
                    : PlaylistPage(
                        playlist: item.playlist!,
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
            minTileHeight: 60,
            contentPadding: const EdgeInsets.only(
              left: 5,
            ),
            leading: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: item.playlist!.id == UserService.favoritesId
                  ? const FavoriteIcon()
                  : const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.playlist_play_rounded,
                      ),
                    ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(
                right: 4,
              ),
              child: InfinityMarquee(
                child: Text(
                  item.playlist!.id == UserService.favoritesId
                      ? context.localization.favorites
                      : item.playlist!.title,
                ),
              ),
            ),
          );
        }
        if (item.artist != null) {
          return LyListTile(
            borderRadius: BorderRadius.circular(8),
            paddingOnFocus: false,
            onTap: () {
              LyNavigator.push(
                context.showingPageContext,
                item.artist!.topTracks.isEmpty
                    ? AsyncArtistPage(
                        artistId: item.artist!.id,
                        coreController: coreController,
                        playerController: playerController,
                        downloaderController: downloaderController,
                        getPlayableItemUsecase: getPlayableItemUsecase,
                        libraryController: libraryController,
                        getAlbumUsecase: getAlbumUsecase,
                        getArtistUsecase: getArtistUsecase,
                        getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                        getArtistTracksUsecase: getArtistTracksUsecase,
                        getArtistSinglesUsecase: getArtistSinglesUsecase,
                      )
                    : ArtistPage(
                        artist: item.artist!,
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
            minTileHeight: 60,
            contentPadding: const EdgeInsets.only(
              left: 5,
            ),
            leading: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: AppImage(
                width: 48,
                height: 48,
                item.artist!.lowResImg ?? '',
                fit: BoxFit.cover,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(
                right: 4,
              ),
              child: InfinityMarquee(
                child: Text(
                  item.artist!.name,
                ),
              ),
            ),
          );
        }
        return Container();
      }),
    );
  }
}
