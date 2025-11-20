// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:musily/core/domain/entities/identifiable.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class SimplifiedAlbum {
  final String id;
  String title;

  SimplifiedAlbum({
    required this.id,
    required this.title,
  });

  @override
  String toString() => 'SimplifiedAlbum(id: $id, title: $title)';
}

class AlbumEntity implements Identifiable {
  @override
  String id;
  String title;
  int year;
  SimplifiedArtist artist;
  List<TrackEntity> tracks;
  String? lowResImg;
  String? highResImg;

  AlbumEntity({
    required this.title,
    required this.id,
    required this.artist,
    required this.tracks,
    required this.year,
    this.highResImg,
    this.lowResImg,
  });

  @override
  String toString() {
    return 'AlbumEntity(id: $id, title: $title, year: $year, artist: $artist, tracks: $tracks, lowResImg: $lowResImg, highResImg: $highResImg)';
  }
}
