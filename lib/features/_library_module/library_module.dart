import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/data/usecases/get_playable_item_usecase_impl.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/pages/library_page.dart';
import 'package:musily/features/album/data/usecases/get_album_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_albums_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_singles_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_tracks_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_usecase_impl.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/data/usecases/get_playlist_usecase_impl.dart';

class LibraryModule extends Module {
  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(
      '/',
      child: (context) => LibraryPage(
        coreController: Modular.get<CoreController>(),
        downloaderController: Modular.get<DownloaderController>(),
        getAlbumUsecase: Modular.get<GetAlbumUsecaseImpl>(),
        getPlayableItemUsecase: Modular.get<GetPlayableItemUsecaseImpl>(),
        libraryController: Modular.get<LibraryController>(),
        playerController: Modular.get<PlayerController>(),
        getPlaylistUsecase: Modular.get<GetPlaylistUsecaseImpl>(),
        getArtistUsecase: Modular.get<GetArtistUsecaseImpl>(),
        getArtistAlbumsUsecase: Modular.get<GetArtistAlbumsUsecaseImpl>(),
        getArtistTracksUsecase: Modular.get<GetArtistTracksUsecaseImpl>(),
        getArtistSinglesUsecase: Modular.get<GetArtistSinglesUsecaseImpl>(),
      ),
    );
  }
}
