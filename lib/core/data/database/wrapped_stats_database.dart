import 'dart:developer';

import 'package:isar/isar.dart';
import 'package:musily/core/data/database/collections/playback_album_stats.dart';
import 'package:musily/core/data/database/collections/playback_artist_stats.dart';
import 'package:musily/core/data/database/collections/playback_track_stats.dart';
import 'package:musily/core/data/database/collections/wrapped.dart';
import 'package:musily/core/data/database/database.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_album_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_artist_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_track_entity.dart';

class WrappedStatsDatabase {
  static final WrappedStatsDatabase _instance =
      WrappedStatsDatabase._internal();
  static WrappedStatsDatabase get instance => _instance;
  factory WrappedStatsDatabase() => _instance;
  WrappedStatsDatabase._internal();

  Isar get isar => Database().isar;

  Future<void> recordPlayback({
    required String trackId,
    required String trackJson,
    required String albumId,
    required String albumJson,
    required String artistId,
    required String artistJson,
    required int secondsPlayed,
    bool incrementPlayCount = true,
    DateTime? playedAt,
  }) async {
    if (secondsPlayed < 1) {
      log('[WrappedStatsDB] No seconds to record, skipping');
      return;
    }

    final date = playedAt ?? DateTime.now();
    final yearMonthKey = date.year * 100 + date.month;

    await isar.writeTxn(() async {
      await _updateOrCreateTrackStats(
        trackId: trackId,
        trackJson: trackJson,
        year: date.year,
        month: date.month,
        yearMonthKey: yearMonthKey,
        secondsPlayed: secondsPlayed,
        incrementPlayCount: incrementPlayCount,
      );

      await _updateOrCreateAlbumStats(
        albumId: albumId,
        albumJson: albumJson,
        year: date.year,
        month: date.month,
        yearMonthKey: yearMonthKey,
        secondsPlayed: secondsPlayed,
        incrementPlayCount: incrementPlayCount,
      );

      await _updateOrCreateArtistStats(
        artistId: artistId,
        artistJson: artistJson,
        year: date.year,
        month: date.month,
        yearMonthKey: yearMonthKey,
        secondsPlayed: secondsPlayed,
        incrementPlayCount: incrementPlayCount,
      );
    });

    log('[WrappedStatsDB] Stats recorded: ${secondsPlayed}s for track $trackId (playCount: $incrementPlayCount)');
  }

  Future<void> _updateOrCreateTrackStats({
    required String trackId,
    required String trackJson,
    required int year,
    required int month,
    required int yearMonthKey,
    required int secondsPlayed,
    required bool incrementPlayCount,
  }) async {
    final existing = await isar.playbackTrackStats
        .filter()
        .trackIdEqualTo(trackId)
        .and()
        .yearMonthKeyEqualTo(yearMonthKey)
        .findFirst();

    if (existing != null) {
      existing.secondsPlayed += secondsPlayed;
      if (incrementPlayCount) {
        existing.playCount += 1;
      }
      await isar.playbackTrackStats.put(existing);
    } else {
      final newStats = PlaybackTrackStats()
        ..trackId = trackId
        ..trackJson = trackJson
        ..year = year
        ..month = month
        ..yearMonthKey = yearMonthKey
        ..secondsPlayed = secondsPlayed
        ..playCount = incrementPlayCount ? 1 : 0;
      await isar.playbackTrackStats.put(newStats);
    }
  }

  Future<void> _updateOrCreateAlbumStats({
    required String albumId,
    required String albumJson,
    required int year,
    required int month,
    required int yearMonthKey,
    required int secondsPlayed,
    required bool incrementPlayCount,
  }) async {
    final existing = await isar.playbackAlbumStats
        .filter()
        .albumIdEqualTo(albumId)
        .and()
        .yearMonthKeyEqualTo(yearMonthKey)
        .findFirst();

    if (existing != null) {
      existing.secondsPlayed += secondsPlayed;
      if (incrementPlayCount) {
        existing.playCount += 1;
      }
      await isar.playbackAlbumStats.put(existing);
    } else {
      final newStats = PlaybackAlbumStats()
        ..albumId = albumId
        ..albumJson = albumJson
        ..year = year
        ..month = month
        ..yearMonthKey = yearMonthKey
        ..secondsPlayed = secondsPlayed
        ..playCount = incrementPlayCount ? 1 : 0;
      await isar.playbackAlbumStats.put(newStats);
    }
  }

