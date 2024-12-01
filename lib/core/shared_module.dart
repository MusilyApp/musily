import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/data/adapters/http_adapter_impl.dart';
import 'package:musily/core/data/database/library_database.dart';
import 'package:musily/core/data/repositories/musily_repository_impl.dart';
import 'package:musily/core/data/usecases/get_playable_item_usecase_impl.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/features/_library_module/data/datasources/library_datasource_impl.dart';
import 'package:musily/features/_library_module/data/repositories/library_repository_impl.dart';
import 'package:musily/features/_library_module/data/usecases/add_album_to_library_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/add_artist_to_library_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/add_tracks_to_playlist_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/create_playlist_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/delete_playlist_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/get_library_item_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/get_library_items_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/merge_library_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/remove_album_from_library_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/remove_artist_from_library_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/remove_tracks_from_playlist_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/update_library_item_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/update_playlist_usecase_impl.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_search_module/data/datasources/search_datasource_impl.dart';
import 'package:musily/features/_search_module/data/repositories/search_repository_impl.dart';
import 'package:musily/features/_search_module/data/usecases/get_search_suggestions_usecase_impl.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/_sections_module/data/datasources/sections_datasource_impl.dart';
import 'package:musily/features/_sections_module/data/repositories/sections_repository_impl.dart';
import 'package:musily/features/_sections_module/data/usecases/get_sections_usecase_impl.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';
import 'package:musily/features/album/data/datasources/album_datasource_impl.dart';
import 'package:musily/features/album/data/repositories/album_repository_impl.dart';
import 'package:musily/features/album/data/usecases/get_album_usecase_impl.dart';
import 'package:musily/features/album/data/usecases/get_albums_usecase_impl.dart';
import 'package:musily/features/artist/data/datasources/artists_datasource_impl.dart';
import 'package:musily/features/artist/data/repository/artist_repository_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_albums_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_singles_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_tracks_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artists_usecase_impl.dart';
import 'package:musily/features/auth/data/datasource/auth_datasource_impl.dart';
import 'package:musily/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:musily/features/auth/data/usecases/create_account_usecase_impl.dart';
import 'package:musily/features/auth/data/usecases/get_current_user_usecase_impl.dart';
import 'package:musily/features/auth/data/usecases/login_usecase_impl.dart';
import 'package:musily/features/auth/data/usecases/logout_usecase_impl.dart';
import 'package:musily/features/auth/presenter/controllers/auth_controller/auth_controller.dart';
import 'package:musily/features/player/data/datasources/player_datasource_impl.dart';
import 'package:musily/features/player/data/repositories/player_repository_impl.dart';
import 'package:musily/features/player/data/usecases/get_smart_queue_usecase_impl.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/playlist/data/datasources/playlist_datasource_impl.dart';
import 'package:musily/features/playlist/data/repositories/playlist_repository_impl.dart';
import 'package:musily/features/playlist/data/usecases/get_playlist_usecase_impl.dart';
import 'package:musily/features/track/data/datasources/track_datasource_impl.dart';
import 'package:musily/features/track/data/repositories/track_respository_impl.dart';
import 'package:musily/features/track/data/usecases/get_track_lyrics_usecase_impl.dart';
import 'package:musily/features/track/data/usecases/get_track_usecase_impl.dart';
import 'package:musily/features/track/data/usecases/get_tracks_usecase_impl.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';

