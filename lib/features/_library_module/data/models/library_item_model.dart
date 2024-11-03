import 'package:musily/core/utils/id_generator.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/album/data/models/album_model.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/data/models/artist_model.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/playlist/data/models/playlist_model.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class LibraryItemModel {
  static LibraryItemEntity fromMap(Map<String, dynamic> map) {
    return LibraryItemEntity(
      id: map['id'],
      synced: map['synced'] ?? true,
      lastTimePlayed: DateTime.parse(map['lastTimePlayed']),
      artist: map['artist'] != null ? ArtistModel.fromMap(map['artist']) : null,
      album: map['album'] != null ? AlbumModel.fromMap(map['album']) : null,
      playlist: map['playlist'] != null
          ? PlaylistModel.fromMap(map['playlist'])
          : null,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  static Map<String, dynamic> toMap(LibraryItemEntity libraryItem) {
    return {
      'id': libraryItem.id,
      'lastTimePlayed': libraryItem.lastTimePlayed.toIso8601String(),
      'synced': libraryItem.synced,
      if (libraryItem.artist != null)
        'artist': ArtistModel.toMap(libraryItem.artist!),
      if (libraryItem.album != null)
        'album': AlbumModel.toMap(libraryItem.album!),
      if (libraryItem.playlist != null)
        'playlist': PlaylistModel.toMap(libraryItem.playlist!),
      'createdAt': libraryItem.createdAt.toIso8601String(),
    };
  }

  static LibraryItemEntity newInstance({
    String? id,
    DateTime? lastTimePlayed,
    bool? synced,
    PlaylistEntity? playlist,
    AlbumEntity? album,
    ArtistEntity? artist,
    DateTime? createdAt,
  }) {
    return LibraryItemEntity(
      id: id ?? idGenerator(),
      lastTimePlayed: lastTimePlayed ?? DateTime.now(),
      synced: synced ?? false,
      playlist: playlist,
      album: album,
      artist: artist,
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}
