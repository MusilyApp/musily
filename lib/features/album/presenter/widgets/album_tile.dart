import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/album/presenter/widgets/album_options_widget.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';

class AlbumTile extends StatelessWidget {
  final AlbumEntity album;
  final CoreController coreController;
  final PlayerController playerController;
  final bool staticTile;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const AlbumTile({
    required this.album,
    required this.coreController,
    required this.playerController,
    required this.getAlbumUsecase,
    this.staticTile = false,
    super.key,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return LyListTile(
      onTap: staticTile
          ? null
          : () {
              coreController.methods.pushWidget(
                album.tracks.isNotEmpty
                    ? AlbumPage(
                        album: album,
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
                    : AsyncAlbumPage(
                        albumId: album.id,
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
                      ),
              );
            },
      leading: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.outline.withOpacity(.2),
          ),
        ),
        child: Builder(
          builder: (context) {
            if (album.highResImg != null && album.highResImg!.isNotEmpty) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AppImage(
                  album.lowResImg!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              );
            }
            return SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.album_rounded,
                color: Theme.of(context).iconTheme.color?.withOpacity(.7),
              ),
            );
          },
        ),
      ),
      title: InfinityMarquee(
        child: Text(
          album.title,
        ),
      ),
      subtitle: InfinityMarquee(
        child: Text(
          album.artist.name,
        ),
      ),
      trailing: staticTile
          ? null
          : AlbumOptions(
              album: album,
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
            ),
    );
  }
}
