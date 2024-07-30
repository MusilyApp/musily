import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';

enum TrackFileStatus {
  offline,
  downloading,
  online,
}

class TrackEntity {
  final String id;
  String title;
  String hash;
  ShortArtist artist;
  ShortAlbum album;
  String? highResImg;
  String? lowResImg;
  String? url;
  String source;
  bool fromSmartQueue;

  TrackEntity({
    required this.id,
    required this.title,
    required this.hash,
    required this.artist,
    required this.album,
    required this.highResImg,
    required this.lowResImg,
    required this.source,
    required this.fromSmartQueue,
    this.url,
  });
}
