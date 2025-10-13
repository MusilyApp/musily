import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/data/usecases/get_playable_item_usecase_impl.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/pages/core_page.dart';
import 'package:musily/core/shared_module.dart';
import 'package:musily/features/_library_module/library_module.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/_search_module/search_module.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';
import 'package:musily/features/_sections_module/sections_module.dart';
import 'package:musily/features/album/data/usecases/get_album_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_albums_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_singles_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_tracks_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_usecase_impl.dart';
import 'package:musily/features/downloader/downloader_module.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/data/usecases/get_playlist_usecase_impl.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';
import 'package:musily/features/track/data/usecases/get_track_usecase_impl.dart';

class CoreModule extends Module {
  @override
  List<Module> get imports => [SharedModule()];

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(
      '/',
      child: (context) => CorePage(
        coreController: Modular.get<CoreController>(),
        downloaderController: Modular.get<DownloaderController>(),
        getAlbumUsecase: Modular.get<GetAlbumUsecaseImpl>(),
        getArtistUsecase: Modular.get<GetArtistUsecaseImpl>(),
        getPlayableItemUsecase: Modular.get<GetPlayableItemUsecaseImpl>(),
        libraryController: Modular.get<LibraryController>(),
        playerController: Modular.get<PlayerController>(),
        resultsPageController: Modular.get<ResultsPageController>(),
        getTrackUsecase: Modular.get<GetTrackUsecaseImpl>(),
        getArtistAlbumsUsecase: Modular.get<GetArtistAlbumsUsecaseImpl>(),
        getArtistTracksUsecase: Modular.get<GetArtistTracksUsecaseImpl>(),
        getArtistSinglesUsecase: Modular.get<GetArtistSinglesUsecaseImpl>(),
        getPlaylistUsecase: Modular.get<GetPlaylistUsecaseImpl>(),
        sectionsController: Modular.get<SectionsController>(),
        settingsController: Modular.get<SettingsController>(),
      ),
      children: [
        ModuleRoute(
          '/sections/',
          module: SectionsModule(),
          transition: TransitionType.noTransition,
        ),
        ModuleRoute(
          '/search/',
          module: SearchModule(),
          transition: TransitionType.noTransition,
        ),
        ModuleRoute(
          '/library/',
          module: LibraryModule(),
          transition: TransitionType.noTransition,
        ),
        ModuleRoute(
          '/downloader/',
          module: DownloaderModule(),
          transition: TransitionType.noTransition,
        ),
      ],
    );
  }
}
