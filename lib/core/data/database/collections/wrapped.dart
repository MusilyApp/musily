import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_album_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_artist_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_track_entity.dart';

part 'wrapped.g.dart';

@Collection()
class Wrapped {
  Id id = Isar.autoIncrement;

  @Index()
  DateTime periodStart = DateTime.now();
  @Index()
  DateTime periodEnd = DateTime.now();
  DateTime generatedAt = DateTime.now();
  String seed = '';

  int totalMinutes = 0;
  int totalTracksPlayed = 0;
  int totalArtistsPlayed = 0;
  int totalAlbumsPlayed = 0;

  String topTracksJson = '';
  String topAlbumsJson = '';
  String topArtistsJson = '';

  String? mostPlayedTrackJson;
  int? mostPlayedTrackMinutes;
  int? mostPlayedTrackPlays;

  String? mostPlayedAlbumJson;
  int? mostPlayedAlbumMinutes;
  int? mostPlayedAlbumPlays;

  String? mostPlayedArtistJson;
  int? mostPlayedArtistMinutes;
  int? mostPlayedArtistPlays;

  @Index()
  int year = DateTime.now().year;

  static Wrapped fromEntity(WrappedEntity entity) {
    final wrapped = Wrapped();
    wrapped.periodStart = entity.rangeStart;
    wrapped.periodEnd = entity.rangeEnd;
    wrapped.generatedAt = DateTime.now();
    wrapped.seed = entity.visualSeed;
    wrapped.totalMinutes = entity.totalMinutesListened;
    wrapped.totalTracksPlayed = entity.totalTracksListened;
    wrapped.totalArtistsPlayed = entity.totalArtistsListened;
    wrapped.totalAlbumsPlayed = entity.totalAlbumsListened;
    wrapped.topTracksJson =
        jsonEncode(entity.topTracks.map((e) => e.toJson()).toList());
    wrapped.topAlbumsJson =
        jsonEncode(entity.topAlbums.map((e) => e.toJson()).toList());
    wrapped.topArtistsJson =
        jsonEncode(entity.topArtists.map((e) => e.toJson()).toList());
    wrapped.mostPlayedTrackJson = entity.mostListenedTrack?.toJson();
    wrapped.mostPlayedTrackMinutes = entity.mostListenedTrackMinutes;
    wrapped.mostPlayedTrackPlays = entity.mostListenedTrackPlays;
    wrapped.mostPlayedAlbumJson = entity.mostListenedAlbum?.toJson();
    wrapped.mostPlayedAlbumMinutes = entity.mostListenedAlbumMinutes;
    wrapped.mostPlayedAlbumPlays = entity.mostListenedAlbumPlays;
    wrapped.mostPlayedArtistJson = entity.mostListenedArtist?.toJson();
    wrapped.mostPlayedArtistMinutes = entity.mostListenedArtistMinutes;
    wrapped.mostPlayedArtistPlays = entity.mostListenedArtistPlays;
    wrapped.year = entity.rangeStart.year;
    return wrapped;
  }

  WrappedEntity toEntity() {
    final List<dynamic> topTracksDecoded =
        topTracksJson.isNotEmpty ? jsonDecode(topTracksJson) : [];
    final List<dynamic> topAlbumsDecoded =
        topAlbumsJson.isNotEmpty ? jsonDecode(topAlbumsJson) : [];
    final List<dynamic> topArtistsDecoded =
        topArtistsJson.isNotEmpty ? jsonDecode(topArtistsJson) : [];

    return WrappedEntity(
      id: '$year',
      rangeStart: periodStart,
      rangeEnd: periodEnd,
      visualSeed: seed,
      totalMinutesListened: totalMinutes,
      totalTracksListened: totalTracksPlayed,
      totalAlbumsListened: totalAlbumsPlayed,
      totalArtistsListened: totalArtistsPlayed,
      topTracks:
          topTracksDecoded.map((e) => WrappedTrackEntity.fromJson(e)).toList(),
      topAlbums:
          topAlbumsDecoded.map((e) => WrappedAlbumEntity.fromJson(e)).toList(),
      topArtists: topArtistsDecoded
          .map((e) => WrappedArtistEntity.fromJson(e))
          .toList(),
      mostListenedTrack: mostPlayedTrackJson != null
          ? WrappedTrackEntity.fromJson(mostPlayedTrackJson!)
          : null,
      mostListenedTrackMinutes: mostPlayedTrackMinutes,
      mostListenedTrackPlays: mostPlayedTrackPlays,
      mostListenedAlbum: mostPlayedAlbumJson != null
          ? WrappedAlbumEntity.fromJson(mostPlayedAlbumJson!)
          : null,
      mostListenedAlbumMinutes: mostPlayedAlbumMinutes,
      mostListenedAlbumPlays: mostPlayedAlbumPlays,
      mostListenedArtist: mostPlayedArtistJson != null
          ? WrappedArtistEntity.fromJson(mostPlayedArtistJson!)
          : null,
      mostListenedArtistMinutes: mostPlayedArtistMinutes,
      mostListenedArtistPlays: mostPlayedArtistPlays,
    );
  }
}
