import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class LibraryItemEntity {
  String id;
  ArtistEntity? artist;
  AlbumEntity? album;
  PlaylistEntity? playlist;
  bool synced;
  DateTime lastTimePlayed;
  DateTime createdAt;

  LibraryItemEntity({
    required this.id,
    required this.lastTimePlayed,
    this.artist,
    this.album,
    this.playlist,
    required this.synced,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'LibraryItemEntity(id: $id, artist: $artist, album: $album, playlist: $playlist, synced: $synced, lastTimePlayed: $lastTimePlayed, createdAt: $createdAt)';
  }
}
