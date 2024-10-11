import 'package:musily_repository/features/data_fetch/data/entities/home_section_entity_impl.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/album_mapper.dart';
import 'package:musily_repository/features/data_fetch/data/mappers/playlist_mapper.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/album_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/home_section_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/playlist_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';
import 'package:musily_repository/features/data_fetch/domain/mappers/base_mapper.dart';

class HomeSectionMapper implements BaseMapper<HomeSectionEntity> {
  @override
  HomeSectionEntity fromMap(Map<String, dynamic> map) {
    return HomeSectionEntityImpl(
      id: map['id'] as String,
      title: map['title'] as String,
      content: List<dynamic>.from(
        (map['content'] as List<dynamic>),
      ),
      source: Source.values.byName(map['source']),
    );
  }

  @override
  Map<String, dynamic> toMap(HomeSectionEntity item) {
    return <String, dynamic>{
      'id': item.id,
      'title': item.title,
      'content': item.content.map((element) {
        if (element is AlbumEntity) {
          return AlbumMapper().toMap(element);
        }
        if (element is PlaylistEntity) {
          return PlaylistMapper().toMap(element);
        }
      }),
      'source': item.source.name,
    };
  }
}
