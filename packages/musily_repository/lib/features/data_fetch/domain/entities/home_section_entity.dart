import 'package:musily_repository/features/data_fetch/domain/enums/source.dart';

abstract class HomeSectionEntity {
  final String id;
  final String title;
  final List<dynamic> content;
  final Source source;

  HomeSectionEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.source,
  });
}
