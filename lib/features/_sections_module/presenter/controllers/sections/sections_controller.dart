import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/_library_module/domain/usecases/get_library_items_usecase.dart';
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

          // Get 3 random music items (tracks, albums, artists, or playlists)
          List<TrackEntity> seedTracks = [];
          final random = Random();

          // Select 3 random albums
          final randomAlbums = shuffledLibraryItems
              .where((item) => item.album != null)
              .toList()
              .take(3)
              .toList();
          // Select 1 random artists
          final randomArtist = shuffledLibraryItems
              .where((item) => item.artist != null)
              .toList()
              .take(1)
              .toList();
          // Select 1 random playlists
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

          // Select 3 random seed tracks
          if (seedTracks.isNotEmpty) {
            seedTracks.shuffle(random);
            seedTracks = seedTracks.take(3).toList();
          }

          // Get UpNext recommendations from seed tracks
          List<TrackEntity> upNextTracks = [];

          for (final seedTrack in seedTracks) {
            try {
              final upNext = await _getUpNextUsecase.exec(seedTrack);
              upNextTracks.addAll(upNext);
            } catch (e) {
              dev.log('Error getting UpNext for ${seedTrack.title}: $e');
            }
          }

          List<RecommendedTrackModel> recommendedTracks = [];

          for (final track in upNextTracks) {
            try {
              final imageProvider =
                  CachedNetworkImageProvider(track.lowResImg!);
              final colorScheme = await ColorScheme.fromImageProvider(
                provider: imageProvider,
              );

              final dominantColor = colorScheme.primary;
              final luminance = dominantColor.computeLuminance();

              final trackBackgroundColor = dominantColor;
              final trackTextColor =
                  luminance > 0.5 ? Colors.black : Colors.white;
              recommendedTracks.add(RecommendedTrackModel(
                track: track,
                backgroundColor: trackBackgroundColor,
                textColor: trackTextColor,
              ));
            } catch (e) {
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
