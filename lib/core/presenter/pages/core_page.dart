import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/utils/app_navigator.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';
import 'package:musily/features/player/presenter/widgets/mini_player_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      },
      builder: (context, data) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.home,
                icon: Icon(
                  _selected == 0 ? Icons.home_rounded : Icons.home_rounded,
                ),
              ),
              BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.search,
                icon: Icon(
                  _selected == 1 ? Icons.search_rounded : Icons.search_rounded,
                ),
              ),
              BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.library,
                icon: Icon(
                  _selected == 2
                      ? Icons.library_music_rounded
                      : Icons.library_music_rounded,
                ),
              ),
            ],
            currentIndex: _selected,
            onTap: (value) {
              setState(() {
                _selected = value;
                AppNavigator.navigateTo(
                  routes[value],
                );
              });
            },
          ),
          body: widget.coreController.builder(
            builder: (context, data) {
              return Stack(
                children: [
                  const RouterOutlet(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MiniPlayerWidget(
                      downloaderController: widget.downloaderController,
                      playerController: widget.playerController,
                      getAlbumUsecase: widget.getAlbumUsecase,
                      coreController: widget.coreController,
                      libraryController: widget.libraryController,
                      getPlayableItemUsecase: widget.getPlayableItemUsecase,
                      getArtistUsecase: widget.getArtistUsecase,
                      resultsPageController: widget.resultsPageController,
                      getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                      getArtistTracksUsecase: widget.getArtistTracksUsecase,
                      getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
