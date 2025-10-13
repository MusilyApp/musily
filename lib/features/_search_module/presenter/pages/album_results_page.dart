import 'package:flutter/material.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/core/utils/generate_placeholder_string.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/widgets/album_tile.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class AlbumResultsPage extends StatefulWidget {
  final String searchQuery;
  final ResultsPageController resultsPageController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final CoreController coreController;
  final LibraryController libraryController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final DownloaderController downloaderController;
  final PlayerController playerController;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;

  const AlbumResultsPage({
    required this.resultsPageController,
    required this.searchQuery,
    required this.getAlbumUsecase,
    required this.coreController,
    required this.libraryController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.playerController,
    super.key,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<AlbumResultsPage> createState() => _AlbumResultsPageState();
}

class _AlbumResultsPageState extends State<AlbumResultsPage> {
  @override
  void initState() {
    super.initState();
    if (!widget.resultsPageController.data.keepSearchAlbumState) {
      widget.resultsPageController.methods.searchAlbums(
        widget.searchQuery,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.resultsPageController.builder(
        builder: (context, data) {
          if (data.searchingAlbums) {
            return Skeletonizer(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) => LyListTile(
                  leading: const Icon(
                    Icons.music_note,
                  ),
                  title: Text(generatePlaceholderString()),
                  subtitle: Text(generatePlaceholderString()),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.music_note,
                    ),
                  ),
                ),
              ),
            );
          }
          if (data.albumsResult.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 50,
                    color: context.themeData.iconTheme.color
                        ?.withValues(alpha: .5),
                  ),
                  Text(
                    context.localization.noResults,
                    style: TextStyle(
                      color: context.themeData.iconTheme.color
                          ?.withValues(alpha: .5),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView(
            children: [
              ...data.albumsResult.items.map(
                (album) => AlbumTile(
                  getTrackUsecase: widget.getTrackUsecase,
                  contentOrigin: ContentOrigin.dataFetch,
                  playerController: widget.playerController,
                  album: album,
                  coreController: widget.coreController,
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
              PlayerSizedBox(
                playerController: widget.playerController,
              ),
            ],
          );
        },
      ),
    );
  }
}
