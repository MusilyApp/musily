import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/_library_module/domain/usecases/get_library_offset_limit_usecase.dart';
import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';
import 'package:musily/features/_sections_module/domain/usecases/get_sections_usecase.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_data.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_methods.dart';

class SectionsController extends BaseController<SectionsData, SectionsMethods> {
  late final GetSectionsUsecase _getSectionsUsecase;
  late final GetLibraryOffsetLimitUsecase _getLibraryOffsetLimitUsecase;

  SectionsController({
    required GetSectionsUsecase getSectionsUsecase,
    required GetLibraryOffsetLimitUsecase getLibraryOffsetLimitUsecase,
  }) {
    _getSectionsUsecase = getSectionsUsecase;
    _getLibraryOffsetLimitUsecase = getLibraryOffsetLimitUsecase;
    methods.getSections();
  }

  @override
  SectionsData defineData() {
    return SectionsData(
      loadingSections: true,
      sections: [],
      librarySection: SectionEntity(
        id: 'library',
        title: 'library',
        content: [],
      ),
    );
  }

  @override
  SectionsMethods defineMethods() {
    return SectionsMethods(
      getSections: () async {
        updateData(
          data.copyWith(
            loadingSections: true,
          ),
        );
        try {
          final sections = await _getSectionsUsecase.exec();
          final libraryItems = await _getLibraryOffsetLimitUsecase.exec(0, 4);
          updateData(
            data.copyWith(
              sections: sections,
              librarySection: SectionEntity(
                id: 'library',
                title: 'library',
                content: libraryItems,
              ),
            ),
          );
        } catch (e) {
          print(e);
          catchError(e);
        }
        updateData(
          data.copyWith(
            loadingSections: false,
          ),
        );
      },
    );
  }
}
