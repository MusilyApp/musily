import 'package:isar/isar.dart';
import 'package:musily/core/data/database/collections/user_tracks.dart';
import 'package:musily/core/data/database/database.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class UserTracksDB {
  final Database _database = Database();

  Future<void> addTracksToPlaylist(
    String playlistId,
    List<TrackEntity> tracks,
  ) async {
    final userId = UserService().currentUser?.id ?? 'anonymous';
    await _database.isar.writeTxn(
      () async {
        final existingTrackHashes = await _database.isar.userTracks
            .filter()
            .libraryItemIdEqualTo(playlistId)
            .anyOf(tracks.map((track) => track.hash).toList(),
                (q, hash) => q.hashEqualTo(hash))
            .findAll()
            .then((tracks) => tracks.map((track) => track.hash).toSet());

        final newTracks = tracks
            .where((track) => !existingTrackHashes.contains(track.hash))
            .toList();

        final trackCount = await _database.isar.userTracks
            .filter()
            .libraryItemIdEqualTo(playlistId)
            .count();

        await _database.isar.userTracks.putAll([
          ...newTracks.map(
            (e) {
              final newTrackIndex = newTracks.indexOf(e);
              return UserTracks()
                ..musilyId = e.id
                ..libraryItemId = playlistId
                ..hash = e.hash
                ..orderIndex = trackCount + (newTrackIndex + 1)
                ..userId = userId
                ..highResImg = e.highResImg ?? ''
                ..lowResImg = e.lowResImg ?? ''
                ..title = e.title
                ..albumId = e.album.id
                ..albumTitle = e.album.title
                ..artistId = e.artist.id
                ..artistName = e.artist.name
                ..duration = e.duration.inSeconds
                ..createdAt = DateTime.now();
            },
          ),
        ]);
      },
    );
  }

  Future<void> removeTracksFromPlaylist(
    String playlistId,
    List<String> trackIds,
  ) async {
    await _database.isar.writeTxn(
      () async {
        final pattern = trackIds.map((id) => '*$id*').join(',');

        await _database.isar.userTracks
            .filter()
            .libraryItemIdEqualTo(playlistId)
            .musilyIdMatches(pattern)
            .deleteAll();
      },
    );
  }

  Future<List<TrackEntity>> getPlaylistTracks(String playlistId) async {
    final userId = UserService().currentUser?.id ?? 'anonymous';
    final items = await _database.isar.userTracks
        .filter()
        .libraryItemIdEqualTo(playlistId)
        .and()
        .userIdEqualTo(userId)
        .sortByOrderIndex()
        .findAll();
    return [
      ...items.map(
        (e) => TrackEntity(
          id: e.musilyId,
          title: e.title,
          orderIndex: e.orderIndex,
          hash: e.hash,
          artist: SimplifiedArtist(
            id: e.artistId,
            name: e.artistName,
          ),
          album: SimplifiedAlbum(
            id: e.albumId,
            title: e.albumTitle,
          ),
          highResImg: e.highResImg,
          lowResImg: e.lowResImg,
          fromSmartQueue: false,
          duration: Duration(
            seconds: e.duration,
          ),
        ),
      ),
    ];
  }

  Future<int> getTrackCount(String playlistId) async {
    final userId = UserService().currentUser?.id ?? 'anonymous';
    return _database.isar.userTracks
        .filter()
        .libraryItemIdEqualTo(playlistId)
        .and()
        .userIdEqualTo(userId)
        .count();
  }

  Future<void> deleteAllPlaylistTracks(String playlistId) async {
    await _database.isar.writeTxn(() async {
      await _database.isar.userTracks
          .filter()
          .libraryItemIdEqualTo(playlistId)
          .deleteAll();
    });
  }

  Future<void> cleanCloudUserTracks() async {
    final userId = UserService().currentUser?.id ?? 'anonymous';
    _database.isar.writeTxn(
      () async {
        await _database.isar.userTracks
            .filter()
            .userIdEqualTo(userId)
            .deleteAll();
      },
    );
  }
}
