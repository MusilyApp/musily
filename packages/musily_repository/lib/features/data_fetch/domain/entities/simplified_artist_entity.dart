import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';

abstract class SimplifiedArtistEntity {
  final String? id;
  final String? name;
  final Source source;
  final String? highResImg;
  final String? lowResImg;

  SimplifiedArtistEntity({
    required this.id,
    required this.name,
    required this.source,
    required this.highResImg,
    required this.lowResImg,
  });
}
