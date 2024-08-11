import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/animated_size_widget.dart';
import 'package:musily/core/utils/app_navigator.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/pages/library_page.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily_player/presenter/widgets/mini_player_widget.dart';

class CorePage extends StatefulWidget {
  final CoreController coreController;
  final DownloaderController downloaderController;
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final LibraryController libraryController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistUsecase getArtistUsecase;
  final ResultsPageController resultsPageController;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final SectionsController sectionsController;

  const CorePage({
    required this.coreController,
    super.key,
    required this.downloaderController,
    required this.playerController,
    required this.getAlbumUsecase,
    required this.libraryController,
    required this.getPlayableItemUsecase,
    required this.getArtistUsecase,
    required this.resultsPageController,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
    required this.getPlaylistUsecase,
    required this.sectionsController,
  });

  @override
  State<CorePage> createState() => _CorePageState();
}

class _CorePageState extends State<CorePage> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  int _selected = 0;
  final routes = [
    NavigatorPages.sectionsPage,
    NavigatorPages.searchPage,
    NavigatorPages.libraryPage,
    NavigatorPages.downloaderPage,
  ];

  @override
  void initState() {
    super.initState();

    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.coreController.builder(
      eventListener: (context, event, data) {
        if (event.id == 'pushModal') {
          showModalBottomSheet(
            context: context,
            builder: (context) => event.data,
          );
        }
        if (event.id == 'closePlayer') {
          widget.playerController.methods.closePlayer();
        }
      },
      builder: (context, data) {
        final isDesktop = MediaQuery.of(context).size.width > 1100;
        return LayoutBuilder(builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;
          return PopScope(
            canPop: data.pages.isEmpty,
            child: Scaffold(
              bottomNavigationBar: isDesktop
                  ? null
                  : BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      items: [
                        BottomNavigationBarItem(
                          label: AppLocalizations.of(context)!.home,
                          icon: const Icon(Icons.home_rounded),
                        ),
                        BottomNavigationBarItem(
                          label: AppLocalizations.of(context)!.search,
                          icon: const Icon(Icons.search_rounded),
                        ),
                        BottomNavigationBarItem(
                          label: AppLocalizations.of(context)!.library,
                          icon: const Icon(Icons.library_music_rounded),
                        ),
                        BottomNavigationBarItem(
                          label: AppLocalizations.of(context)!.downloads,
                          icon: const Icon(
                            Icons.download_rounded,
                          ),
                        ),
                      ],
                      currentIndex: _selected,
                      onTap: (value) {
                        setState(
                          () {
                            _selected = value;
                            AppNavigator.navigateTo(
                              routes[value],
                            );
                          },
                        );
                      },
                    ),
              body: widget.playerController.builder(
                builder: (context, data) {
                  return Stack(
                    children: [
                      if (!isDesktop)
                        const RouterOutlet()
                      else
                        SizedBox(
                          height: data.currentPlayingItem != null
                              ? availableHeight - 75
                              : availableHeight,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 144,
                                      width: 300,
                                      child: Card(
                                        margin: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: BorderSide(
                                            strokeAlign: 1,
                                            color: Theme.of(context)
                                                .dividerColor
                                                .withOpacity(.2),
                                          ),
                                        ),
                                        child: Scaffold(
                                          body: Column(
                                            children: [
                                              ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    _selected = 0;
                                                    AppNavigator.navigateTo(
                                                      routes[0],
                                                    );
                                                  });
                                                  if (_selected != 0) {
                                                    widget.coreController
                                                        .updateData(
                                                      widget.coreController.data
                                                          .copyWith(
                                                        pages: [],
                                                      ),
                                                    );
                                                  }
                                                },
                                                leading: Icon(
                                                  Icons.home_rounded,
                                                  color: _selected == 0
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : null,
                                                ),
                                                title: Text(
                                                  AppLocalizations.of(context)!
                                                      .home,
                                                  style: TextStyle(
                                                    color: _selected == 0
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    _selected = 1;
                                                    AppNavigator.navigateTo(
                                                      routes[1],
                                                    );
                                                  });
                                                  if (_selected != 1) {
                                                    widget.coreController
                                                        .updateData(
                                                      widget.coreController.data
                                                          .copyWith(
                                                        pages: [],
                                                      ),
                                                    );
                                                  }
                                                },
                                                leading: Icon(
                                                  Icons.search_rounded,
                                                  color: _selected == 1
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : null,
                                                ),
                                                title: Text(
                                                  AppLocalizations.of(context)!
                                                      .search,
                                                  style: TextStyle(
                                                    color: _selected == 1
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    _selected = 3;
                                                    AppNavigator.navigateTo(
                                                      routes[3],
                                                    );
                                                  });
                                                  if (_selected != 3) {
                                                    widget.coreController
                                                        .updateData(
                                                      widget.coreController.data
                                                          .copyWith(
                                                        pages: [],
                                                      ),
                                                    );
                                                  }
                                                },
                                                leading: Icon(
                                                  Icons.download_rounded,
                                                  color: _selected == 3
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : null,
                                                ),
                                                title: Text(
                                                  AppLocalizations.of(context)!
                                                      .downloads,
                                                  style: TextStyle(
                                                    color: _selected == 3
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Card(
                                          margin: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                              strokeAlign: 1,
                                              color: Theme.of(context)
                                                  .dividerColor
                                                  .withOpacity(.2),
                                            ),
                                          ),
                                          child: LibraryPage(
                                            playerController:
                                                widget.playerController,
                                            getAlbumUsecase:
                                                widget.getAlbumUsecase,
                                            coreController:
                                                widget.coreController,
                                            libraryController:
                                                widget.libraryController,
                                            downloaderController:
                                                widget.downloaderController,
                                            getPlayableItemUsecase:
                                                widget.getPlayableItemUsecase,
                                            getPlaylistUsecase:
                                                widget.getPlaylistUsecase,
                                            getArtistUsecase:
                                                widget.getArtistUsecase,
                                            getArtistAlbumsUsecase:
                                                widget.getArtistAlbumsUsecase,
                                            getArtistTracksUsecase:
                                                widget.getArtistTracksUsecase,
                                            getArtistSinglesUsecase:
                                                widget.getArtistSinglesUsecase,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                    right: 8,
                                  ),
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        strokeAlign: 1,
                                        color: Theme.of(context)
                                            .dividerColor
                                            .withOpacity(.2),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: const RouterOutlet(),
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedSizeWidget(
                                key: Key(data.hashCode.toString()),
                                width: (data.showLyrics || data.showQueue)
                                    ? 395
                                    : 0,
                                height: 20,
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: MiniPlayerWidget(
                          playerController: widget.playerController,
                          downloaderController: widget.downloaderController,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        });
      },
    );
  }
}
