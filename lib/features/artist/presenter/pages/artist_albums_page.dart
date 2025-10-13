import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/widgets/album_tile.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class ArtistAlbumsPage extends StatefulWidget {
  final List<AlbumEntity> albums;
  final ArtistEntity artist;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final CoreController coreController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final PlayerController playerController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final DownloaderController downloaderController;
  final GetAlbumUsecase getAlbumUsecase;
  final void Function(List<AlbumEntity> albums) onLoadedAlbums;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;

  const ArtistAlbumsPage({
    super.key,
    required this.albums,
    required this.artist,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.coreController,
    required this.playerController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.downloaderController,
    required this.getAlbumUsecase,
    required this.onLoadedAlbums,
    required this.getArtistUsecase,
    required this.getArtistSinglesUsecase,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<ArtistAlbumsPage> createState() => _ArtistAlbumsPageState();
}

class _ArtistAlbumsPageState extends State<ArtistAlbumsPage> {
  List<AlbumEntity> allAlbums = [];
  bool loadingAlbums = false;

  Future<void> loadAlbums() async {
    if (widget.albums.isNotEmpty) {
      allAlbums = widget.albums;
      return;
    }
    setState(() {
      loadingAlbums = true;
    });
    try {
      final albums = await widget.getArtistAlbumsUsecase.exec(
        widget.artist.id,
      );
      setState(() {
        allAlbums = albums;
      });
      widget.onLoadedAlbums(allAlbums);
    } catch (e) {
      setState(() {
        allAlbums = [];
      });
    }
    setState(() {
      loadingAlbums = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'ArtistAlbumsPage_${widget.artist.id}',
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.localization.albums),
        ),
        body: Builder(
          builder: (context) {
            if (loadingAlbums) {
              return Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: context.themeData.colorScheme.primary,
                  size: 50,
                ),
              );
            }
            if (allAlbums.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.album_rounded,
                      size: 50,
                      color: context.themeData.iconTheme.color
                          ?.withValues(alpha: .5),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      context.localization.noMoreAlbums,
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: allAlbums.length,
                    itemBuilder: (context, index) {
                      final album = allAlbums[index];
                      return AlbumTile(
                        album: album,
                        getTrackUsecase: widget.getTrackUsecase,
                        contentOrigin: ContentOrigin.dataFetch,
                        coreController: widget.coreController,
                        getPlaylistUsecase: widget.getPlaylistUsecase,
                        playerController: widget.playerController,
                        getPlayableItemUsecase: widget.getPlayableItemUsecase,
                        libraryController: widget.libraryController,
                        downloaderController: widget.downloaderController,
                        getAlbumUsecase: widget.getAlbumUsecase,
                        getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                        getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                        getArtistTracksUsecase: widget.getArtistTracksUsecase,
                        getArtistUsecase: widget.getArtistUsecase,
                      );
                    },
                  ),
                ),
                PlayerSizedBox(
                  playerController: widget.playerController,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
