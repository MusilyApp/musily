import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_text_field.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
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
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class SearchPage extends StatefulWidget {
  final CoreController coreController;
  final ResultsPageController resultsPageController;
  final GetAlbumUsecase getAlbumUsecase;
  final LibraryController libraryController;
  final DownloaderController downloaderController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistUsecase getArtistUsecase;
  final PlayerController playerController;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetSearchSuggestionsUsecase getSearchSuggestionsUsecase;
  final GetTrackUsecase getTrackUsecase;
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
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<String> searchSuggestions = [];
  Timer? debounce;

  @override
  void dispose() {
    searchTextController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  getSearchSuggestions() async {
    final suggestions = await widget.getSearchSuggestionsUsecase.exec(
      searchTextController.text,
    );
    setState(() {
      searchSuggestions = searchTextController.text.isEmpty ? [] : suggestions;
    });
  }

  onSearchTextChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        searchSuggestions = [];
      });
      return;
    }

    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }
    debounce = Timer(const Duration(milliseconds: 300), () {
      getSearchSuggestions();
    });
  }

  submitSearch(String value) async {
    if (value.isEmpty) {
      return;
    }
    final action = await Navigator.of(context).push(
      DownupRouter(
        builder: (context) => ResultsPage(
          getTrackUsecase: widget.getTrackUsecase,
          searchQuery: searchTextController.text,
          getPlaylistUsecase: widget.getPlaylistUsecase,
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
    return LyPage(
      contextKey: 'SearchPage',
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: LyTextField(
                        hintText: context.localization.searchMusicAlbumOrArtist,
                        autocorrect: false,
                        controller: searchTextController,
                        focusNode: searchFocusNode,
                        onChanged: onSearchTextChanged,
                        onSubmitted: submitSearch,
                        autofocus: true,
                        prefixIcon: const Icon(
                          LucideIcons.search,
                        ),
                      ),
                    ),
                  ),
                  if (searchTextController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(300),
                        onTap: () {
                          searchTextController.text = '';
                          searchFocusNode.requestFocus();
                          setState(
                            () {
                              searchSuggestions = [];
                            },
                          );
                        },
                        child: const Icon(
                          LucideIcons.x,
                        ),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    ...searchSuggestions.map(
                      (suggestion) => LyListTile(
                        onTap: () {
                          submitSearch(suggestion);
                          searchTextController.text = suggestion;
                          getSearchSuggestions();
                        },
                        leading: const Icon(LucideIcons.search),
                        title: Text(suggestion),
                        trailing: IconButton(
                          onPressed: () {
                            searchTextController.text = suggestion;
                            getSearchSuggestions();
                          },
                          icon: const Icon(
                            LucideIcons.moveUpLeft,
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
      ),
    );
  }
}
