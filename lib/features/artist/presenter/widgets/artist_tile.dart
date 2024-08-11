import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';

class ArtistTile extends StatelessWidget {
  final ArtistEntity artist;
  final GetAlbumUsecase getAlbumUsecase;
  final CoreController coreController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final PlayerController playerController;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const ArtistTile({
    super.key,
    required this.artist,
    required this.getAlbumUsecase,
    required this.coreController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.playerController,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => coreController.methods.pushWidget(
        artist.topTracks.isEmpty
            ? AsyncArtistPage(
                artistId: artist.id,
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
                getAlbumUsecase: getAlbumUsecase,
                artist: artist,
                coreController: coreController,
                playerController: playerController,
                downloaderController: downloaderController,
                getPlayableItemUsecase: getPlayableItemUsecase,
                libraryController: libraryController,
                getArtistUsecase: getArtistUsecase,
                getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                getArtistTracksUsecase: getArtistTracksUsecase,
                getArtistSinglesUsecase: getArtistSinglesUsecase,
              ),
      ),
      subtitle: const Text(
        'Artista',
      ),
      leading: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(360),
          side: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.outline.withOpacity(.2),
          ),
        ),
        child: Builder(
          builder: (context) {
            if (artist.lowResImg != null) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: AppImage(
                  artist.lowResImg!,
                  width: 40,
                  height: 40,
                ),
              );
            }
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.person_rounded,
              ),
            );
          },
        ),
      ),
      title: Text(artist.name),
    );
  }
}
