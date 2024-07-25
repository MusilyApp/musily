import 'package:musily/features/_search_module/domain/entities/search_data_entity.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class ResultsPageData {
  bool searchingTracks;
  bool searchingAlbums;
  bool searchingArtists;

  SearchDataEntity<TrackEntity> tracksResult;
  SearchDataEntity<AlbumEntity> albumsResult;
  SearchDataEntity<ArtistEntity> artistsResult;

  bool keepSearchTrackState;
  bool keepSearchAlbumState;
  bool keepSearchArtistState;

  ResultsPageData({
    required this.searchingTracks,
    required this.searchingAlbums,
    required this.searchingArtists,
    required this.tracksResult,
    required this.albumsResult,
    required this.artistsResult,
    required this.keepSearchTrackState,
    required this.keepSearchAlbumState,
    required this.keepSearchArtistState,
  });

  ResultsPageData copyWith({
    bool? searchingTracks,
    bool? searchingAlbums,
    bool? searchingArtists,
    SearchDataEntity<TrackEntity>? tracksResult,
    SearchDataEntity<AlbumEntity>? albumsResult,
    SearchDataEntity<ArtistEntity>? artistsResult,
    bool? keepSearchTrackState,
    bool? keepSearchAlbumState,
    bool? keepSearchArtistState,
  }) {
    return ResultsPageData(
      searchingTracks: searchingTracks ?? this.searchingTracks,
      searchingAlbums: searchingAlbums ?? this.searchingAlbums,
      searchingArtists: searchingArtists ?? this.searchingArtists,
      tracksResult: tracksResult ?? this.tracksResult,
      albumsResult: albumsResult ?? this.albumsResult,
      artistsResult: artistsResult ?? this.artistsResult,
      keepSearchTrackState: keepSearchTrackState ?? this.keepSearchTrackState,
      keepSearchAlbumState: keepSearchAlbumState ?? this.keepSearchAlbumState,
      keepSearchArtistState:
          keepSearchArtistState ?? this.keepSearchArtistState,
    );
  }
}
