import 'package:flutter/material.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_text_field.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/_search_module/presenter/pages/album_results_page.dart';
import 'package:musily/features/_search_module/presenter/pages/artist_results_page.dart';
import 'package:musily/features/_search_module/presenter/pages/track_results_page.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class ResultsPage extends StatefulWidget {
  final String searchQuery;
  final ResultsPageController resultsPageController;
  final CoreController coreController;
  final GetAlbumUsecase getAlbumUsecase;
  final LibraryController libraryController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistUsecase getArtistUsecase;
  final PlayerController playerController;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const ResultsPage({
    required this.searchQuery,
    required this.resultsPageController,
    required this.getAlbumUsecase,
    required this.coreController,
    required this.libraryController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getArtistUsecase,
    required this.playerController,
    super.key,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchTextController.text = widget.searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return LyPage(
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(
                top: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: LyTextField(
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                      ),
                      onFocus: () {
                        Navigator.pop(context, 'edit');
                      },
                      controller: searchTextController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(300),
                      onTap: () {
                        Navigator.pop(context, 'clear');
                      },
                      child: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(context.localization.songs),
                ),
                Tab(
                  child: Text(context.localization.albums),
                ),
                Tab(
                  child: Text(context.localization.artists),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    TrackResultsPage(
                      resultsPageController: widget.resultsPageController,
                      searchQuery: widget.searchQuery,
                      libraryController: widget.libraryController,
                      getAlbumUsecase: widget.getAlbumUsecase,
                      coreController: widget.coreController,
                      downloaderController: widget.downloaderController,
                      getPlayableItemUsecase: widget.getPlayableItemUsecase,
                      playerController: widget.playerController,
                      getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                      getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                      getArtistTracksUsecase: widget.getArtistTracksUsecase,
                      getArtistUsecase: widget.getArtistUsecase,
                    ),
                    AlbumResultsPage(
                      resultsPageController: widget.resultsPageController,
                      searchQuery: widget.searchQuery,
                      getAlbumUsecase: widget.getAlbumUsecase,
                      coreController: widget.coreController,
                      libraryController: widget.libraryController,
                      downloaderController: widget.downloaderController,
                      getPlayableItemUsecase: widget.getPlayableItemUsecase,
                      playerController: widget.playerController,
                      getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                      getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                      getArtistTracksUsecase: widget.getArtistTracksUsecase,
                      getArtistUsecase: widget.getArtistUsecase,
                    ),
                    ArtistResultsPage(
                      resultsPageController: widget.resultsPageController,
                      searchQuery: widget.searchQuery,
                      coreController: widget.coreController,
                      playerController: widget.playerController,
                      downloaderController: widget.downloaderController,
                      getPlayableItemUsecase: widget.getPlayableItemUsecase,
                      libraryController: widget.libraryController,
                      getAlbumUsecase: widget.getAlbumUsecase,
                      getArtistUsecase: widget.getArtistUsecase,
                      getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                      getArtistTracksUsecase: widget.getArtistTracksUsecase,
                      getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                    ),
                  ],
                ),
              ),
              PlayerSizedBox(
                playerController: widget.playerController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
