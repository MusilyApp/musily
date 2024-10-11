import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';
import 'package:musily_repository/features/data_fetch/domain/mappers/base_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/simplified_album_mapper.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/features/data_fetch/data/entities/artist_entity_impl.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/artist_entity.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/track_mapper.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/track_entity.dart';

class ArtistMapper implements BaseMapper<ArtistEntity> {
  @override
  ArtistEntity fromMap(Map<String, dynamic> map) {
    return ArtistEntityImpl(
      id: map['id'] as String,
      name: map['name'] as String,
      lowResImg: map['lowResImg'] != null ? map['lowResImg'] as String : null,
      highResImg:
          map['highResImg'] != null ? map['highResImg'] as String : null,
      topTracks: List<TrackEntity>.from(
        (map['topTracks'] as List).map<TrackEntity>(
          (x) => TrackMapper().fromMap(x),
        ),
      ),
      topAlbums: List<SimplifiedAlbumEntity>.from(
        (map['topAlbums'] as List).map<SimplifiedAlbumEntity>(
          (x) => SimplifiedAlbumMapper().fromMap(x),
        ),
      ),
      topSingles: List<SimplifiedAlbumEntity>.from(
        (map['topSingles'] as List).map<SimplifiedAlbumEntity>(
          (x) => SimplifiedAlbumMapper().fromMap(x),
        ),
      ),
      similarArtists: List<ArtistEntity>.from(
        (map['similarArtists'] as List).map<ArtistEntity>(
          (x) => ArtistMapper().fromMap(x),
        ),
      ),
      source: Source.values.byName(map['source']),
    );
  }

  @override
  Map<String, dynamic> toMap(ArtistEntity item) {
    return <String, dynamic>{
      'id': item.id,
      'name': item.name,
      'lowResImg': item.lowResImg,
      'highResImg': item.highResImg,
      'topTracks': item.topTracks.map((x) => TrackMapper().toMap(x)).toList(),
      'topAlbums':
          item.topAlbums.map((x) => SimplifiedAlbumMapper().toMap(x)).toList(),
      'topSingles':
          item.topSingles.map((x) => SimplifiedAlbumMapper().toMap(x)).toList(),
      'similarArtists':
          item.similarArtists.map((x) => ArtistMapper().toMap(x)).toList(),
    };
  }
}
