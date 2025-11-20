import 'package:flutter/material.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class RecommendedTrackModel {
  final Color? backgroundColor;
  final Color? textColor;
  final TrackEntity track;

  RecommendedTrackModel({
    this.backgroundColor,
    this.textColor,
    required this.track,
  });
}

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
  List<RecommendedTrackModel> gridRecommendedTracks;
  List<RecommendedTrackModel> carouselRecommendedTracks;

  SectionsData({
    required this.loadingSections,
    required this.sections,
    required this.librarySection,
    required this.carouselRecommendedTracks,
    required this.gridRecommendedTracks,
  });

  @override
  SectionsData copyWith({
    bool? loadingSections,
    List<HomeSectionEntity>? sections,
    HomeSectionEntity<LibraryItemEntity>? librarySection,
    List<RecommendedTrackModel>? carouselRecommendedTracks,
    List<RecommendedTrackModel>? gridRecommendedTracks,
  }) {
    return SectionsData(
      loadingSections: loadingSections ?? this.loadingSections,
      sections: sections ?? this.sections,
      librarySection: librarySection ?? this.librarySection,
      carouselRecommendedTracks:
          carouselRecommendedTracks ?? this.carouselRecommendedTracks,
      gridRecommendedTracks:
          gridRecommendedTracks ?? this.gridRecommendedTracks,
    );
  }
}
