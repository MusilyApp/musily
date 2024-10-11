import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';
import 'package:musily_repository/features/data_fetch/domain/mappers/base_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/entities/simplified_album_entity_impl.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/simplified_artist_mapper.dart';

class SimplifiedAlbumMapper implements BaseMapper<SimplifiedAlbumEntity> {
  @override
  SimplifiedAlbumEntity fromMap(Map<String, dynamic> map) {
    return SimplifiedAlbumEntityImpl(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: SimplifiedArtistMapper().fromMap(
        map['artist'] ?? {'id': '', 'name': '', 'source': 'youtube'},
      ),
      lowResImg: map['lowResImg'] != null ? map['lowResImg'] as String : null,
      highResImg:
          map['highResImg'] != null ? map['highResImg'] as String : null,
      source: Source.values.byName(map['source'] ?? 'youtube'),
    );
  }

  @override
  Map<String, dynamic> toMap(SimplifiedAlbumEntity item) {
    return <String, dynamic>{
      'id': item.id,
      'title': item.title,
      'artist': SimplifiedArtistMapper().toMap(
        item.artist,
      ),
      'lowResImg': item.lowResImg,
      'highResImg': item.highResImg,
      'source': item.source.name,
    };
  }
}
