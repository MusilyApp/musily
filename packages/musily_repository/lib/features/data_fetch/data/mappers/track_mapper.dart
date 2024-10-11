import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';
import 'package:musily_repository/features/data_fetch/domain/mappers/base_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/simplified_album_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/simplified_artist_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/entities/track_entity_impl.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/track_entity.dart';

class TrackMapper implements BaseMapper<TrackEntity> {
  @override
  TrackEntity fromMap(Map<String, dynamic> map) {
    return TrackEntityImpl(
      id: map['id'] as String,
      hash: map['hash'] as String,
      title: map['title'] as String,
      lyrics: map['lyrics'] != null ? map['lyrics'] as String : null,
      artist: SimplifiedArtistMapper()
          .fromMap(map['artist'] as Map<String, dynamic>),
      album:
          SimplifiedAlbumMapper().fromMap(map['album'] as Map<String, dynamic>),
      lowResImg: map['lowResImg'] != null ? map['lowResImg'] as String : null,
      highResImg:
          map['highResImg'] != null ? map['highResImg'] as String : null,
      recommendedTrack: map['recommendedTrack'] ?? false,
      source: Source.values.byName(map['source'] ?? 'youtube'),
    );
  }

  @override
  Map<String, dynamic> toMap(TrackEntity item) {
    return <String, dynamic>{
      'id': item.id,
      'hash': item.hash,
      'title': item.title,
      'lyrics': item.lyrics,
      'artist': SimplifiedArtistMapper().toMap(item.artist),
      'album': SimplifiedAlbumMapper().toMap(item.album),
      'lowResImg': item.lowResImg,
      'highResImg': item.highResImg,
      'recommendedTrack': item.recommendedTrack,
      'source': item.source.name,
    };
  }
}
