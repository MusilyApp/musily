import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/_library_module/domain/usecases/get_library_items_usecase.dart';
import 'package:musily/features/_sections_module/data/services/recommendations_color_processor.dart';
import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';
import 'package:musily/features/_sections_module/domain/usecases/get_sections_usecase.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_data.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_methods.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/core/domain/usecases/get_upnext_usecase.dart';
import 'dart:developer' as dev;

class SectionsController extends BaseController<SectionsData, SectionsMethods> {
  late final GetSectionsUsecase _getSectionsUsecase;
  late final GetLibraryItemsUsecase _getLibraryItemsUsecase;
  late final GetUpNextUsecase _getUpNextUsecase;
  late final GetArtistUsecase _getArtistUsecase;
  late final GetPlaylistUsecase _getPlaylistUsecase;

  SectionsController({
    required GetSectionsUsecase getSectionsUsecase,
    required GetLibraryItemsUsecase getLibraryItemsUsecase,
    required GetUpNextUsecase getUpNextUsecase,
    required GetArtistUsecase getArtistUsecase,
    required GetPlaylistUsecase getPlaylistUsecase,
  }) {
    _getSectionsUsecase = getSectionsUsecase;
    _getLibraryItemsUsecase = getLibraryItemsUsecase;
    _getUpNextUsecase = getUpNextUsecase;
    _getArtistUsecase = getArtistUsecase;
    _getPlaylistUsecase = getPlaylistUsecase;
    methods.getSections();
  }

  @override
  SectionsData defineData() {
    return SectionsData(
      loadingSections: true,
      sections: [],
      carouselRecommendedTracks: [],
      gridRecommendedTracks: [],
      librarySection: HomeSectionEntity(
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
          final libraryItems = await _getLibraryItemsUsecase.exec();
          updateData(
            data.copyWith(
              sections: sections,
              librarySection: HomeSectionEntity(
                id: 'library',
                title: 'library',
                content: libraryItems,
              ),
            ),
          );
          await methods.generateRecommendations();
        } catch (e) {
          catchError(e);
        }
        updateData(
          data.copyWith(
            loadingSections: false,
          ),
        );
      },
      generateRecommendations: () async {
        try {
          final libraryItems = await _getLibraryItemsUsecase.exec();
          final shuffledLibraryItems = List.from(libraryItems)..shuffle();

          List<TrackEntity> seedTracks = [];
          final random = Random();

          final randomAlbums = shuffledLibraryItems
              .where((item) => item.album != null)
              .toList()
              .take(3)
              .toList();
          final randomArtist = shuffledLibraryItems
              .where((item) => item.artist != null)
              .toList()
              .take(1)
              .toList();
          final randomPlaylist = shuffledLibraryItems
              .where((item) => item.playlist != null)
              .toList()
              .take(1)
              .toList();

          for (final album in randomAlbums) {
            final tracks = album.album!.tracks;
            seedTracks.addAll(tracks);
          }
          for (final artist in randomArtist) {
            final artistEntity = await _getArtistUsecase.exec(artist.id);
            if (artistEntity != null) {
              seedTracks.addAll(artistEntity.topTracks);
            }
          }
          for (final playlist in randomPlaylist) {
            final playlistEntity = await _getPlaylistUsecase.exec(playlist.id);
            if (playlistEntity != null) {
              seedTracks.addAll(playlistEntity.tracks);
            }
          }

          if (seedTracks.isNotEmpty) {
            seedTracks.shuffle(random);
            seedTracks = seedTracks.take(3).toList();
          }

          List<TrackEntity> upNextTracks = [];

          for (final seedTrack in seedTracks) {
            try {
              final upNext = await _getUpNextUsecase.exec(seedTrack);
              upNextTracks.addAll(upNext);
            } catch (e) {
              dev.log('Error getting UpNext for ${seedTrack.title}: $e');
            }
          }

          final imageUrls = upNextTracks
              .map((track) => track.lowResImg ?? '')
              .where((url) => url.isNotEmpty)
              .toList();

          List<Map<String, int>> colorResults = [];
          if (imageUrls.isNotEmpty) {
            try {
              colorResults = await processMultipleImageColors(imageUrls);
            } catch (e) {
              dev.log('Error processing image colors in isolate: $e');
            }
          }

          List<RecommendedTrackModel> recommendedTracks = [];
          int colorIndex = 0;

          for (final track in upNextTracks) {
            if (track.lowResImg == null || track.lowResImg!.isEmpty) {
              recommendedTracks.add(RecommendedTrackModel(
                track: track,
                backgroundColor: const Color(0xFFD8B4FA),
                textColor: Colors.black,
              ));
              continue;
            }

            if (colorIndex < colorResults.length) {
              final colorData = colorResults[colorIndex];
              recommendedTracks.add(RecommendedTrackModel(
                track: track,
                backgroundColor: Color(colorData['backgroundColor']!),
                textColor: Color(colorData['textColor']!),
              ));
              colorIndex++;
            } else {
              recommendedTracks.add(RecommendedTrackModel(
                track: track,
                backgroundColor: const Color(0xFFD8B4FA),
                textColor: Colors.black,
              ));
            }
          }

          updateData(
            data.copyWith(
              carouselRecommendedTracks:
                  recommendedTracks.sublist(0, recommendedTracks.length ~/ 2),
              gridRecommendedTracks: recommendedTracks.sublist(
                  recommendedTracks.length ~/ 2, recommendedTracks.length),
            ),
          );
        } catch (e) {
          catchError(e);
        }
      },
    );
  }
}
