import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:musily/core/data/services/tray_service.dart';
import 'package:musily/core/data/services/updater_service.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/pages/d_core_page.dart';
import 'package:musily/core/presenter/pages/m_core_page.dart';
import 'package:musily/core/presenter/ui/utils/ly_disposable.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/screen_handler.dart';
import 'package:musily/core/presenter/widgets/updater_dialog.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

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
  final GetTrackUsecase getTrackUsecase;

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
    required this.getTrackUsecase,
  });

  @override
  State<CorePage> createState() => _CorePageState();
}

class _CorePageState extends State<CorePage> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TrayService.initContextMenu(context);
      if (UpdaterService.instance.hasUpdate) {
        UpdaterDialog.show(context);
      }
    });
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
          widget.settingsController.data.copyWith(context: context),
        );
      },
      child: widget.coreController.builder(
        builder: (context, data) {
          widget.coreController.methods.loadWindowProperties();
          return LyPage(
            mainPage: true,
            child: ScreenHandler(
              key: widget.coreController.coreKey,
              mobile: MCorePage(
                playerController: widget.playerController,
                downloaderController: widget.downloaderController,
                libraryController: widget.libraryController,
                getAlbumUsecase: widget.getAlbumUsecase,
                getPlayableItemUsecase: widget.getPlayableItemUsecase,
                getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                getArtistTracksUsecase: widget.getArtistTracksUsecase,
                coreController: widget.coreController,
                getArtistUsecase: widget.getArtistUsecase,
                getPlaylistUsecase: widget.getPlaylistUsecase,
                getTrackUsecase: widget.getTrackUsecase,
              ),
              desktop: DCorePage(
                coreController: widget.coreController,
                playerController: widget.playerController,
                downloaderController: widget.downloaderController,
                libraryController: widget.libraryController,
                getAlbumUsecase: widget.getAlbumUsecase,
                getPlayableItemUsecase: widget.getPlayableItemUsecase,
                getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                getArtistTracksUsecase: widget.getArtistTracksUsecase,
                getArtistUsecase: widget.getArtistUsecase,
                getPlaylistUsecase: widget.getPlaylistUsecase,
                getTrackUsecase: widget.getTrackUsecase,
              ),
              // TODO: Implement other screens
            ),
          );
        },
      ),
    );
  }
}
