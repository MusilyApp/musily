import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/data/usecases/get_playable_item_usecase_impl.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_search_module/data/datasources/search_datasource_impl.dart';
import 'package:musily/features/_search_module/data/repositories/search_repository_impl.dart';
import 'package:musily/features/_search_module/data/usecases/get_search_suggestions_usecase_impl.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/_search_module/presenter/pages/search_page.dart';
import 'package:musily/features/album/data/usecases/get_album_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_albums_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_singles_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_tracks_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_usecase_impl.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';

class SearchModule extends Module {
  @override
  void binds(Injector i) {
    super.binds(i);
    i.addLazySingleton(SearchDatasourceImpl.new);
    i.addLazySingleton(
      () => SearchRepositoryImpl(
        searchDatasource: i.get<SearchDatasourceImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetSearchSuggestionsUsecaseImpl(
        searchRepository: i.get<SearchRepositoryImpl>(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(
      '/',
      child: (context) => SearchPage(
        coreController: Modular.get<CoreController>(),
        downloaderController: Modular.get<DownloaderController>(),
        getAlbumUsecase: Modular.get<GetAlbumUsecaseImpl>(),
        getArtistUsecase: Modular.get<GetArtistUsecaseImpl>(),
        getPlayableItemUsecase: Modular.get<GetPlayableItemUsecaseImpl>(),
        libraryController: Modular.get<LibraryController>(),
        playerController: Modular.get<PlayerController>(),
        resultsPageController: Modular.get<ResultsPageController>(),
        getArtistAlbumsUsecase: Modular.get<GetArtistAlbumsUsecaseImpl>(),
        getArtistTracksUsecase: Modular.get<GetArtistTracksUsecaseImpl>(),
        getArtistSinglesUsecase: Modular.get<GetArtistSinglesUsecaseImpl>(),
        getSearchSuggestionsUsecase:
            Modular.get<GetSearchSuggestionsUsecaseImpl>(),
      ),
    );
  }
}
