import 'package:musily/features/album/data/models/album_model.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'dart:convert';

class ArtistModel {
  static ArtistEntity fromMap(Map<String, dynamic> map) {
    return ArtistEntity(
      id: map['id'],
      name: map['name'],
      highResImg: map['highResImg'],
      lowResImg: map['lowResImg'],
      topTracks: map['topTracks'] == null
          ? []
          : [
              ...(map['topTracks'] as List).map(
                (track) => TrackModel.fromMap(track),
              ),
            ],
      topAlbums: map['topAlbums'] == null
          ? []
          : [
              ...(map['topAlbums'] as List).map(
                (album) => AlbumModel.fromMap(
                  album,
                ),
              ),
            ],
      topSingles: map['topSingles'] == null
          ? []
          : [
              ...(map['topSingles'] as List).map(
                (single) => AlbumModel.fromMap(
                  single,
                ),
              ),
            ],
      similarArtists: map['similarArtists'] == null
          ? []
          : [
              ...(map['similarArtists'] as List).map(
                (artist) => ArtistModel.fromMap(
                  artist,
                ),
              ),
            ],
    );
  }

  static Map<String, dynamic> toMap(ArtistEntity artist) {
    return {
      'id': artist.id,
      'name': artist.name,
      'highResImg': artist.highResImg,
      'lowResImg': artist.lowResImg,
      'topTracks': [
        ...artist.topTracks.map(
          (track) => TrackModel.toMap(track),
        ),
      ],
      'topAlbums': [
        ...artist.topAlbums.map(
          (album) => AlbumModel.toMap(
            album,
          ),
        ),
      ],
      'topSingles': [
        ...artist.topSingles.map(
          (single) => AlbumModel.toMap(single),
        ),
      ],
      'similarArtists': [
        ...artist.similarArtists.map(
          (similarArtist) => ArtistModel.toMap(similarArtist),
        ),
      ],
    };
  }

  // Converter de JSON para ArtistEntity
  static ArtistEntity fromJson(String jsonString) {
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return fromMap(map);
  }

  // Converter de ArtistEntity para JSON
  static String toJson(ArtistEntity artist) {
    final map = toMap(artist);
    return jsonEncode(map);
  }

  // Cria uma cópia profunda (deep clone) de um ArtistEntity
  static ArtistEntity cloneArtist(ArtistEntity artist) {
    final map = toMap(artist);
    return fromMap(map);
  }

  // Conversão segura com tratamento de erro
  static ArtistEntity safeFromMap(Map<String, dynamic> map) {
    try {
      return fromMap(map);
    } catch (e) {
      throw FormatException("Invalid artist map: $e");
    }
  }

  // Validação do mapa para verificar se possui campos essenciais
  static bool validateMap(Map<String, dynamic> map) {
    return map.containsKey('id') && map.containsKey('name');
  }

  // Mecanismo de cache para melhorar a performance nas conversões
  static final Map<String, ArtistEntity> _cache = {};

  static ArtistEntity cachedFromMap(Map<String, dynamic> map) {
    final key = map['id'].toString();
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    } else {
      final artist = fromMap(map);
      _cache[key] = artist;
      return artist;
    }
  }

  // Limpa o cache
  static void clearCache() {
    _cache.clear();
  }

  // Atualiza o cache com um novo ArtistEntity
  static ArtistEntity updateCache(ArtistEntity artist) {
    _cache[artist.id.toString()] = artist;
    return artist;
  }
}
