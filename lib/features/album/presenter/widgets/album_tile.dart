import 'package:flutter/material.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/library_wrapper.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/album/presenter/widgets/album_options_widget.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class AlbumTile extends StatefulWidget {
  final AlbumEntity album;
  final CoreController coreController;
  final PlayerController playerController;
  final bool staticTile;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetArtistUsecase getArtistUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final ContentOrigin contentOrigin;
  final GetTrackUsecase getTrackUsecase;

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
    required this.contentOrigin,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<AlbumTile> createState() => _AlbumTileState();
}

class _AlbumTileState extends State<AlbumTile> {
  @override
  Widget build(BuildContext context) {
    return LibraryWrapper(
      libraryController: widget.libraryController,
      libraryItem: widget.libraryController.data.items
          .where(
            (e) => e.id == widget.album.id,
          )
          .firstOrNull,
      child: LyListTile(
        onTap: widget.staticTile
            ? null
            : () {
                LyNavigator.push(
                  context.showingPageContext,
                  widget.album.tracks.isNotEmpty
                      ? AlbumPage(
                          album: widget.album,
                          getTrackUsecase: widget.getTrackUsecase,
                          getPlaylistUsecase: widget.getPlaylistUsecase,
                          coreController: widget.coreController,
                          playerController: widget.playerController,
                          getAlbumUsecase: widget.getAlbumUsecase,
                          downloaderController: widget.downloaderController,
                          getPlayableItemUsecase: widget.getPlayableItemUsecase,
                          libraryController: widget.libraryController,
                          getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                          getArtistSinglesUsecase:
                              widget.getArtistSinglesUsecase,
                          getArtistTracksUsecase: widget.getArtistTracksUsecase,
                          getArtistUsecase: widget.getArtistUsecase,
                        )
                      : AsyncAlbumPage(
                          getTrackUsecase: widget.getTrackUsecase,
                          albumId: widget.album.id,
                          getPlaylistUsecase: widget.getPlaylistUsecase,
                          coreController: widget.coreController,
                          playerController: widget.playerController,
                          getAlbumUsecase: widget.getAlbumUsecase,
                          downloaderController: widget.downloaderController,
                          getPlayableItemUsecase: widget.getPlayableItemUsecase,
                          libraryController: widget.libraryController,
                          getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                          getArtistSinglesUsecase:
                              widget.getArtistSinglesUsecase,
                          getArtistTracksUsecase: widget.getArtistTracksUsecase,
                          getArtistUsecase: widget.getArtistUsecase,
                        ),
                );
                if (widget.contentOrigin == ContentOrigin.library) {
                  widget.libraryController.methods
                      .getLibraryItem(widget.album.id);
                }
              },
        leading: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              width: 1,
              color:
                  context.themeData.colorScheme.outline.withValues(alpha: .2),
            ),
          ),
          child: Builder(
            builder: (context) {
              if (widget.album.highResImg != null &&
                  widget.album.highResImg!.isNotEmpty) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppImage(
                    widget.album.lowResImg!,
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
                  color:
                      context.themeData.iconTheme.color?.withValues(alpha: .7),
                ),
              );
            },
          ),
        ),
        title: InfinityMarquee(
          child: Text(
            widget.album.title,
          ),
        ),
        subtitle: InfinityMarquee(
          child: Text(
            widget.album.artist.name,
          ),
        ),
        trailing: widget.staticTile
            ? null
            : AlbumOptions(
                getTrackUsecase: widget.getTrackUsecase,
                album: widget.album,
                coreController: widget.coreController,
                playerController: widget.playerController,
                getAlbumUsecase: widget.getAlbumUsecase,
                getPlaylistUsecase: widget.getPlaylistUsecase,
                downloaderController: widget.downloaderController,
                getPlayableItemUsecase: widget.getPlayableItemUsecase,
                libraryController: widget.libraryController,
                getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                getArtistTracksUsecase: widget.getArtistTracksUsecase,
                getArtistUsecase: widget.getArtistUsecase,
              ),
      ),
    );
  }
}
