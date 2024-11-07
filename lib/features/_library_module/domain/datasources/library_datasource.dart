import 'package:musily/features/_library_module/data/dtos/create_playlist_dto.dart';
import 'package:musily/features/_library_module/data/dtos/update_playlist_dto.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

abstract class LibraryDatasource {
  Future<List<LibraryItemEntity>> getLibraryItems();
  Future<LibraryItemEntity?> getLibraryItem(String itemId);
  Future<LibraryItemEntity> updateLibraryItem(LibraryItemEntity item);

  // Playlist
  Future<PlaylistEntity> createPlaylist(CreatePlaylistDTO data);
  Future<void> addTracksToPlaylist(
    String playlistId,
    List<TrackEntity> tracks,
  );
  Future<void> removeTracksFromPlaylist(
    String playlistId,
    List<String> trackIds,
  );
  Future<PlaylistEntity?> updatePlaylist(
    UpdatePlaylistDto data,
  );
  Future<void> deletePlaylist(String playlistId);

  // Artist
  Future<void> addArtistToLibrary(ArtistEntity artist);
  Future<void> removeArtistFromLibrary(String artistId);

  // Album
  Future<LibraryItemEntity> addAlbumToLibrary(AlbumEntity album);
  Future<void> removeAlbumFromLibrary(String albumId);
}
