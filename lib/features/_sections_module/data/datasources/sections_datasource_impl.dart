import 'package:musily/core/domain/datasources/base_datasource.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/features/_sections_module/domain/datasources/sections_datasource.dart';
import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';

class SectionsDatasourceImpl extends BaseDatasource
    implements SectionsDatasource {
  late final MusilyRepository _musilyRepository;

  SectionsDatasourceImpl({required MusilyRepository musilyRepository}) {
    _musilyRepository = musilyRepository;
  }

  @override
  Future<List<HomeSectionEntity>> getSections() async {
    return exec<List<HomeSectionEntity<dynamic>>>(() async {
      final sections = await _musilyRepository.getHomeSections();
      return sections;
    }, onCatch: () async {
      return [];
    });
  }
}