  Future<void> _updateOrCreateArtistStats({
    required String artistId,
    required String artistJson,
    required int year,
    required int month,
    required int yearMonthKey,
    required int secondsPlayed,
    required bool incrementPlayCount,
  }) async {
    final existing = await isar.playbackArtistStats
        .filter()
        .artistIdEqualTo(artistId)
        .and()
        .yearMonthKeyEqualTo(yearMonthKey)
        .findFirst();

    if (existing != null) {
      existing.secondsPlayed += secondsPlayed;
      if (incrementPlayCount) {
        existing.playCount += 1;
      }
      await isar.playbackArtistStats.put(existing);
    } else {
      final newStats = PlaybackArtistStats()
        ..artistId = artistId
        ..artistJson = artistJson
        ..year = year
        ..month = month
        ..yearMonthKey = yearMonthKey
        ..secondsPlayed = secondsPlayed
        ..playCount = incrementPlayCount ? 1 : 0;
      await isar.playbackArtistStats.put(newStats);
    }
  }

  Future<int> getTotalMinutes(DateTime start, DateTime end) async {
    final startKey = start.year * 100 + start.month;
    final endKey = end.year * 100 + end.month;

    final stats = await isar.playbackTrackStats
        .filter()
        .yearMonthKeyBetween(startKey, endKey)
        .findAll();

    final totalSeconds =
        stats.fold<int>(0, (sum, stat) => sum + stat.secondsPlayed);
    return totalSeconds ~/ 60;
  }

  Future<int> getTotalPlays(DateTime start, DateTime end) async {
    final startKey = start.year * 100 + start.month;
    final endKey = end.year * 100 + end.month;

    final stats = await isar.playbackTrackStats
        .filter()
        .yearMonthKeyBetween(startKey, endKey)
        .findAll();

    return stats.fold<int>(0, (sum, stat) => sum + stat.playCount);
  }

  Future<int> getDistinctArtistsCount(DateTime start, DateTime end) async {
    final startKey = start.year * 100 + start.month;
    final endKey = end.year * 100 + end.month;

    final stats = await isar.playbackArtistStats
        .filter()
        .yearMonthKeyBetween(startKey, endKey)
        .findAll();

    final distinctArtists = <String>{};
    for (final stat in stats) {
      distinctArtists.add(stat.artistId);
    }

    return distinctArtists.length;
  }

  Future<int> getDistinctAlbumsCount(DateTime start, DateTime end) async {
    final startKey = start.year * 100 + start.month;
    final endKey = end.year * 100 + end.month;

    final stats = await isar.playbackAlbumStats
        .filter()
        .yearMonthKeyBetween(startKey, endKey)
        .findAll();

    final distinctAlbums = <String>{};
    for (final stat in stats) {
      distinctAlbums.add(stat.albumId);
    }

    return distinctAlbums.length;
  }

  Future<List<WrappedTrackEntity>> getTopTracks(
    DateTime start,
    DateTime end,
    int limit,
  ) async {
    final startKey = start.year * 100 + start.month;
    final endKey = end.year * 100 + end.month;

    final stats = await isar.playbackTrackStats
        .filter()
        .yearMonthKeyBetween(startKey, endKey)
        .findAll();

    final aggregated = <String, _TrackAggregate>{};
    for (final stat in stats) {
      if (aggregated.containsKey(stat.trackId)) {
        aggregated[stat.trackId]!.playCount += stat.playCount;
        aggregated[stat.trackId]!.secondsPlayed += stat.secondsPlayed;
      } else {
        aggregated[stat.trackId] = _TrackAggregate(
          trackId: stat.trackId,
          trackJson: stat.trackJson,
          playCount: stat.playCount,
          secondsPlayed: stat.secondsPlayed,
        );
      }
    }

    final sorted = aggregated.values.toList()
      ..sort((a, b) => b.secondsPlayed.compareTo(a.secondsPlayed));

    final topTracks = sorted.take(limit).toList();

    return topTracks.map((agg) {
      return WrappedTrackEntity.fromJson(agg.trackJson);
    }).toList();
  }

  Future<WrappedTrackEntity?> getMostListenedTrack(
    DateTime start,
    DateTime end,
  ) async {
    final topTracks = await getTopTracks(start, end, 1);
    return topTracks.isNotEmpty ? topTracks.first : null;
  }

