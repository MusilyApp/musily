import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/simplified_artist_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/track_entity.dart';

abstract class AlbumEntity {
  final String id;
  final String title;
  final SimplifiedArtistEntity artist;
  final int year;
  final String? lowResImg;
  final String? highResImg;
  final List<TrackEntity> tracks;
  final Source source;

  AlbumEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.lowResImg,
    required this.highResImg,
    required this.tracks,
    required this.source,
  });
}
