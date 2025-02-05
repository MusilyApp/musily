import 'package:musily/core/domain/datasources/base_datasource.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/datasources/artist_datasource.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'dart:async';

class ArtistsDatasourceImpl extends BaseDatasource implements ArtistDatasource {
  late final MusilyRepository _musilyRepository;
  final Map<String, ArtistEntity> _artistCache = {};

  ArtistsDatasourceImpl({
    required MusilyRepository musilyRepository,
  }) {
    _musilyRepository = musilyRepository;
  }

  @override
  Future<ArtistEntity?> getArtist(String id) async {
    return exec<ArtistEntity?>(() async {
      final artist = await _musilyRepository.getArtist(id);
      if (artist == null) {
        return null;
      }
      return artist;
    });
  }

  @override
  Future<List<ArtistEntity>> getArtists(String query) async {
    return exec<List<ArtistEntity>>(() async {
      final artists = await _musilyRepository.searchArtists(query);
      return artists;
    });
  }

  @override
  Future<List<AlbumEntity>> getArtistAlbums(String artistId) async {
    return exec<List<AlbumEntity>>(() async {
      final albums = await _musilyRepository.getArtistAlbums(artistId);
      return albums;
    });
  }

  @override
  Future<List<TrackEntity>> getArtistTracks(String artistId) async {
    return exec<List<TrackEntity>>(() async {
      final tracks = await _musilyRepository.getArtistTracks(artistId);
      return tracks;
    });
  }

  @override
  Future<List<AlbumEntity>> getArtistSingles(String artistId) async {
    return exec<List<AlbumEntity>>(() async {
      final albums = await _musilyRepository.getArtistSingles(artistId);
      return albums;
    });
  }

  // Nova função: Obtém o artista com cache para melhorar a performance.
  Future<ArtistEntity?> getArtistCached(String id) async {
    if (_artistCache.containsKey(id)) {
      return _artistCache[id];
    }
    final artist = await getArtist(id);
    if (artist != null) {
      _artistCache[id] = artist;
    }
    return artist;
  }

  // Nova função: Limpa o cache interno de artistas.
  Future<void> clearCache() async {
    _artistCache.clear();
  }

  // Nova função: Atualiza forçadamente os dados de um artista, removendo-o do cache.
  Future<ArtistEntity?> refreshArtist(String id) async {
    _artistCache.remove(id);
    return await getArtist(id);
  }

  // Nova função: Agrega todos os dados de um artista em um único mapa.
  Future<Map<String, dynamic>> getAllArtistData(String id) async {
    final artist = await getArtist(id);
    if (artist == null) return {};
    final albums = await getArtistAlbums(id);
    final tracks = await getArtistTracks(id);
    final singles = await getArtistSingles(id);
    final relatedArtists = await getArtists(artist.name);
    return {
      'artist': artist,
      'albums': albums,
      'tracks': tracks,
      'singles': singles,
      'relatedArtists': relatedArtists,
    };
  }

  // Nova função: Retorna os álbuns do artista ordenados por título.
  Future<List<AlbumEntity>> getArtistAlbumsSorted(String artistId, {bool ascending = true}) async {
    final albums = await getArtistAlbums(artistId);
    albums.sort((a, b) => ascending ? a.title.compareTo(b.title) : b.title.compareTo(a.title));
    return albums;
  }

  // Nova função: Obtém o artista com um tempo limite definido.
  Future<ArtistEntity?> getArtistWithTimeout(String id, Duration timeout) async {
    try {
      return await getArtist(id).timeout(timeout);
    } catch (e) {
      throw TimeoutException("Fetching artist $id timed out after $timeout");
    }
  }

  // Nova função: Pesquisa artistas com paginação simulada.
  Future<List<ArtistEntity>> searchArtistsWithPagination(String query, {int page = 1, int limit = 10}) async {
    final allArtists = await getArtists(query);
    final start = (page - 1) * limit;
    int end = start + limit;
    if (start >= allArtists.length) return [];
    if (end > allArtists.length) end = allArtists.length;
    return allArtists.sublist(start, end);
  }

  // Nova função: Conta o número total de artistas encontrados para uma consulta.
  Future<int> countArtists(String query) async {
    final artists = await getArtists(query);
    return artists.length;
  }

  // Nova função: Loga o status atual do datasource, útil para debug.
  void logDatasourceStatus() {
    print("ArtistsDatasourceImpl: Cache size = ${_artistCache.length}");
  }

  // Nova função: Mede o tempo de execução de uma função e retorna o resultado.
  Future<T> measureExecutionTime<T>(Future<T> Function() func) async {
    final start = DateTime.now();
    final result = await func();
    final end = DateTime.now();
    print("Execution time: ${end.difference(start).inMilliseconds} ms");
    return result;
  }
}
