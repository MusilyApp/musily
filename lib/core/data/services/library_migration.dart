import 'dart:developer';

import 'package:musily/core/data/database/legacy_library_database.dart';
import 'package:musily/core/data/database/library_database.dart';
import 'package:musily/core/data/database/user_tracks_db.dart';
import 'package:musily/features/_library_module/data/datasources/legacy_library_datasource_impl.dart';
import 'package:musily/features/_library_module/data/models/library_item_model.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class LibraryMigrationService {
  late final LegacyLibraryDatabase legacyDb;
  late final LegacyLibraryDatasourceImpl legacyLibraryDatasource;

  final libraryDatabase = LibraryDatabase();
  final userTracksDB = UserTracksDB();

  LibraryMigrationService() {
    legacyDb = LegacyLibraryDatabase();
    legacyLibraryDatasource = LegacyLibraryDatasourceImpl(
      modelAdapter: legacyDb,
      downloaderController: DownloaderController(),
    );
  }

  Future<void> migrateLibrary() async {
    try {
      final items = await legacyLibraryDatasource.getLibrary();
      for (final item in items) {
        if (item.value is AlbumEntity) {
          final album = (item.value as AlbumEntity);
          if (album.tracks.isEmpty) {
            continue;
          }
          final artist = album.tracks.first.artist;
          await libraryDatabase.put(
            LibraryItemModel.toMap(
              LibraryItemModel.newInstance(
                id: album.id,
                album: album..artist = artist,
                synced: false,
                lastTimePlayed: item.lastTimePlayed,
              ),
            ),
          );
        } else if (item.value is PlaylistEntity) {
          final playlist = (item.value as PlaylistEntity);
          final tracks = playlist.tracks;
          final trackCount = playlist.tracks.length;
          final playlistId =
              playlist.id == 'favorites' ? 'favorites.anonymous' : playlist.id;
          await libraryDatabase.put(
            LibraryItemModel.toMap(
              LibraryItemModel.newInstance(
                id: playlistId,
                lastTimePlayed: item.lastTimePlayed,
                playlist: playlist
                  ..id = playlistId
                  ..tracks = []
                  ..trackCount = trackCount,
              ),
            ),
          );
          await userTracksDB.addTracksToPlaylist(playlist.id, tracks);
        } else {
          final artist = (item.value as ArtistEntity);
          await libraryDatabase.put(
            LibraryItemModel.toMap(
              LibraryItemModel.newInstance(
                id: artist.id,
                artist: artist,
                synced: false,
                lastTimePlayed: item.lastTimePlayed,
              ),
            ),
          );
        }
      }
      await legacyDb.cleanLegacyDatabase();
    } catch (e, stacktrace) {
      log('[$e] - $stacktrace');
    }
  }
}
