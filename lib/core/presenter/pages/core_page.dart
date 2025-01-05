import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_disposable.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/animated_size_widget.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/pages/library_page.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/player/presenter/widgets/mini_player_widget.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';

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
  final SettingsController settingsController;

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
    required this.settingsController,
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
      widget.coreController.methods.handleDeepLink(uri);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LyDisposable(
      onInitState: () {
        widget.settingsController.updateData(
          widget.settingsController.data.copyWith(
            context: context,
          ),
        );
      },
      child: widget.coreController.builder(
        builder: (context, data) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              return LyPage(
                mainPage: true,
                child: Scaffold(
                  key: widget.coreController.coreKey,
                  bottomNavigationBar: context.display.isDesktop
                      ? null
                      : BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          items: [
                            BottomNavigationBarItem(
                              label: context.localization.home,
                              icon: const Icon(Icons.home_rounded),
                            ),
                            BottomNavigationBarItem(
                              label: context.localization.search,
                              icon: const Icon(Icons.search_rounded),
                            ),
                            BottomNavigationBarItem(
                              label: context.localization.library,
                              icon: const Icon(Icons.library_music_rounded),
                            ),
                            BottomNavigationBarItem(
                              label: context.localization.downloads,
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
                                LyNavigator.navigateTo(
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
                          if (!context.display.isDesktop)
                            const RouterOutlet()
                          else
                            AnimatedSizeWidget(
                              width: context.display.width,
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
                                          width: 310,
                                          child: Card(
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              side: BorderSide(
                                                strokeAlign: 1,
                                                color: context
                                                    .themeData.dividerColor
                                                    .withOpacity(.2),
                                              ),
                                            ),
                                            child: Scaffold(
                                              body: Column(
                                                children: [
                                                  LyListTile(
                                                    onTap: () {
                                                      setState(() {
                                                        _selected = 0;
                                                        LyNavigator.navigateTo(
                                                          routes[0],
                                                        );
                                                      });
                                                    },
                                                    leading: Icon(
                                                      Icons.home_rounded,
                                                      color: _selected == 0
                                                          ? context
                                                              .themeData
                                                              .colorScheme
                                                              .primary
                                                          : null,
                                                    ),
                                                    title: Text(
                                                      context.localization.home,
                                                      style: TextStyle(
                                                        color: _selected == 0
                                                            ? context
                                                                .themeData
                                                                .colorScheme
                                                                .primary
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                  LyListTile(
                                                    onTap: () {
                                                      setState(() {
                                                        _selected = 1;
                                                        LyNavigator.navigateTo(
                                                          routes[1],
                                                        );
                                                      });
                                                    },
                                                    leading: Icon(
                                                      Icons.search_rounded,
                                                      color: _selected == 1
                                                          ? context
                                                              .themeData
                                                              .colorScheme
                                                              .primary
                                                          : null,
                                                    ),
                                                    title: Text(
                                                      context
                                                          .localization.search,
                                                      style: TextStyle(
                                                        color: _selected == 1
                                                            ? context
                                                                .themeData
                                                                .colorScheme
                                                                .primary
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                  LyListTile(
                                                    onTap: () {
                                                      setState(() {
                                                        _selected = 3;
                                                        LyNavigator.navigateTo(
                                                          routes[3],
                                                        );
                                                      });
                                                    },
                                                    leading: Icon(
                                                      Icons.download_rounded,
                                                      color: _selected == 3
                                                          ? context
                                                              .themeData
                                                              .colorScheme
                                                              .primary
                                                          : null,
                                                    ),
                                                    title: Text(
                                                      context.localization
                                                          .downloads,
                                                      style: TextStyle(
                                                        color: _selected == 3
                                                            ? context
                                                                .themeData
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
                                          width: 310,
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
                                                  color: context
                                                      .themeData.dividerColor
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
                                                getPlayableItemUsecase: widget
                                                    .getPlayableItemUsecase,
                                                getPlaylistUsecase:
                                                    widget.getPlaylistUsecase,
                                                getArtistUsecase:
                                                    widget.getArtistUsecase,
                                                getArtistAlbumsUsecase: widget
                                                    .getArtistAlbumsUsecase,
                                                getArtistTracksUsecase: widget
                                                    .getArtistTracksUsecase,
                                                getArtistSinglesUsecase: widget
                                                    .getArtistSinglesUsecase,
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: BorderSide(
                                            strokeAlign: 1,
                                            color: context
                                                .themeData.dividerColor
                                                .withOpacity(.2),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: const RouterOutlet(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  AnimatedSizeWidget(
                                    // key: Key(data.hashCode.toString()),
                                    duration: const Duration(
                                      milliseconds: 150,
                                    ),
                                    width: (data.showLyrics || data.showQueue)
                                        ? 345
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
                              coreController: widget.coreController,
                              getPlaylistUsecase: widget.getPlaylistUsecase,
                              getAlbumUsecase: widget.getAlbumUsecase,
                              getPlayableItemUsecase:
                                  widget.getPlayableItemUsecase,
                              libraryController: widget.libraryController,
                              getArtistAlbumsUsecase:
                                  widget.getArtistAlbumsUsecase,
                              getArtistSinglesUsecase:
                                  widget.getArtistSinglesUsecase,
                              getArtistTracksUsecase:
                                  widget.getArtistTracksUsecase,
                              getArtistUsecase: widget.getArtistUsecase,
                            ),
                          ),
                          widget.coreController.builder(
                              builder: (context, coreData) {
                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: coreData.hadlingDeepLink ||
                                      coreData.backupInProgress
                                  ? 1
                                  : 0,
                              child: AnimatedSizeWidget(
                                width: context.display.width,
                                height: coreData.hadlingDeepLink ||
                                        coreData.backupInProgress
                                    ? context.display.height
                                    : 0,
                                duration: const Duration(milliseconds: 300),
                                color: context.themeData.scaffoldBackgroundColor
                                    .withOpacity(.7),
                                child: Center(
                                  child: LoadingAnimationWidget.halfTriangleDot(
                                    color:
                                        context.themeData.colorScheme.primary,
                                    size: 50,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
