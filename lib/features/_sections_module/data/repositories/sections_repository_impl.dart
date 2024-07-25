import 'package:musily/features/_sections_module/domain/datasources/sections_datasource.dart';
import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';
import 'package:musily/features/_sections_module/domain/repositories/sections_repository.dart';

class SectionsRepositoryImpl implements SectionsRepository {
  late final SectionsDatasource _sectionsDatasource;

  SectionsRepositoryImpl({
    required SectionsDatasource sectionsDatasource,
  }) {
    _sectionsDatasource = sectionsDatasource;
  }

  @override
  Future<List<SectionEntity>> getSections() async {
    final sections = await _sectionsDatasource.getSections();
    return sections;
  }
}
