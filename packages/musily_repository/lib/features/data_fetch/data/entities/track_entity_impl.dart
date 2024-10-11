import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/simplified_album_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/simplified_artist_entity.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/track_entity.dart';

class TrackEntityImpl implements TrackEntity {
  @override
  final String id;
  @override
  final String hash;
  @override
  final String title;
  @override
  final String? lyrics;
  @override
  final SimplifiedArtistEntity artist;
  @override
  final SimplifiedAlbumEntity album;
  @override
  final String? lowResImg;
  @override
  final String? highResImg;
  @override
  final Source source;
  @override
  bool recommendedTrack;

  TrackEntityImpl({
    required this.id,
    required this.hash,
    required this.title,
    required this.artist,
    required this.album,
    this.lowResImg,
    this.highResImg,
    this.lyrics,
    this.recommendedTrack = false,
    required this.source,
  });
}
