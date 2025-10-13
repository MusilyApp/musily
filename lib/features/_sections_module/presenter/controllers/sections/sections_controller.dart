import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/usecases/get_library_items_usecase.dart';
import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';
import 'package:musily/features/_sections_module/domain/usecases/get_sections_usecase.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_data.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_methods.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/core/domain/usecases/get_upnext_usecase.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';

class SectionsController extends BaseController<SectionsData, SectionsMethods> {
  late final GetSectionsUsecase _getSectionsUsecase;
  late final GetLibraryItemsUsecase _getLibraryItemsUsecase;
  late final GetUpNextUsecase _getUpNextUsecase;

  SectionsController({
    required GetSectionsUsecase getSectionsUsecase,
    required GetLibraryItemsUsecase getLibraryItemsUsecase,
    required GetUpNextUsecase getUpNextUsecase,
  }) {
    _getSectionsUsecase = getSectionsUsecase;
    _getLibraryItemsUsecase = getLibraryItemsUsecase;
    _getUpNextUsecase = getUpNextUsecase;
    methods.getSections();
  }

  @override
  SectionsData defineData() {
    return SectionsData(
      loadingSections: true,
      sections: [],
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
          // Generate recommendations after loading library
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

          // Filter albums and artists from library
          final albums =
              libraryItems.where((item) => item.album != null).toList();
          final artists =
              libraryItems.where((item) => item.artist != null).toList();

          // Get 3 random music items (tracks, albums, artists, or playlists)
          List<TrackEntity> seedTracks = [];
          final random = Random();

          // Collect all possible tracks from library
          for (final item in libraryItems) {
            if (item.album != null && item.album!.tracks.isNotEmpty) {
              seedTracks.addAll(item.album!.tracks);
            }
            if (item.artist != null && item.artist!.topTracks.isNotEmpty) {
              seedTracks.addAll(item.artist!.topTracks);
            }
            if (item.playlist != null && item.playlist!.tracks.isNotEmpty) {
              seedTracks.addAll(item.playlist!.tracks);
            }
          }

          // Select 3 random seed tracks
          if (seedTracks.isNotEmpty) {
            seedTracks.shuffle(random);
            seedTracks = seedTracks.take(3).toList();
          }

          // Get UpNext recommendations from seed tracks
          List<TrackEntity> upNextTracks = [];
          List<AlbumEntity> upNextAlbums = [];

          for (final seedTrack in seedTracks) {
            try {
              final upNext = await _getUpNextUsecase.exec(seedTrack);
              upNextTracks.addAll(upNext);

              // Extract albums from UpNext tracks
              for (final track in upNext) {
                // Convert SimplifiedAlbum to AlbumEntity
                final album = AlbumEntity(
                  id: track.album.id,
                  title: track.album.title,
                  artist: track.artist, // Use track's artist
                  year:
                      0, // Default year since SimplifiedAlbum doesn't have year
                  lowResImg: track.lowResImg, // Use track's image
                  highResImg: track.highResImg, // Use track's image
                  tracks: [], // Empty tracks list for now
                );
                upNextAlbums.add(album);
              }
            } catch (e) {
              print('Error getting UpNext for ${seedTrack.title}: $e');
            }
          }

          // Select recommended track from UpNext (max 1 for now)
          TrackEntity? randomTrack;
          List<TrackEntity> moreRecommendedTracks = [];
          if (upNextTracks.isNotEmpty) {
            randomTrack = upNextTracks[random.nextInt(upNextTracks.length)];
            // Add remaining tracks to moreRecommendedTracks (excluding the selected one)
            moreRecommendedTracks = upNextTracks
                .where((track) => track.hash != randomTrack!.hash)
                .toList();
          }

          // Select 3 random albums from UpNext albums
          List<LibraryItemEntity> randomAlbums = [];
          if (upNextAlbums.isNotEmpty) {
            upNextAlbums.shuffle(random);
            final selectedAlbums = upNextAlbums.take(3).toList();
            randomAlbums = selectedAlbums
                .map((album) => LibraryItemEntity(
                      id: album.id,
                      synced: false,
                      lastTimePlayed: DateTime.now(),
                      createdAt: DateTime.now(),
                      album: album,
                    ))
                .toList();
          }

          // Fallback to library albums if no UpNext albums
          if (randomAlbums.isEmpty && albums.isNotEmpty) {
            final maxAlbums = albums.length < 3 ? albums.length : 3;
            final shuffledAlbums = List<LibraryItemEntity>.from(albums);
            shuffledAlbums.shuffle(random);
            randomAlbums = shuffledAlbums.take(maxAlbums).toList();
          }

          // Fallback to library track if no UpNext track
          if (randomTrack == null) {
            if (artists.isNotEmpty) {
              final artistsWithTracks = artists
                  .where((item) =>
                      item.artist != null && item.artist!.topTracks.isNotEmpty)
                  .toList();

              if (artistsWithTracks.isNotEmpty) {
                final randomArtistIndex =
                    random.nextInt(artistsWithTracks.length);
                final randomArtist = artistsWithTracks[randomArtistIndex];
                final randomTrackIndex =
                    random.nextInt(randomArtist.artist!.topTracks.length);
                randomTrack = randomArtist.artist!.topTracks[randomTrackIndex];
              }
            }

            if (randomTrack == null && albums.isNotEmpty) {
              final albumsWithTracks = albums
                  .where((item) =>
                      item.album != null && item.album!.tracks.isNotEmpty)
                  .toList();

              if (albumsWithTracks.isNotEmpty) {
                final randomAlbumIndex =
                    random.nextInt(albumsWithTracks.length);
                final randomAlbum = albumsWithTracks[randomAlbumIndex];
                final randomTrackIndex =
                    random.nextInt(randomAlbum.album!.tracks.length);
                randomTrack = randomAlbum.album!.tracks[randomTrackIndex];
              }
            }
          }

          // Extract colors for the recommended track
          Color? trackBackgroundColor;
          Color? trackTextColor;

          if (randomTrack != null &&
              randomTrack.lowResImg != null &&
              randomTrack.lowResImg!.isNotEmpty) {
            try {
              final imageProvider =
                  CachedNetworkImageProvider(randomTrack.lowResImg!);
              final colorScheme = await ColorScheme.fromImageProvider(
                provider: imageProvider,
              );

              final dominantColor = colorScheme.primary;
              final luminance = dominantColor.computeLuminance();

              trackBackgroundColor = dominantColor;
              trackTextColor = luminance > 0.5 ? Colors.black : Colors.white;
            } catch (e) {
              // Use default colors if extraction fails
              trackBackgroundColor = const Color(0xFFD8B4FA);
              trackTextColor = const Color(0xFF1A0033);
            }
          }

          // Debug information
          print(
              'Recommended Albums: ${randomAlbums.map((a) => a.album?.title ?? "None").join(", ")}');
          print('Recommended Track: ${randomTrack?.title ?? "None"}');
          print('Albums count: ${albums.length}');
          print('Artists count: ${artists.length}');

          updateData(
            data.copyWith(
              recommendedAlbums: randomAlbums,
              recommendedTrack: randomTrack,
              recommendedTrackBackgroundColor: trackBackgroundColor,
              recommendedTrackTextColor: trackTextColor,
              moreRecommendedTracks: moreRecommendedTracks,
            ),
          );
        } catch (e) {
          catchError(e);
        }
      },
    );
  }
}
