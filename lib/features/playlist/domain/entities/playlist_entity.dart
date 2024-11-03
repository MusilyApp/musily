import 'package:musily/core/domain/entities/identifiable.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class PlaylistEntity implements Identifiable {
  @override
  final String id;
  String title;
  int trackCount;
  SimplifiedArtist? artist;
  String? highResImg;
  String? lowResImg;
  List<TrackEntity> tracks;

  PlaylistEntity({
    required this.id,
    required this.title,
    required this.tracks,
    required this.trackCount,
    this.highResImg,
    this.lowResImg,
    this.artist,
  });

  @override
  String toString() {
    return 'PlaylistEntity(id: $id, title: $title, trackCount: $trackCount, artist: $artist, highResImg: $highResImg, lowResImg: $lowResImg, tracks: $tracks)';
  }
}
