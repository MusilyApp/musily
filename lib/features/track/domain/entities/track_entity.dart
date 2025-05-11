import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';

enum TrackFileStatus {
  offline,
  downloading,
  online,
}

class TrackEntity {
  final String id;
  int orderIndex;
  String title;
  String hash;
  SimplifiedArtist artist;
  SimplifiedAlbum album;
  String? highResImg;
  String? lowResImg;
  String? url;
  String? source;
  bool fromSmartQueue;
  Duration duration;
  Duration position;

  TrackEntity({
    required this.id,
    this.orderIndex = 0,
    required this.title,
    required this.hash,
    required this.artist,
    required this.album,
    required this.highResImg,
    required this.lowResImg,
    required this.fromSmartQueue,
    required this.duration,
    this.position = Duration.zero,
    this.source,
    this.url,
  });

  TrackEntity copyWith({String? url}) {
    return TrackEntity(
      id: id,
      title: title,
      hash: hash,
      artist: artist,
      album: album,
      highResImg: highResImg,
      lowResImg: lowResImg,
      url: url ?? this.url,
      source: source,
      fromSmartQueue: fromSmartQueue,
      duration: duration,
      position: position,
    );
  }

  @override
  String toString() {
    return 'TrackEntity(id: $id, title: $title, hash: $hash, artist: $artist, album: $album, highResImg: $highResImg, lowResImg: $lowResImg, url: $url, source: $source, fromSmartQueue: $fromSmartQueue)';
  }
}
