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

class ArtistSinglesPage extends StatefulWidget {
  final List<AlbumEntity> singles;
  final ArtistEntity artist;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final CoreController coreController;
  final PlayerController playerController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final DownloaderController downloaderController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final void Function(List<AlbumEntity> albums) onLoadedSingles;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;

  const ArtistSinglesPage({
    super.key,
    required this.singles,
    required this.artist,
    required this.getArtistSinglesUsecase,
    required this.getArtistTracksUsecase,
    required this.coreController,
    required this.playerController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.downloaderController,
    required this.getAlbumUsecase,
    required this.onLoadedSingles,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getPlaylistUsecase,
  });

  @override
  State<ArtistSinglesPage> createState() => _ArtistSinglesPageState();
}

class _ArtistSinglesPageState extends State<ArtistSinglesPage> {
  List<AlbumEntity> allSingles = [];
  bool loadingSingles = false;

  Future<void> loadAlbums() async {
    if (widget.singles.isNotEmpty) {
      allSingles = widget.singles;
      return;
    }
    setState(() {
      loadingSingles = true;
    });
    try {
      final singles = await widget.getArtistSinglesUsecase.exec(
        widget.artist.id,
      );
      setState(() {
        allSingles = singles;
      });
      widget.onLoadedSingles(allSingles);
    } catch (e) {
      setState(() {
        allSingles = [];
      });
    }
    setState(() {
      loadingSingles = false;
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
      contextKey: 'ArtistSinglesPage_${widget.artist.id}',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.localization.singles,
          ),
        ),
        body: Builder(
          builder: (context) {
            if (loadingSingles) {
              return Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: context.themeData.colorScheme.primary,
                  size: 50,
                ),
              );
            }
            if (allSingles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.album_rounded,
                      size: 50,
                      color: context.themeData.iconTheme.color?.withOpacity(.7),
                    ),
                    Text(
                      context.localization.noMoreSingles,
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: allSingles.length,
                    itemBuilder: (context, index) {
                      final album = allSingles[index];
                      return AlbumTile(
                        album: album,
                        contentOrigin: ContentOrigin.dataFetch,
                        coreController: widget.coreController,
                        playerController: widget.playerController,
                        getPlayableItemUsecase: widget.getPlayableItemUsecase,
                        libraryController: widget.libraryController,
                        downloaderController: widget.downloaderController,
                        getAlbumUsecase: widget.getAlbumUsecase,
                        getPlaylistUsecase: widget.getPlaylistUsecase,
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
