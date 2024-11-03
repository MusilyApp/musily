// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';

class SectionsDependencies {
  SectionsController sectionsController;

  SectionsDependencies({
    required this.sectionsController,
  });
}

class SectionsData extends BaseControllerData {
  bool loadingSections;
  List<HomeSectionEntity> sections;
  HomeSectionEntity<LibraryItemEntity> librarySection;

  SectionsData({
    required this.loadingSections,
    required this.sections,
    required this.librarySection,
  });

  @override
  SectionsData copyWith({
    bool? loadingSections,
    List<HomeSectionEntity>? sections,
    HomeSectionEntity<LibraryItemEntity>? librarySection,
  }) {
    return SectionsData(
      loadingSections: loadingSections ?? this.loadingSections,
      sections: sections ?? this.sections,
      librarySection: librarySection ?? this.librarySection,
    );
  }
}
