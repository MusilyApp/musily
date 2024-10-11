import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/simplified_artist_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/track_entity.dart';

abstract class PlaylistEntity {
  final String id;
  final String title;
  final SimplifiedArtistEntity artist;
  final List<TrackEntity> tracks;
  final String? lowResImg;
  final String? highResImg;
  final Source source;

  PlaylistEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.tracks,
    required this.lowResImg,
    required this.highResImg,
    required this.source,
  });
}
