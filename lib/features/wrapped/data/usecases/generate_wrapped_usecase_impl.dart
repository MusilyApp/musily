import 'dart:math';

import 'package:musily/core/data/database/wrapped_stats_database.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/domain/usecases/generate_wrapped_usecase.dart';

class GenerateWrappedUsecaseImpl implements GenerateWrappedUsecase {
  final WrappedStatsDatabase wrappedStatsDatabase;

  GenerateWrappedUsecaseImpl({
    required this.wrappedStatsDatabase,
  });

  @override
  Future<WrappedEntity> exec({
    required DateTime rangeStart,
    required DateTime rangeEnd,
    int topItemsLimit = 5,
  }) async {
    final totalMinutes = await wrappedStatsDatabase.getTotalMinutes(
      rangeStart,
      rangeEnd,
    );

    final totalTracksPlayed = await wrappedStatsDatabase.getTotalPlays(
      rangeStart,
      rangeEnd,
    );

    final totalAlbumsPlayed = await wrappedStatsDatabase.getDistinctAlbumsCount(
      rangeStart,
      rangeEnd,
    );

    final totalArtistsPlayed =
        await wrappedStatsDatabase.getDistinctArtistsCount(
      rangeStart,
      rangeEnd,
    );

    final topTracks = await wrappedStatsDatabase.getTopTracks(
      rangeStart,
      rangeEnd,
      topItemsLimit,
    );

    final mostListenedTrack = await wrappedStatsDatabase.getMostListenedTrack(
      rangeStart,
      rangeEnd,
    );

    final mostListenedTrackPlays = mostListenedTrack != null
        ? await wrappedStatsDatabase.getTrackPlayCount(
            rangeStart,
            rangeEnd,
            mostListenedTrack.id,
          )
        : null;

    final mostListenedTrackMinutes = mostListenedTrack != null
        ? await wrappedStatsDatabase.getTrackTotalMinutes(
            rangeStart,
            rangeEnd,
            mostListenedTrack.id,
          )
        : null;

    final topAlbums = await wrappedStatsDatabase.getTopAlbums(
      rangeStart,
      rangeEnd,
      topItemsLimit,
    );

    final mostListenedAlbum = await wrappedStatsDatabase.getMostListenedAlbum(
      rangeStart,
      rangeEnd,
    );

    final mostListenedAlbumPlays = mostListenedAlbum != null
        ? await wrappedStatsDatabase.getAlbumPlayCount(
            rangeStart,
            rangeEnd,
            mostListenedAlbum.id,
          )
        : null;

    final mostListenedAlbumMinutes = mostListenedAlbum != null
        ? await wrappedStatsDatabase.getAlbumTotalMinutes(
            rangeStart,
            rangeEnd,
            mostListenedAlbum.id,
          )
        : null;

    final topArtists = await wrappedStatsDatabase.getTopArtists(
      rangeStart,
      rangeEnd,
      topItemsLimit,
    );

    final mostListenedArtist = await wrappedStatsDatabase.getMostListenedArtist(
      rangeStart,
      rangeEnd,
    );

    final mostListenedArtistPlays = mostListenedArtist != null
        ? await wrappedStatsDatabase.getArtistPlayCount(
            rangeStart,
            rangeEnd,
            mostListenedArtist.id,
          )
        : null;

    final mostListenedArtistMinutes = mostListenedArtist != null
        ? await wrappedStatsDatabase.getArtistTotalMinutes(
            rangeStart,
            rangeEnd,
            mostListenedArtist.id,
          )
        : null;

    final visualSeed = _generateVisualSeed(rangeStart, rangeEnd);

    final wrappedEntity = WrappedEntity(
      id: '${rangeStart.millisecondsSinceEpoch}_${rangeEnd.millisecondsSinceEpoch}',
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
      visualSeed: visualSeed,
      totalMinutesListened: totalMinutes,
      totalTracksListened: totalTracksPlayed,
      totalAlbumsListened: totalAlbumsPlayed,
      totalArtistsListened: totalArtistsPlayed,
      topTracks: topTracks,
      topAlbums: topAlbums,
      topArtists: topArtists,
      mostListenedTrack: mostListenedTrack,
      mostListenedTrackMinutes: mostListenedTrackMinutes,
      mostListenedTrackPlays: mostListenedTrackPlays,
      mostListenedAlbum: mostListenedAlbum,
      mostListenedAlbumMinutes: mostListenedAlbumMinutes,
      mostListenedAlbumPlays: mostListenedAlbumPlays,
      mostListenedArtist: mostListenedArtist,
      mostListenedArtistMinutes: mostListenedArtistMinutes,
      mostListenedArtistPlays: mostListenedArtistPlays,
    );

    await wrappedStatsDatabase.saveWrappedEntity(wrappedEntity);

    return wrappedEntity;
  }

  String _generateVisualSeed(DateTime rangeStart, DateTime rangeEnd) {
    final year = rangeEnd.year;
    final month = rangeEnd.month;

    final seedId = '$year$month';

    final random = Random(seedId.hashCode);

    final stableRandomValue = random.nextInt(0xFFFFFFFF);

    return stableRandomValue.toRadixString(16);
  }
}
