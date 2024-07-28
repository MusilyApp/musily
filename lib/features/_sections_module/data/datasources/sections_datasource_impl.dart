import 'package:musily/core/domain/errors/app_error.dart';
import 'package:musily/features/_sections_module/data/models/section_model.dart';
import 'package:musily/features/_sections_module/domain/datasources/sections_datasource.dart';
import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';
import 'package:musily_repository/get_home_sections.dart';

class SectionsDatasourceImpl implements SectionsDatasource {
  @override
  Future<List<SectionEntity>> getSections() async {
    try {
      final sections = await getHomeSections();
      return [
        ...sections.map(
          (map) => SectionModel.fromMap(map),
        ),
      ];
    } catch (e) {
      throw AppError(
        code: 500,
        error: 'home_sections_error',
        title: '',
        message: '',
      );
    }
  }
}