  Future<int> getTrackPlayCount(
    DateTime start,
    DateTime end,
    String trackId,
  ) async {
    final startKey = start.year * 100 + start.month;
    final endKey = end.year * 100 + end.month;

    final stats = await isar.playbackTrackStats
        .filter()
        .trackIdEqualTo(trackId)
        .and()
        .yearMonthKeyBetween(startKey, endKey)
        .findAll();

    return stats.fold<int>(0, (sum, stat) => sum + stat.playCount);
  }

  Future<int> getTrackTotalMinutes(
    DateTime start,
    DateTime end,
    String trackId,
  ) async {
    final startKey = start.year * 100 + start.month;
    final endKey = end.year * 100 + end.month;

    final stats = await isar.playbackTrackStats
        .filter()
        .trackIdEqualTo(trackId)
        .and()
        .yearMonthKeyBetween(startKey, endKey)
        .findAll();

    final totalSeconds =
        stats.fold<int>(0, (sum, stat) => sum + stat.secondsPlayed);
    return totalSeconds ~/ 60;
  }

  Future<List<WrappedAlbumEntity>> getTopAlbums(
    DateTime start,
    DateTime end,
    int limit,
  ) async {
    final startKey = start.year * 100 + start.month;
    final endKey = end.year * 100 + end.month;

    final stats = await isar.playbackAlbumStats
        .filter()
        .yearMonthKeyBetween(startKey, endKey)
        .findAll();

    final aggregated = <String, _AlbumAggregate>{};
    for (final stat in stats) {
      if (aggregated.containsKey(stat.albumId)) {
        aggregated[stat.albumId]!.playCount += stat.playCount;
        aggregated[stat.albumId]!.secondsPlayed += stat.secondsPlayed;
      } else {
        aggregated[stat.albumId] = _AlbumAggregate(
          albumId: stat.albumId,
          albumJson: stat.albumJson,
          playCount: stat.playCount,
          secondsPlayed: stat.secondsPlayed,
        );
      }
    }

    final sorted = aggregated.values.toList()
      ..sort((a, b) => b.secondsPlayed.compareTo(a.secondsPlayed));

    final topAlbums = sorted.take(limit).toList();

    return topAlbums.map((agg) {
      return WrappedAlbumEntity.fromJson(agg.albumJson);
    }).toList();
  }

  Future<WrappedAlbumEntity?> getMostListenedAlbum(
    DateTime start,
    DateTime end,
  ) async {
    final topAlbums = await getTopAlbums(start, end, 1);
    return topAlbums.isNotEmpty ? topAlbums.first : null;
  }

  Future<int> getAlbumPlayCount(
    DateTime start,
    DateTime end,
    String albumId,
  ) async {
    final startKey = start.year * 100 + start.month;
    final endKey = end.year * 100 + end.month;

    final stats = await isar.playbackAlbumStats
        .filter()
        .albumIdEqualTo(albumId)
        .and()
        .yearMonthKeyBetween(startKey, endKey)
        .findAll();

    return stats.fold<int>(0, (sum, stat) => sum + stat.playCount);
  }

  Future<int> getAlbumTotalMinutes(
    DateTime start,
    DateTime end,
    String albumId,
  ) async {
    final startKey = start.year * 100 + start.month;
    final endKey = end.year * 100 + end.month;

    final stats = await isar.playbackAlbumStats
        .filter()
        .albumIdEqualTo(albumId)
        .and()
        .yearMonthKeyBetween(startKey, endKey)
        .findAll();

    final totalSeconds =
        stats.fold<int>(0, (sum, stat) => sum + stat.secondsPlayed);
    return totalSeconds ~/ 60;
  }

