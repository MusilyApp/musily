import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';
import 'package:musily_repository/features/data_fetch/domain/mappers/base_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/simplified_artist_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/entities/playlist_entity_impl.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/playlist_entity.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/track_mapper.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/track_entity.dart';

class PlaylistMapper implements BaseMapper<PlaylistEntity> {
  @override
  PlaylistEntity fromMap(Map<String, dynamic> map) {
    return PlaylistEntityImpl(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: SimplifiedArtistMapper()
          .fromMap(map['artist'] as Map<String, dynamic>),
      tracks: List<TrackEntity>.from(
        (map['tracks'] as List).map<TrackEntity>(
          (x) => TrackMapper().fromMap(x),
        ),
      ),
      lowResImg: map['lowResImg'] != null ? map['lowResImg'] as String : null,
      highResImg:
          map['highResImg'] != null ? map['highResImg'] as String : null,
      source: Source.values.byName(map['source']),
    );
  }

  @override
  Map<String, dynamic> toMap(PlaylistEntity item) {
    return <String, dynamic>{
      'id': item.id,
      'title': item.title,
      'type': 'playlist',
      'artist': SimplifiedArtistMapper().toMap(item.artist),
      'tracks': item.tracks.map((x) => TrackMapper().toMap(x)).toList(),
      'lowResImg': item.lowResImg,
      'highResImg': item.highResImg,
      'source': item.source.name,
    };
  }
}
