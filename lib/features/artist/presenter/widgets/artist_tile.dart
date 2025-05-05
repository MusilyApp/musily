import 'package:flutter/material.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/library_wrapper.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';

class ArtistTile extends StatefulWidget {
  final ArtistEntity artist;
  final GetAlbumUsecase getAlbumUsecase;
  final CoreController coreController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final PlayerController playerController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final ContentOrigin contentOrigin;

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
    required this.contentOrigin,
    required this.getPlaylistUsecase,
  });

  @override
  State<ArtistTile> createState() => _ArtistTileState();
}

class _ArtistTileState extends State<ArtistTile> {
  @override
  Widget build(BuildContext context) {
    return LibraryWrapper(
      libraryController: widget.libraryController,
      libraryItem: widget.libraryController.data.items
          .where(
            (e) => e.id == widget.artist.id,
          )
          .firstOrNull,
      child: LyListTile(
        onTap: () {
          LyNavigator.push(
            context.showingPageContext,
            widget.artist.topTracks.isEmpty
                ? AsyncArtistPage(
                    artistId: widget.artist.id,
                    coreController: widget.coreController,
                    playerController: widget.playerController,
                    downloaderController: widget.downloaderController,
                    getPlayableItemUsecase: widget.getPlayableItemUsecase,
                    libraryController: widget.libraryController,
                    getAlbumUsecase: widget.getAlbumUsecase,
                    getArtistUsecase: widget.getArtistUsecase,
                    getPlaylistUsecase: widget.getPlaylistUsecase,
                    getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                    getArtistTracksUsecase: widget.getArtistTracksUsecase,
                    getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                  )
                : ArtistPage(
                    getAlbumUsecase: widget.getAlbumUsecase,
                    artist: widget.artist,
                    coreController: widget.coreController,
                    playerController: widget.playerController,
                    getPlaylistUsecase: widget.getPlaylistUsecase,
                    downloaderController: widget.downloaderController,
                    getPlayableItemUsecase: widget.getPlayableItemUsecase,
                    libraryController: widget.libraryController,
                    getArtistUsecase: widget.getArtistUsecase,
                    getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                    getArtistTracksUsecase: widget.getArtistTracksUsecase,
                    getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                  ),
          );
          if (widget.contentOrigin == ContentOrigin.library) {
            widget.libraryController.methods.getLibraryItem(widget.artist.id);
          }
        },
        subtitle: Text(
          context.localization.artist,
        ),
        leading: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(360),
            side: BorderSide(
              width: 1,
              color:
                  context.themeData.colorScheme.outline.withValues(alpha: .2),
            ),
          ),
          child: Builder(
            builder: (context) {
              if (widget.artist.lowResImg != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(360),
                  child: AppImage(
                    widget.artist.lowResImg!,
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
        title: Text(widget.artist.name),
      ),
    );
  }
}
