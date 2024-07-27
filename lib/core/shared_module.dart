import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/data/database/library_database.dart';
import 'package:musily/core/data/usecases/get_playable_item_usecase_impl.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/features/_library_module/data/datasources/library_datasource_impl.dart';
import 'package:musily/features/_library_module/data/repositories/library_repository_impl.dart';
import 'package:musily/features/_library_module/data/usecases/add_to_library_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/delete_library_item_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/get_library_item_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/get_library_items_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/get_library_offset_limit_usecase_impl.dart';
import 'package:musily/features/_library_module/data/usecases/update_library_item_usecase_impl.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
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
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';
import 'package:musily/features/playlist/data/datasources/playlist_datasource_impl.dart';
import 'package:musily/features/playlist/data/repositories/playlist_repository_impl.dart';
import 'package:musily/features/playlist/data/usecases/get_playlist_usecase_impl.dart';
import 'package:musily/features/track/data/datasources/track_datasource_impl.dart';
import 'package:musily/features/track/data/repositories/track_respository_impl.dart';
import 'package:musily/features/track/data/usecases/get_track_lyrics_usecase_impl.dart';
import 'package:musily/features/track/data/usecases/get_track_usecase_impl.dart';
import 'package:musily/features/track/data/usecases/get_tracks_usecase_impl.dart';
import 'package:musily_player/musily_player.dart';

class SharedModule extends Module {
  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);
    i.addLazySingleton(CoreController.new);

    i.addLazySingleton(
      () => PlayerController(
        musilyPlayer: MusilyPlayer(),
        getPlayableItemUsecase: i.get<GetPlayableItemUsecaseImpl>(),
        getTrackLyricsUsecase: i.get<GetTrackLyricsUsecaseImpl>(),
      ),
    );

    // Section dependencies
    i.addLazySingleton(
      () => SectionsDatasourceImpl(),
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
        getLibraryOffsetLimitUsecase: i.get<GetLibraryOffsetLimitUsecaseImpl>(),
      ),
    );

    // Library Dependencies
    i.addLazySingleton(
      LibraryDatabase.new,
    );
    i.addLazySingleton(
      () => LibraryDatasourceImpl(
        modelAdapter: i.get<LibraryDatabase>(),
        downloaderController: i.get<DownloaderController>(),
      ),
    );
    i.addLazySingleton(
      () => LibraryRepositoryImpl(
        libraryDatasource: i.get<LibraryDatasourceImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetLibraryOffsetLimitUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetLibraryItemUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => AddToLibraryUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => DeleteLibraryItemUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => UpdateLibraryItemUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => GetLibraryItemsUsecaseImpl(
        libraryRepository: i.get<LibraryRepositoryImpl>(),
      ),
    );
    i.addLazySingleton(
      () => LibraryController(
        getLibraryUsecase: i.get<GetLibraryItemsUsecaseImpl>(),
        addToLibraryUsecase: i.get<AddToLibraryUsecaseImpl>(),
        updateLibraryItemUsecase: i.get<UpdateLibraryItemUsecaseImpl>(),
        getLibraryItemUsecase: i.get<GetLibraryItemUsecaseImpl>(),
        deleteLibraryItemUsecase: i.get<DeleteLibraryItemUsecaseImpl>(),
        downloaderController: i.get<DownloaderController>(),
      ),
    );

    // Downloader dependencies
    i.addLazySingleton(
      () => GetPlayableItemUsecaseImpl(),
    );
    i.addLazySingleton(
      () => DownloaderController(
        getPlayableItemUsecase: i.get<GetPlayableItemUsecaseImpl>(),
      ),
    );

    // Album dependencies
    i.addLazySingleton(
      () => AlbumDatasourceImpl(
          downloaderController: i.get<DownloaderController>()),
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
      () => ArtistsDatasourceImpl(),
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

    // Playlist dependencies
    i.addLazySingleton(
      PlaylistDatasourceImpl.new,
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
  }
}
