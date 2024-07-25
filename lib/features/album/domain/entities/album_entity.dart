import 'package:musily/core/domain/entities/identifiable.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class ShortAlbum {
  final String id;
  String title;

  ShortAlbum({
    required this.id,
    required this.title,
  });
}

class AlbumEntity implements Identifiable {
  @override
  String id;
  String title;
  int year;
  ShortArtist artist;
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
}
