import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_search_module/domain/usecases/get_search_suggestions_usecase.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/_search_module/presenter/pages/results_page.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';

class SearchPage extends StatefulWidget {
  final CoreController coreController;
  final ResultsPageController resultsPageController;
  final GetAlbumUsecase getAlbumUsecase;
  final LibraryController libraryController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistUsecase getArtistUsecase;
  final PlayerController playerController;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetSearchSuggestionsUsecase getSearchSuggestionsUsecase;

  const SearchPage({
    required this.coreController,
    required this.downloaderController,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.playerController,
    required this.resultsPageController,
    super.key,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
    required this.getSearchSuggestionsUsecase,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<String> searchSuggestions = [];
  Timer? debounce;

  getSearchSuggestions() async {
    if (searchSuggestions.isEmpty) {
      setState(() {
        searchSuggestions = [];
        return;
      });
    }
    final suggestions = await widget.getSearchSuggestionsUsecase.exec(
      searchTextController.text,
    );
    setState(() {
      searchSuggestions = searchTextController.text.isEmpty ? [] : suggestions;
    });
  }

  submitSearch(String value) async {
    if (value.isEmpty) {
      return;
    }
    final action = await Navigator.of(context).push(
      DownupRouter(
        builder: (context) => ResultsPage(
          searchQuery: searchTextController.text,
          resultsPageController: widget.resultsPageController,
          getAlbumUsecase: widget.getAlbumUsecase,
          coreController: widget.coreController,
          libraryController: widget.libraryController,
          downloaderController: widget.downloaderController,
          getPlayableItemUsecase: widget.getPlayableItemUsecase,
          getArtistUsecase: widget.getArtistUsecase,
          playerController: widget.playerController,
          getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
          getArtistTracksUsecase: widget.getArtistTracksUsecase,
          getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
        ),
      ),
    );
    if (action == 'edit') {
      searchFocusNode.requestFocus();
    }
    if (action == 'clear') {
      searchTextController.text = '';
      setState(() {
        searchSuggestions = [];
      });
      searchFocusNode.requestFocus();
    }
    widget.resultsPageController.updateData(
      widget.resultsPageController.data.copyWith(
        keepSearchTrackState: false,
        keepSearchAlbumState: false,
        keepSearchArtistState: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.coreController.builder(
      eventListener: (context, event, data) {
        if (event.id == 'pushWidget') {
          Navigator.of(context).push(
            DownupRouter(
              builder: (context) => event.data,
            ),
          );
        }
      },
      builder: (context, data) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        autocorrect: false,
                        controller: searchTextController,
                        focusNode: searchFocusNode,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              searchSuggestions = [];
                            });
                            return;
                          }
                          getSearchSuggestions();
                        },
                        onSubmitted: submitSearch,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Buscar música, albúm ou artista',
                          border: InputBorder.none,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Icon(
                              Icons.search,
                            ),
                          ),
                          suffixIcon: searchTextController.text.isEmpty
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: IconButton(
                                    onPressed: () {
                                      searchTextController.text = '';
                                      setState(() {
                                        searchSuggestions = [];
                                      });
                                    },
                                    style: const ButtonStyle(
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    icon: const Icon(
                                      Icons.close,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ...searchSuggestions.map(
                        (suggestion) => ListTile(
                          onTap: () {
                            submitSearch(suggestion);
                            searchTextController.text = suggestion;
                            getSearchSuggestions();
                          },
                          leading: const Icon(Icons.search_rounded),
                          title: Text(suggestion),
                          trailing: IconButton(
                            onPressed: () {
                              searchTextController.text = suggestion;
                              getSearchSuggestions();
                            },
                            icon: const Icon(
                              Icons.north_west,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
