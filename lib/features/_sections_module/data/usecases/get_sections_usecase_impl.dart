import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';
import 'package:musily/features/_sections_module/domain/repositories/sections_repository.dart';
import 'package:musily/features/_sections_module/domain/usecases/get_sections_usecase.dart';

class GetSectionsUsecaseImpl implements GetSectionsUsecase {
  late final SectionsRepository _sectionsRepository;

  GetSectionsUsecaseImpl({
    required SectionsRepository sectionsRepository,
  }) {
    _sectionsRepository = sectionsRepository;
  }

  @override
  Future<List<SectionEntity>> exec() async {
    final sections = await _sectionsRepository.getSections();
    return sections;
  }
}
