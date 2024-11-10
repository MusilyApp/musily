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
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/widgets/artist_tile.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class ArtistResultsPage extends StatefulWidget {
  final ResultsPageController resultsPageController;
  final CoreController coreController;
  final PlayerController playerController;
  final String searchQuery;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final LibraryController libraryController;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const ArtistResultsPage({
    required this.resultsPageController,
    required this.searchQuery,
    required this.playerController,
    required this.coreController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    super.key,
    required this.libraryController,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  State<ArtistResultsPage> createState() => _ArtistResultsPageState();
}

class _ArtistResultsPageState extends State<ArtistResultsPage> {
  @override
  void initState() {
    super.initState();
    if (!widget.resultsPageController.data.keepSearchArtistState) {
      widget.resultsPageController.methods.searchArtists(
        widget.searchQuery,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.resultsPageController.builder(
        builder: (context, data) {
          if (data.searchingArtists) {
            return Skeletonizer(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) => LyListTile(
                  leading: const Icon(
                    Icons.music_note,
                  ),
                  title: Text(generatePlaceholderString()),
                  subtitle: Text(generatePlaceholderString()),
                ),
              ),
            );
          }
          if (data.artistsResult.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 50,
                    color: context.themeData.iconTheme.color?.withOpacity(.5),
                  ),
                  Text(
                    context.localization.noResults,
                    style: TextStyle(
                      color: context.themeData.iconTheme.color?.withOpacity(.5),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView(
            children: [
              ...data.artistsResult.items.map(
                (artist) => ArtistTile(
                  artist: artist,
                  getAlbumUsecase: widget.getAlbumUsecase,
                  coreController: widget.coreController,
                  downloaderController: widget.downloaderController,
                  getPlayableItemUsecase: widget.getPlayableItemUsecase,
                  libraryController: widget.libraryController,
                  playerController: widget.playerController,
                  getArtistUsecase: widget.getArtistUsecase,
                  getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                  getArtistTracksUsecase: widget.getArtistTracksUsecase,
                  getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                  contentOrigin: ContentOrigin.dataFetch,
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
