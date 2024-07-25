import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/card_outlined.dart';
import 'package:musily/core/presenter/widgets/image_collection.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_icon.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/pages/playlist_page.dart';

class LibraryTile extends StatelessWidget {
  final LibraryItemEntity<dynamic> item;
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
        if (item.value is AlbumEntity) {
          return ListTile(
            onTap: () {
              coreController.methods.pushWidget(
                (item.value as AlbumEntity).tracks.isEmpty
                    ? AsyncAlbumPage(
                        albumId: (item.value as AlbumEntity).id,
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
                        album: item.value,
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
                item.value.lowResImg,
                fit: BoxFit.cover,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: InfinityMarquee(
                child: Text(
                  (item.value as AlbumEntity).title,
                ),
              ),
            ),
          );
        }
        if (item.value is PlaylistEntity) {
          return ListTile(
            onTap: () {
              coreController.methods.pushWidget(
                PlaylistPage(
                  playlist: item.value,
                  coreController: coreController,
                  playerController: playerController,
                  downloaderController: downloaderController,
                  getPlayableItemUsecase: getPlayableItemUsecase,
                  libraryController: libraryController,
                  getAlbumUsecase: getAlbumUsecase,
                  getPlaylistUsecase: getPlaylistUsecase,
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
              child: item.value.id == 'favorites'
                  ? const FavoriteIcon()
                  : ImageCollection(
                      size: 48,
                      urls: [
                        ...(item.value as PlaylistEntity).tracks.map(
                              (track) => track.lowResImg ?? '',
                            ),
                      ],
                    ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(
                right: 4,
              ),
              child: InfinityMarquee(
                child: Text(
                  (item.value as PlaylistEntity).id == 'favorites'
                      ? 'Favoritos'
                      : item.value.title,
                ),
              ),
            ),
          );
        }
        if (item.value is ArtistEntity) {
          return ListTile(
            onTap: () {
              coreController.methods.pushWidget(
                (item.value as ArtistEntity).topTracks.isEmpty
                    ? AsyncArtistPage(
                        artistId: item.value.id,
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
                        artist: item.value,
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
                item.value.lowResImg,
                fit: BoxFit.cover,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(
                right: 4,
              ),
              child: InfinityMarquee(
                child: Text(
                  (item.value as ArtistEntity).name,
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
