import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/data/database/library_database.dart';
import 'package:musily/core/data/usecases/get_playable_item_usecase_impl.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/utils/display_helper.dart';
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
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/artist/data/datasources/artists_datasource_impl.dart';
import 'package:musily/features/artist/data/repository/artist_repository_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_albums_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_singles_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_tracks_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artist_usecase_impl.dart';
import 'package:musily/features/artist/data/usecases/get_artists_usecase_impl.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/player/data/datasources/player_datasource_impl.dart';
import 'package:musily/features/player/data/repositories/player_repository_impl.dart';
import 'package:musily/features/player/data/usecases/get_smart_queue_usecase_impl.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_button.dart';
import 'package:musily/features/playlist/data/datasources/playlist_datasource_impl.dart';
import 'package:musily/features/playlist/data/repositories/playlist_repository_impl.dart';
import 'package:musily/features/playlist/data/usecases/get_playlist_usecase_impl.dart';
import 'package:musily/features/track/data/datasources/track_datasource_impl.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/data/repositories/track_respository_impl.dart';
import 'package:musily/features/track/data/usecases/get_track_lyrics_usecase_impl.dart';
import 'package:musily/features/track/data/usecases/get_track_usecase_impl.dart';
import 'package:musily/features/track/data/usecases/get_tracks_usecase_impl.dart';
import 'package:musily/features/track/presenter/widgets/track_options.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';

class SharedModule extends Module {
  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);
    i.addLazySingleton(CoreController.new);

    // Player dependencies
    i.addLazySingleton(PlayerDatasourceImpl.new);
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
        loadUrl: (track) async {
          final getPlayableItemUsecase = i.get<GetPlayableItemUsecaseImpl>();
          final item = await getPlayableItemUsecase.exec(track);
          return item.url;
        },
        getLyrics: (trackId) async {
          final getTrackLyricsUsecase = i.get<GetTrackLyricsUsecaseImpl>();
          final lyrics = await getTrackLyricsUsecase.exec(trackId);
          return lyrics;
        },
        favoriteButton: (context, track) => FavoriteButton(
          libraryController: i.get<LibraryController>(),
          track: TrackModel.fromMusilyTrack(track),
        ),
        getSmartQueue: (currentQueue) async {
          final getSmartQueueUsecase = i.get<GetSmartQueueUsecaseImpl>();
          final smartQueue = await getSmartQueueUsecase.exec(
            [
              ...currentQueue.map(
                (e) => TrackModel.fromMusilyTrack(e),
              ),
            ],
          );
          return [
            ...smartQueue.map(
              (e) => TrackModel.toMusilyTrack(e),
            ),
          ];
        },
        onAddSmartQueueItem: (track) {
          final playerController = i.get<PlayerController>();
          final libraryController = i.get<LibraryController>();
          libraryController.methods.addToPlaylist(
            [
              TrackModel.fromMusilyTrack(track),
            ],
            playerController.data.playingId,
          );
        },
        onAlbumInvoked: (album, context) {
          final displayHelper = DisplayHelper(context);
          final playerController = i.get<PlayerController>();
          if (!displayHelper.isDesktop) {
            playerController.methods.closePlayer();
          }
          final coreController = i.get<CoreController>();
          coreController.methods.pushWidget(
            AsyncAlbumPage(
              albumId: album.id,
              coreController: coreController,
              playerController: playerController,
              getAlbumUsecase: i.get<GetAlbumUsecaseImpl>(),
              downloaderController: i.get<DownloaderController>(),
              getPlayableItemUsecase: i.get<GetPlayableItemUsecaseImpl>(),
              libraryController: i.get<LibraryController>(),
              getArtistAlbumsUsecase: i.get<GetArtistAlbumsUsecaseImpl>(),
              getArtistSinglesUsecase: i.get<GetArtistSinglesUsecaseImpl>(),
              getArtistTracksUsecase: i.get<GetArtistTracksUsecaseImpl>(),
              getArtistUsecase: i.get<GetArtistUsecaseImpl>(),
            ),
          );
        },
        onArtistInvoked: (artist, context) {
          final displayHelper = DisplayHelper(context);
          final playerController = i.get<PlayerController>();
          if (!displayHelper.isDesktop) {
            playerController.methods.closePlayer();
          }
          final coreController = i.get<CoreController>();
          coreController.methods.pushWidget(
            AsyncArtistPage(
              artistId: artist.id,
              coreController: coreController,
              playerController: i.get<PlayerController>(),
              getAlbumUsecase: i.get<GetAlbumUsecaseImpl>(),
              downloaderController: i.get<DownloaderController>(),
              getPlayableItemUsecase: i.get<GetPlayableItemUsecaseImpl>(),
              libraryController: i.get<LibraryController>(),
              getArtistAlbumsUsecase: i.get<GetArtistAlbumsUsecaseImpl>(),
              getArtistSinglesUsecase: i.get<GetArtistSinglesUsecaseImpl>(),
              getArtistTracksUsecase: i.get<GetArtistTracksUsecaseImpl>(),
              getArtistUsecase: i.get<GetArtistUsecaseImpl>(),
            ),
          );
        },
        onPlayerCollapsed: () {
          final coreController = i.get<CoreController>();
          coreController.updateData(
            coreController.data.copyWith(
              isPlayerExpanded: false,
            ),
          );
        },
        onPlayerExpanded: () {
          final coreController = i.get<CoreController>();
          coreController.updateData(
            coreController.data.copyWith(
              isPlayerExpanded: true,
            ),
          );
        },
        trackOptionsWidget: (context, track) {
          final displayHelper = DisplayHelper(context);
          return TrackOptionsBuilder(
            track: TrackModel.fromMusilyTrack(track),
            builder: (context, showOptions) {
              return IconButton(
                onPressed: showOptions,
                icon: Icon(
                  Icons.more_vert,
                  size: displayHelper.isDesktop ? 20 : null,
                ),
              );
            },
            playerController: i.get<PlayerController>(),
            getAlbumUsecase: i.get<GetAlbumUsecaseImpl>(),
            downloaderController: i.get<DownloaderController>(),
            getPlayableItemUsecase: i.get<GetPlayableItemUsecaseImpl>(),
            libraryController: i.get<LibraryController>(),
            getArtistAlbumsUsecase: i.get<GetArtistAlbumsUsecaseImpl>(),
            getArtistSinglesUsecase: i.get<GetArtistSinglesUsecaseImpl>(),
            getArtistTracksUsecase: i.get<GetArtistTracksUsecaseImpl>(),
            getArtistUsecase: i.get<GetArtistUsecaseImpl>(),
            coreController: i.get<CoreController>(),
          );
        },
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
        playerController: i.get<PlayerController>(),
      ),
    );

    // Downloader dependencies
    i.addLazySingleton(
      () => GetPlayableItemUsecaseImpl(),
    );
    i.addLazySingleton(
      () => DownloaderController(),
    );

    // Album dependencies
    i.addLazySingleton(
      () => AlbumDatasourceImpl(
        downloaderController: i.get<DownloaderController>(),
        libraryDatasource: i.get<LibraryDatasourceImpl>(),
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
      () => PlaylistDatasourceImpl(
        libraryDatasource: i.get<LibraryDatasourceImpl>(),
        downloaderController: i.get<DownloaderController>(),
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
  }
}
