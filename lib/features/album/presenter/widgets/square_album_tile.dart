import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SquareAlbumTile extends StatelessWidget {
  final AlbumEntity album;
  final CoreController coreController;
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final LibraryController libraryController;

  const SquareAlbumTile({
    required this.album,
    required this.coreController,
    required this.playerController,
    required this.getAlbumUsecase,
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
    return InkWell(
      onTap: () {
        coreController.methods.pushWidget(
          album.tracks.isNotEmpty
              ? AlbumPage(
                  coreController: coreController,
                  playerController: playerController,
                  album: album,
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
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            if (album.highResImg != null)
              SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AppImage(
                    album.highResImg!,
                    width: 200,
                  ),
                ),
              ),
            ListTile(
              title: InfinityMarquee(
                child: Text(album.title),
              ),
              subtitle: Text(
                '${AppLocalizations.of(context)!.album}${album.year != 0 ? ' - ${album.year}' : ''}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