class SharedModule extends Module {
  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);

    final musilyRepository = MusilyRepositoryImpl();

    i.addLazySingleton(
      () => CoreController(
        playerController: i.get<PlayerController>(),
        downloaderController: i.get<DownloaderController>(),
        libraryController: i.get<LibraryController>(),
        getPlayableItemUsecase: i.get<GetPlayableItemUsecaseImpl>(),
        getTrackUsecase: i.get<GetTrackUsecaseImpl>(),
        getAlbumUsecase: i.get<GetAlbumUsecaseImpl>(),
        getArtistUsecase: i.get<GetArtistUsecaseImpl>(),
        getArtistAlbumsUsecase: i.get<GetArtistAlbumsUsecaseImpl>(),
        getArtistTracksUsecase: i.get<GetArtistTracksUsecaseImpl>(),
        getArtistSinglesUsecase: i.get<GetArtistSinglesUsecaseImpl>(),
      ),
    );
    i.addLazySingleton(
      HttpAdapterImpl.new,
    );

    // Player dependencies
    i.addLazySingleton(
      () => PlayerDatasourceImpl(
        musilyRepository: musilyRepository,
      ),
    );
    i.addLazySingleton(
      () => PlayerRepositoryImpl(
        playerDatasource: i.get<PlayerDatasourceImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetSmartQueueUsecaseImpl(
        playerRepository: i.get<PlayerRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => PlayerController(
        getPlayableItemUsecase: i.get<GetPlayableItemUsecaseImpl>(),
        getTrackLyricsUsecase: i.get<GetTrackLyricsUsecaseImpl>(),
        getSmartQueueUsecase: i.get<GetSmartQueueUsecaseImpl>(),
      ),
    );

    // Section dependencies
    i.addLazySingleton(
      () => SectionsDatasourceImpl(
        musilyRepository: musilyRepository,
      ),
    );
    i.addLazySingleton(
      () => SectionsRepositoryImpl(
        sectionsDatasource: i.get<SectionsDatasourceImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetSectionsUsecaseImpl(
        sectionsRepository: i.get<SectionsRepositoryImpl>(),
      ),
    );
    i.addLazySingleton<SectionsController>(
      () => SectionsController(
        getSectionsUsecase: i.get<GetSectionsUsecaseImpl>(),
        getLibraryItemsUsecase: i.get<GetLibraryItemsUsecaseImpl>(),
      ),
    );

    // Library Dependencies
    i.addLazySingleton(
      LibraryDatabase.new,
    );
    i.addLazySingleton(
      () => LibraryDatasourceImpl(
        httpAdapter: i.get<HttpAdapterImpl>(),
        modelAdapter: i.get<LibraryDatabase>(),
      ),
    );
    i.addLazySingleton(
      () => LibraryRepositoryImpl(
        libraryDatasource: i.get<LibraryDatasourceImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetLibraryItemUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetLibraryItemsUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => UpdatePlaylistUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => AddTracksToPlaylistUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => CreatePlaylistUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => RemoveTracksFromPlaylistUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => AddArtistToLibraryUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => RemoveArtistFromLibraryUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => AddAlbumToLibraryUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => RemoveAlbumFromLibraryUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => DeletePlaylistUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => UpdateLibraryItemUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => MergeLibraryUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => LibraryController(
        getLibraryUsecase: i.get<GetLibraryItemsUsecaseImpl>(),
        getLibraryItemUsecase: i.get<GetLibraryItemUsecaseImpl>(),
        downloaderController: i.get<DownloaderController>(),
        playerController: i.get<PlayerController>(),
        updatePlaylistUsecase: i.get<UpdatePlaylistUsecaseImpl>(),
        addTracksToPlaylistUsecase: i.get<AddTracksToPlaylistUsecaseImpl>(),
        createPlaylistUsecase: i.get<CreatePlaylistUsecaseImpl>(),
        removeTracksFromPlaylistUsecase:
            i.get<RemoveTracksFromPlaylistUsecaseImpl>(),
        addArtistToLibraryUsecase: i.get<AddArtistToLibraryUsecaseImpl>(),
        removeArtistFromLibraryUsecase:
            i.get<RemoveArtistFromLibraryUsecaseImpl>(),
        addAlbumToLibraryUsecase: i.get<AddAlbumToLibraryUsecaseImpl>(),
        removeAlbumFromLibraryUsecase:
            i.get<RemoveAlbumFromLibraryUsecaseImpl>(),
        deletePlaylistUsecase: i.get<DeletePlaylistUsecaseImpl>(),
        updateLibraryItemUsecase: i.get<UpdateLibraryItemUsecaseImpl>(),
        mergeLibraryUsecase: i.get<MergeLibraryUsecaseImpl>(),
      ),
    );

    // Downloader dependencies
    i.addLazySingleton(
      () => GetPlayableItemUsecaseImpl(
        musilyRepository: musilyRepository,
      ),
    );
    i.addLazySingleton(
      () => DownloaderController(),
    );

    // Album dependencies
    i.addLazySingleton(
      () => AlbumDatasourceImpl(
        downloaderController: i.get<DownloaderController>(),
        libraryDatasource: i.get<LibraryDatasourceImpl>(),
        musilyRepository: musilyRepository,
      ),
    );
    i.addLazySingleton(
      () => AlbumRepositoryImpl(
        albumDatasource: i.get<AlbumDatasourceImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetAlbumUsecaseImpl(
        albumRepository: i.get<AlbumRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetAlbumsUsecaseImpl(
        albumRepository: i.get<AlbumRepositoryImpl>(),
      ),
    );

    // Track dependencies
    i.addLazySingleton(
      () => TrackDatasourceImpl(
        downloaderController: i.get<DownloaderController>(),
        musilyRepository: musilyRepository,
      ),
    );
    i.addLazySingleton(
      () => TrackRespositoryImpl(
        trackDatasource: i.get<TrackDatasourceImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetTrackUsecaseImpl(
        trackRepository: i.get<TrackRespositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetTracksUsecaseImpl(
        trackRepository: i.get<TrackRespositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetTrackLyricsUsecaseImpl(
        trackRepository: i.get<TrackRespositoryImpl>(),
      ),
    );

    // Artist dependencies
    i.addLazySingleton(
      () => ArtistsDatasourceImpl(
        musilyRepository: musilyRepository,
      ),
    );
    i.addLazySingleton(
      () => ArtistRepositoryImpl(
        artistDatasource: i.get<ArtistsDatasourceImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetArtistsUsecaseImpl(
        artistRepository: i.get<ArtistRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetArtistUsecaseImpl(
        artistRepository: i.get<ArtistRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetArtistTracksUsecaseImpl(
        artistRepository: i.get<ArtistRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetArtistAlbumsUsecaseImpl(
        artistRepository: i.get<ArtistRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetArtistSinglesUsecaseImpl(
        artistRepository: i.get<ArtistRepositoryImpl>(),
      ),
    );

    // Search dependencies
    i.addLazySingleton(
      () => ResultsPageController(
        getTracksUsecase: i.get<GetTracksUsecaseImpl>(),
        getTrackUsecase: i.get<GetTrackUsecaseImpl>(),
        getAlbumsUsecase: i.get<GetAlbumsUsecaseImpl>(),
        getArtistsUsecase: i.get<GetArtistsUsecaseImpl>(),
        playerController: i.get<PlayerController>(),
      ),
    );
    i.addLazySingleton(
      () => GetSearchSuggestionsUsecaseImpl(
        searchRepository: i.get<SearchRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(() => SearchDatasourceImpl(
          musilyRepository: musilyRepository,
        ));
    i.addLazySingleton(
      () => SearchRepositoryImpl(
        searchDatasource: i.get<SearchDatasourceImpl>(),
      ),
    );

    // Playlist dependencies
    i.addLazySingleton(
      () => PlaylistDatasourceImpl(
        libraryDatasource: i.get<LibraryDatasourceImpl>(),
        downloaderController: i.get<DownloaderController>(),
        musilyRepository: musilyRepository,
      ),
    );
    i.addLazySingleton(
      () => PlaylistRepositoryImpl(
        playlistDatasource: i.get<PlaylistDatasourceImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetPlaylistUsecaseImpl(
        playlistRepository: i.get<PlaylistRepositoryImpl>(),
      ),
    );
    // Settings dependencies
    i.addLazySingleton<SettingsController>(
      () => SettingsController(
        httpAdapter: i.get<HttpAdapterImpl>(),
      ),
      config: BindConfig(
        onDispose: (value) => value.dispose(),
      ),
    );

    // Auth dependencies
    i.addSingleton(
      () => AuthDatasourceImpl(
        httpAdapter: i.get<HttpAdapterImpl>(),
        libraryController: i.get<LibraryController>(),
      ),
    );
    i.addLazySingleton(
      () => AuthRepositoryImpl(
        authDatasource: i.get<AuthDatasourceImpl>(),
      ),
    );
    i.addLazySingleton(
      () => LogoutUsecaseImpl(
        authRepository: i.get<AuthRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => LoginUsecaseImpl(
        authRepository: i.get<AuthRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetCurrentUserUsecaseImpl(
        authRepository: i.get<AuthRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => CreateAccountUsecaseImpl(
        authRepository: i.get<AuthRepositoryImpl>(),
      ),
    );
    i.addLazySingleton<AuthController>(
      () => AuthController(
        createAccountUsecase: i.get<CreateAccountUsecaseImpl>(),
        getCurrentUserUsecase: i.get<GetCurrentUserUsecaseImpl>(),
        loginUsecase: i.get<LoginUsecaseImpl>(),
        logoutUsecase: i.get<LogoutUsecaseImpl>(),
      ),
      config: BindConfig(
        onDispose: (value) => value.dispose(),
      ),
    );
  }
}
