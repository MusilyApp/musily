// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

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
  List<LibraryItemEntity> recommendedAlbums;
  TrackEntity? recommendedTrack;
  Color? recommendedTrackBackgroundColor;
  Color? recommendedTrackTextColor;
  List<TrackEntity> moreRecommendedTracks;

  SectionsData({
    required this.loadingSections,
    required this.sections,
    required this.librarySection,
    this.recommendedAlbums = const [],
    this.recommendedTrack,
    this.recommendedTrackBackgroundColor,
    this.recommendedTrackTextColor,
    this.moreRecommendedTracks = const [],
  });

  @override
  SectionsData copyWith({
    bool? loadingSections,
    List<HomeSectionEntity>? sections,
    HomeSectionEntity<LibraryItemEntity>? librarySection,
    List<LibraryItemEntity>? recommendedAlbums,
    TrackEntity? recommendedTrack,
    Color? recommendedTrackBackgroundColor,
    Color? recommendedTrackTextColor,
    List<TrackEntity>? moreRecommendedTracks,
  }) {
    return SectionsData(
      loadingSections: loadingSections ?? this.loadingSections,
      sections: sections ?? this.sections,
      librarySection: librarySection ?? this.librarySection,
      recommendedAlbums: recommendedAlbums ?? this.recommendedAlbums,
      recommendedTrack: recommendedTrack ?? this.recommendedTrack,
      recommendedTrackBackgroundColor: recommendedTrackBackgroundColor ??
          this.recommendedTrackBackgroundColor,
      recommendedTrackTextColor:
          recommendedTrackTextColor ?? this.recommendedTrackTextColor,
      moreRecommendedTracks:
          moreRecommendedTracks ?? this.moreRecommendedTracks,
    );
  }
}
