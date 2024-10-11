import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';
import 'package:musily_repository/features/data_fetch/domain/entities/simplified_artist_entity.dart';

abstract class SimplifiedAlbumEntity {
  final String id;
  final String title;
  final SimplifiedArtistEntity artist;
  final String? lowResImg;
  final String? highResImg;
  final Source source;

  SimplifiedAlbumEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.lowResImg,
    required this.highResImg,
    required this.source,
  });
}
