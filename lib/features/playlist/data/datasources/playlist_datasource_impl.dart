import 'package:dio/dio.dart';
import 'package:musily/core/domain/errors/app_error.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/playlist/domain/datasources/playlist_datasource.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily_repository/musily_repository.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PlaylistDatasourceImpl implements PlaylistDatasource {
  @override
  Future<PlaylistEntity?> getPlaylist(String id) async {
    try {
      final yt = YoutubeExplode();
      final playlist = await yt.playlists.get(id);
      final videos = await yt.playlists.getVideos(id).toList();
      return PlaylistEntity(
        id: id,
        title: playlist.title,
        tracks: [
          ...videos.map(
            (video) => TrackEntity(
              id: video.id.toString(),
              title: video.title,
              hash: generateTrackHash(
                title: video.title,
                artist: video.author,
              ),
              artist: ShortArtist(
                id: '',
                name: video.author,
              ),
              album: ShortAlbum(id: '', title: ''),
              highResImg: video.thumbnails.highResUrl,
              lowResImg: video.thumbnails.lowResUrl,
              source: 'YouTube',
            ),
          ),
        ],
      );
    } on DioException catch (e) {
      throw AppError(
        code: e.response?.statusCode ?? 500,
        error: e.response?.data ?? 'internal_error',
        title: 'Erro ao buscar playlist',
        message: e.response?.data ?? 'Erro interno',
      );
    }
  }

  @override
  Future<List<PlaylistEntity>> getPlaylists(String query) {
    throw UnimplementedError();
  }
}
