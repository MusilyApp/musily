import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';

enum TrackFileStatus { offline, downloading, online }

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
  bool isLocal;

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
    this.isLocal = false,
  });

  @override
  String toString() {
    return 'TrackEntity(id: $id, orderIndex: $orderIndex, title: $title, hash: $hash, artist: $artist, album: $album, highResImg: $highResImg, lowResImg: $lowResImg, url: $url, source: $source, fromSmartQueue: $fromSmartQueue, duration: $duration, position: $position)';
  }

  TrackEntity copyWith({
    String? id,
    int? orderIndex,
    String? title,
    String? hash,
    SimplifiedArtist? artist,
    SimplifiedAlbum? album,
    String? highResImg,
    String? lowResImg,
    String? url,
    String? source,
    bool? fromSmartQueue,
    Duration? duration,
    Duration? position,
    bool? isLocal,
  }) {
    return TrackEntity(
      id: id ?? this.id,
      orderIndex: orderIndex ?? this.orderIndex,
      title: title ?? this.title,
      hash: hash ?? this.hash,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      highResImg: highResImg ?? this.highResImg,
      lowResImg: lowResImg ?? this.lowResImg,
      url: url ?? this.url,
      source: source ?? this.source,
      fromSmartQueue: fromSmartQueue ?? this.fromSmartQueue,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      isLocal: isLocal ?? this.isLocal,
    );
  }
}
