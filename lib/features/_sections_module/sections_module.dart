import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/data/usecases/get_playable_item_usecase_impl.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/shared_module.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';
import 'package:musily/features/_sections_module/presenter/pages/sections_page.dart';
import 'package:musily/features/album/data/usecases/get_album_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_albums_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_singles_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_tracks_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_usecase_impl.dart';
import 'package:musily/features/auth/presenter/controllers/auth_controller/auth_controller.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/track/data/usecases/get_track_usecase_impl.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/data/usecases/get_playlist_usecase_impl.dart';

class SectionsModule extends Module {
  @override
  List<Module> get imports => [SharedModule()];

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(
      '/',
      child: (context) => SectionsPage(
        getAlbumUsecase: Modular.get<GetAlbumUsecaseImpl>(),
        sectionsController: Modular.get<SectionsController>(),
        coreController: Modular.get<CoreController>(),
        playerController: Modular.get<PlayerController>(),
        getPlaylistUsecase: Modular.get<GetPlaylistUsecaseImpl>(),
        downloaderController: Modular.get<DownloaderController>(),
        getPlayableItemUsecase: Modular.get<GetPlayableItemUsecaseImpl>(),
        libraryController: Modular.get<LibraryController>(),
        getArtistUsecase: Modular.get<GetArtistUsecaseImpl>(),
        getArtistAlbumsUsecase: Modular.get<GetArtistAlbumsUsecaseImpl>(),
        getArtistTracksUsecase: Modular.get<GetArtistTracksUsecaseImpl>(),
        getArtistSinglesUsecase: Modular.get<GetArtistSinglesUsecaseImpl>(),
        getTrackUsecase: Modular.get<GetTrackUsecaseImpl>(),
        settingsController: Modular.get<SettingsController>(),
        authController: Modular.get<AuthController>(),
      ),
    );
  }
}
