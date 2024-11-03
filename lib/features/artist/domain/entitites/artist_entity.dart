import 'package:musily/core/domain/entities/identifiable.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class SimplifiedArtist {
  final String id;
  String name;

  SimplifiedArtist({
    required this.id,
    required this.name,
  });
}

class ArtistEntity implements Identifiable {
  @override
  String id;
  String name;
  String? highResImg;
  String? lowResImg;
  List<TrackEntity> topTracks;
  List<AlbumEntity> topAlbums;
  List<AlbumEntity> topSingles;
  List<ArtistEntity> similarArtists;

  ArtistEntity({
    required this.name,
    required this.id,
    this.highResImg,
    this.lowResImg,
    this.topTracks = const [],
    this.topAlbums = const [],
    this.topSingles = const [],
    this.similarArtists = const [],
  });
}
