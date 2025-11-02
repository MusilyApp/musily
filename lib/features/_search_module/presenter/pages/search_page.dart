import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
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
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: LyTextField(
                        hintText: context.localization.searchMusicAlbumOrArtist,
                        autocorrect: false,
                        controller: searchTextController,
                        focusNode: searchFocusNode,
                        onChanged: onSearchTextChanged,
                        onSubmitted: submitSearch,
                        autofocus: true,
                        prefixIcon: Icon(
                          LucideIcons.search,
                          size: 20,
                          color: context.themeData.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.transparent),
                        ),
                        margin: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (searchTextController.text.isNotEmpty)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          searchTextController.text = '';
                          searchFocusNode.requestFocus();
                          setState(() {
                            searchSuggestions = [];
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          child: Icon(
                            LucideIcons.x,
                            size: 18,
                            color: context.themeData.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // Suggestions Header
              if (searchSuggestions.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: context.themeData.colorScheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        context.localization.searchSuggestions,
                        style:
                            context.themeData.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Suggestions List
              Expanded(
                child: searchSuggestions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.search,
                              size: 64,
                              color: context.themeData.colorScheme.onSurface
                                  .withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.localization.searchStartTyping,
                              style: context.themeData.textTheme.bodyLarge
                                  ?.copyWith(
                                color: context.themeData.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: searchSuggestions.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final suggestion = searchSuggestions[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: context
                                  .themeData.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: context.themeData.colorScheme.outline
                                    .withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  submitSearch(suggestion);
                                  searchTextController.text = suggestion;
                                  getSearchSuggestions();
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: context
                                              .themeData.colorScheme.primary
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          LucideIcons.search,
                                          size: 16,
                                          color: context
                                              .themeData.colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          suggestion,
                                          style: context
                                              .themeData.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            searchTextController.text =
                                                suggestion;
                                            getSearchSuggestions();
                                          },
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Icon(
                                              LucideIcons.moveUpLeft,
                                              size: 18,
                                              color: context.themeData
                                                  .colorScheme.onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
