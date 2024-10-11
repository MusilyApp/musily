import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';
import 'package:musily_repository/features/data_fetch/domain/mappers/base_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/entities/album_entity_impl.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/album_entity.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/simplified_artist_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/track_mapper.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/track_entity.dart';

class AlbumMapper implements BaseMapper<AlbumEntity> {
  @override
  AlbumEntity fromMap(Map<String, dynamic> map) {
    return AlbumEntityImpl(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: SimplifiedArtistMapper().fromMap(map['artist']),
      year: map['year'] as int,
      lowResImg: map['lowResImg'] != null ? map['lowResImg'] as String : null,
      highResImg:
          map['highResImg'] != null ? map['highResImg'] as String : null,
      tracks: List<TrackEntity>.from(
        (map['tracks']).map<TrackEntity>(
          (x) => TrackMapper().fromMap(x),
        ),
      ),
      source: Source.values.byName(map['source']),
    );
  }

  @override
  Map<String, dynamic> toMap(AlbumEntity item) {
    return <String, dynamic>{
      'id': item.id,
      'type': 'album',
      'title': item.title,
      'year': item.year,
      'lowResImg': item.lowResImg,
      'highResImg': item.highResImg,
      'tracks': item.tracks.map((x) => TrackMapper().toMap(x)).toList(),
      'source': item.source.name,
    };
  }
}
