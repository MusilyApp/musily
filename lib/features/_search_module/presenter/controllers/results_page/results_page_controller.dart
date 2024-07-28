import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/_search_module/domain/entities/search_data_entity.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_data.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_methods.dart';
import 'package:musily/features/album/domain/usecases/get_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artists_usecase.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_tracks_usecase.dart';
import 'package:musily_player/musily_player.dart';

class ResultsPageController
    extends BaseController<ResultsPageData, ResultsPageMethods> {
  late final GetTracksUsecase _getTracksUsecase;
  late final GetAlbumsUsecase _getAlbumsUsecase;
  late final GetArtistsUsecase _getArtistsUsecase;
  late final GetTrackUsecase _getTrackUsecase;
  late final PlayerController playerController;

  ResultsPageController({
    required GetTracksUsecase getTracksUsecase,
    required GetTrackUsecase getTrackUsecase,
    required GetAlbumsUsecase getAlbumsUsecase,
    required GetArtistsUsecase getArtistsUsecase,
    required this.playerController,
  }) {
    _getTracksUsecase = getTracksUsecase;
    _getTrackUsecase = getTrackUsecase;
    _getAlbumsUsecase = getAlbumsUsecase;
    _getArtistsUsecase = getArtistsUsecase;
  }

  @override
  ResultsPageData defineData() {
    return ResultsPageData(
      searchingTracks: true,
      searchingAlbums: true,
      searchingArtists: true,
      tracksResult: SearchDataEntity(
        items: [],
        page: 1,
        limit: 15,
      ),
      albumsResult: SearchDataEntity(
        items: [],
        page: 1,
        limit: 15,
      ),
      artistsResult: SearchDataEntity(
        items: [],
        page: 1,
        limit: 15,
      ),
      keepSearchTrackState: false,
      keepSearchAlbumState: false,
      keepSearchArtistState: false,
    );
  }

  @override
  ResultsPageMethods defineMethods() {
    return ResultsPageMethods(
      searchTracks: (
        String query, {
        required int limit,
        required int page,
      }) async {
        updateData(
          data.copyWith(
            searchingTracks: true,
          ),
        );
        try {
          final tracksResult = await _getTracksUsecase.exec(
            query,
          );
          updateData(
            data.copyWith(
              tracksResult: SearchDataEntity(
                items: tracksResult,
                page: page,
                limit: limit,
              ),
            ),
          );
        } catch (e) {
          updateData(
            data.copyWith(
              tracksResult: SearchDataEntity(
                items: [],
                page: page,
                limit: limit,
              ),
            ),
          );
          catchError(e);
        }
        updateData(
          data.copyWith(
            searchingTracks: false,
            keepSearchTrackState: true,
          ),
        );
      },
      searchAlbums: (query) async {
        updateData(
          data.copyWith(
            searchingAlbums: true,
          ),
        );
        try {
          final albumsResult = await _getAlbumsUsecase.exec(query);
          updateData(
            data.copyWith(
              albumsResult: SearchDataEntity(
                items: albumsResult,
                page: 1,
                limit: 15,
              ),
            ),
          );
        } catch (e) {
          updateData(
            data.copyWith(
              albumsResult: SearchDataEntity(
                items: [],
                page: 1,
                limit: 15,
              ),
            ),
          );
          catchError(e);
        }
        updateData(
          data.copyWith(
            searchingAlbums: false,
            keepSearchAlbumState: true,
          ),
        );
      },
      searchArtists: (query) async {
        updateData(
          data.copyWith(
            searchingArtists: true,
          ),
        );
        try {
          final artistsResult = await _getArtistsUsecase.exec(query);
          updateData(
            data.copyWith(
              artistsResult: SearchDataEntity(
                items: artistsResult,
                page: 1,
                limit: 15,
              ),
            ),
          );
        } catch (e) {
          updateData(
            data.copyWith(
              artistsResult: SearchDataEntity(
                items: [],
                page: 1,
                limit: 15,
              ),
            ),
          );
          catchError(e);
        }
        updateData(
          data.copyWith(
            searchingArtists: false,
            keepSearchArtistState: true,
          ),
        );
      },
      loadTrack: (String trackId) async {
        try {
          final track = await _getTrackUsecase.exec(trackId);
          if (track != null) {
            final trackToUpdate = data.tracksResult.items.where(
              (element) =>
                  element.artist == track.artist &&
                  element.title == track.title,
            );
            if (trackToUpdate.isNotEmpty) {
              if (track.highResImg != null && track.lowResImg != null) {
                if (track.highResImg!.isNotEmpty &&
                    track.lowResImg!.isNotEmpty) {
                  trackToUpdate.first.lowResImg = track.lowResImg;
                  trackToUpdate.first.highResImg = track.highResImg;
                }
              }
            }
            updateData(data);
          }
        } catch (e) {
          catchError(e);
        }
      },
      play: (MusilyTrack track) async {
        if (playerController.data.currentPlayingItem?.id == track.id) {
          if (playerController.data.isPlaying) {
            await playerController.methods.pause();
          } else {
            await playerController.methods.resume();
          }
        } else {
          await playerController.methods.loadAndPlay(
            track,
            track.hash ?? track.id,
          );
        }
      },
      addToQueue: (tracks) async {
        await playerController.methods.addToQueue(tracks);
      },
    );
  }
}
