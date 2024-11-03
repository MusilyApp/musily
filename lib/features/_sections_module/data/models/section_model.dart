import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';
import 'package:musily/features/album/data/models/album_model.dart';
import 'package:musily/features/playlist/data/models/playlist_model.dart';

class SectionModel {
  static HomeSectionEntity fromMap(Map<String, dynamic> map) {
    return HomeSectionEntity(
      id: map['id'],
      title: map['title'],
      content: [
        ...(map['content'] ?? []).map(
          (content) {
            if (content['type'] == 'album') {
              return AlbumModel.fromMap(content);
            }
            if (content['type'] == 'playlist') {
              return PlaylistModel.fromMap(content);
            }
          },
        )
      ],
    );
  }
}