  Future<List<WrappedArtistEntity>> getTopArtists(
    DateTime start,
    DateTime end,
    int limit,
  ) async {
    final startKey = start.year * 100 + start.month;
    final endKey = end.year * 100 + end.month;

    final stats = await isar.playbackArtistStats
        .filter()
        .yearMonthKeyBetween(startKey, endKey)
        .findAll();

    final aggregated = <String, _ArtistAggregate>{};
    for (final stat in stats) {
      if (aggregated.containsKey(stat.artistId)) {
        aggregated[stat.artistId]!.playCount += stat.playCount;
        aggregated[stat.artistId]!.secondsPlayed += stat.secondsPlayed;
      } else {
        aggregated[stat.artistId] = _ArtistAggregate(
          artistId: stat.artistId,
          artistJson: stat.artistJson,
          playCount: stat.playCount,
          secondsPlayed: stat.secondsPlayed,
        );
      }
    }

    final sorted = aggregated.values.toList()
      ..sort((a, b) => b.secondsPlayed.compareTo(a.secondsPlayed));

    final topArtists = sorted.take(limit).toList();

    return topArtists.map((agg) {
      return WrappedArtistEntity.fromJson(agg.artistJson);
    }).toList();
  }

  Future<WrappedArtistEntity?> getMostListenedArtist(
    DateTime start,
    DateTime end,
  ) async {
    final topArtists = await getTopArtists(start, end, 1);
    return topArtists.isNotEmpty ? topArtists.first : null;
  }

  Future<int> getArtistPlayCount(
    DateTime start,
    DateTime end,
    String artistId,
  ) async {
    final startKey = start.year * 100 + start.month;
    final endKey = end.year * 100 + end.month;

    final stats = await isar.playbackArtistStats
        .filter()
        .artistIdEqualTo(artistId)
        .and()
        .yearMonthKeyBetween(startKey, endKey)
        .findAll();

    return stats.fold<int>(0, (sum, stat) => sum + stat.playCount);
  }

  Future<int> getArtistTotalMinutes(
    DateTime start,
    DateTime end,
    String artistId,
  ) async {
    final startKey = start.year * 100 + start.month;
    final endKey = end.year * 100 + end.month;

    final stats = await isar.playbackArtistStats
        .filter()
        .artistIdEqualTo(artistId)
        .and()
        .yearMonthKeyBetween(startKey, endKey)
        .findAll();

    final totalSeconds =
        stats.fold<int>(0, (sum, stat) => sum + stat.secondsPlayed);
    return totalSeconds ~/ 60;
  }

  Future<void> clearAllStats() async {
    await isar.writeTxn(() async {
      await isar.playbackTrackStats.clear();
      await isar.playbackAlbumStats.clear();
      await isar.playbackArtistStats.clear();
    });
    log('[WrappedStatsDB] All stats cleared');
  }

  Future<void> clearAllData() async {
    await isar.writeTxn(() async {
      await isar.playbackTrackStats.clear();
      await isar.playbackAlbumStats.clear();
      await isar.playbackArtistStats.clear();
      await isar.wrappeds.clear();
    });
    log('[WrappedStatsDB] All data cleared (stats + wrappeds)');
  }

  Future<void> saveWrappedEntity(WrappedEntity wrapped) async {
    final collection = Wrapped.fromEntity(wrapped);
    await isar.writeTxn(() async {
      await isar.wrappeds.put(collection);
    });
  }

  Future<WrappedEntity?> getWrappedByYear(int year) async {
    final collection =
        await isar.wrappeds.filter().yearEqualTo(year).findFirst();
    return collection?.toEntity();
  }

  Future<List<WrappedEntity>> getAllWrappedEntities() async {
    final collections = await isar.wrappeds.where().findAll();
    return collections.map((c) => c.toEntity()).toList();
  }

  Future<void> deleteWrappedByYear(int year) async {
    await isar.writeTxn(() async {
      await isar.wrappeds.filter().yearEqualTo(year).deleteAll();
    });
  }

  Future<void> clearAllWrappeds() async {
    await isar.writeTxn(() async {
      await isar.wrappeds.clear();
    });
  }
}

class _TrackAggregate {
  final String trackId;
  final String trackJson;
  int playCount;
  int secondsPlayed;

  _TrackAggregate({
    required this.trackId,
    required this.trackJson,
    required this.playCount,
    required this.secondsPlayed,
  });
}

class _AlbumAggregate {
  final String albumId;
  final String albumJson;
  int playCount;
  int secondsPlayed;

  _AlbumAggregate({
    required this.albumId,
    required this.albumJson,
    required this.playCount,
    required this.secondsPlayed,
  });
}

class _ArtistAggregate {
  final String artistId;
  final String artistJson;
  int playCount;
  int secondsPlayed;

  _ArtistAggregate({
    required this.artistId,
    required this.artistJson,
    required this.playCount,
    required this.secondsPlayed,
  });
}
