import 'package:musily/core/data/database/user_tracks_db.dart';
import 'package:musily/core/data/repositories/musily_repository_impl.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/domain/adapters/database_adapter.dart';
import 'package:musily/core/domain/adapters/http_adapter.dart';
import 'package:musily/core/domain/datasources/base_datasource.dart';
import 'package:musily/core/utils/id_generator.dart';
import 'package:musily/features/_library_module/data/dtos/create_playlist_dto.dart';
import 'package:musily/features/_library_module/data/dtos/update_playlist_dto.dart';
import 'package:musily/features/_library_module/data/models/library_item_model.dart';
import 'package:musily/features/_library_module/domain/datasources/library_datasource.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/album/data/models/album_model.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/data/models/artist_model.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/playlist/data/models/playlist_model.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class LibraryDatasourceImpl extends BaseDatasource
    implements LibraryDatasource {
  late final DatabaseModelAdapter _modelAdapter;
  late final HttpAdapter _httpAdapter;

  final userTracksDB = UserTracksDB();
  final musilyRepository = MusilyRepositoryImpl();

  LibraryDatasourceImpl({
    required HttpAdapter httpAdapter,
    required DatabaseModelAdapter modelAdapter,
  }) {
    _httpAdapter = httpAdapter;
    _modelAdapter = modelAdapter;
  }

  @override
  Future<LibraryItemEntity> addAlbumToLibrary(AlbumEntity album) {
    return exec<LibraryItemEntity>(() async {
      if (UserService.loggedIn) {
        final response = await _httpAdapter.post(
          '/library/add_album_to_library',
          data: AlbumModel.toMap(album),
        );
        await _modelAdapter.put(response.data);
        final libraryItem = LibraryItemModel.fromMap(response.data);
        return libraryItem;
      }
      final anonymousItem = LibraryItemModel.newInstance(album: album);
      await _modelAdapter.put(LibraryItemModel.toMap(anonymousItem));
      return anonymousItem;
    });
  }

  @override
  Future<LibraryItemEntity> addArtistToLibrary(ArtistEntity artist) {
    return exec(() async {
      if (UserService.loggedIn) {
        final response = await _httpAdapter.post(
          '/library/add_artist_to_library',
          data: ArtistModel.toMap(artist),
        );
        await _modelAdapter.put(response.data);
        return LibraryItemModel.fromMap(response.data);
      }
      final anonymousItem = LibraryItemModel.newInstance(artist: artist);
      await _modelAdapter.put(LibraryItemModel.toMap(anonymousItem));
      return anonymousItem;
    });
  }

  @override
  Future<void> addTracksToPlaylist(
    String playlistId,
    List<TrackEntity> tracks,
  ) {
    return exec<void>(() async {
      if (UserService.loggedIn) {
        await _httpAdapter.post(
          '/library/add_tracks_to_playlist',
          data: {
            'playlistId': playlistId,
            'tracks': [...tracks.map((e) => TrackModel.toMap(e))],
          },
        );
      }
      final currentPlaylist = await _modelAdapter.findById(playlistId);
      if (currentPlaylist != null) {
        await userTracksDB.addTracksToPlaylist(playlistId, tracks);
        final trackCount = await userTracksDB.getTrackCount(playlistId);
        currentPlaylist['playlist']?['trackCount'] = trackCount;
        await _modelAdapter.put(currentPlaylist);
      } else if (playlistId == UserService.favoritesId) {
        await userTracksDB.addTracksToPlaylist(playlistId, tracks);
        final trackCount = await userTracksDB.getTrackCount(playlistId);
        await _modelAdapter.put(
          LibraryItemModel.toMap(
            LibraryItemModel.newInstance(
              id: UserService.favoritesId,
              playlist: PlaylistEntity(
                id: UserService.favoritesId,
                title: 'favorites',
                tracks: [],
                trackCount: trackCount,
              ),
            ),
          ),
        );
      }
    });
  }

  @override
  Future<PlaylistEntity> createPlaylist(CreatePlaylistDTO data) {
    return exec<PlaylistEntity>(() async {
      if (UserService.loggedIn) {
        final response = await _httpAdapter.post(
          '/library/create_playlist',
          data: data.toMap(),
        );
        final playlist = PlaylistModel.fromMap(response.data);
        await _modelAdapter.put(
          LibraryItemModel.toMap(
            LibraryItemModel.newInstance(playlist: playlist),
          ),
        );
        return playlist;
      }
      final playlistId = idGenerator();
      final anonymousItem = LibraryItemModel.newInstance(
        id: playlistId,
        playlist: PlaylistEntity(
          id: playlistId,
          title: data.title,
          tracks: [],
          trackCount: data.tracks.length,
        ),
      );
      await _modelAdapter.put(LibraryItemModel.toMap(anonymousItem));
      await userTracksDB.addTracksToPlaylist(playlistId, data.tracks);
      return anonymousItem.playlist!;
    });
  }

  @override
  Future<void> deletePlaylist(String playlistId) {
    return exec(() async {
      if (UserService.loggedIn) {
        await _httpAdapter.delete('/library/delete_playlist/$playlistId');
      }
      await _modelAdapter.findByIdAndDelete(playlistId);
      await userTracksDB.deleteAllPlaylistTracks(playlistId);
    });
  }

  @override
  Future<LibraryItemEntity?> getLibraryItem(String itemId) async {
    try {
      if (UserService.loggedIn) {
        final response = await _httpAdapter.get(
          '/library/get_library_item/$itemId',
        );
        final libraryItem = LibraryItemModel.fromMap(response.data);
        if (libraryItem.playlist != null) {
          final tracks = libraryItem.playlist!.tracks;
          response.data['playlist']['tracks'] = [];
          await userTracksDB.addTracksToPlaylist(itemId, tracks);
        }
        if (libraryItem.artist != null) {
          final artist = await musilyRepository.getArtist(libraryItem.id);
          response.data['artist'] = ArtistModel.toMap(
            artist ?? libraryItem.artist!,
          );
        }
        await _modelAdapter.put(response.data);
        return libraryItem;
      }
      final anonymousItem = await _modelAdapter.findById(itemId);
      if (anonymousItem != null) {
        final item = LibraryItemModel.fromMap(anonymousItem);
        if (item.playlist != null) {
          final tracks = await userTracksDB.getPlaylistTracks(itemId);
          item.playlist!.tracks = tracks;
        }
        return item;
      }
      return null;
    } catch (e) {
      final data = await _modelAdapter.findById(itemId);
      if (data != null) {
        final item = LibraryItemModel.fromMap(data);
        if (item.playlist != null) {
          final tracks = await userTracksDB.getPlaylistTracks(itemId);
          item.playlist!.tracks = tracks;
        }
        return item;
      }
      return null;
    }
  }

  @override
  Future<List<LibraryItemEntity>> getLibraryItems() {
    String? contentKeyForItem(LibraryItemEntity item) {
      if (item.album != null) {
        return 'album_${item.album!.id}';
      }
      if (item.artist != null) {
        return 'artist_${item.artist!.id}';
      }
      if (item.playlist != null) {
        return 'playlist_${item.playlist!.id}';
      }
      return null;
    }

    List<LibraryItemEntity> dedupeLibraryItems(List<LibraryItemEntity> items) {
      final deduped = <String, LibraryItemEntity>{};
      for (final item in items) {
        final key = contentKeyForItem(item) ?? 'id_${item.id}';
        if (!deduped.containsKey(key)) {
          deduped[key] = item;
        }
      }
      return deduped.values.toList();
    }

    return exec<List<LibraryItemEntity>>(
      () async {
        if (UserService.loggedIn) {
          final response = await _httpAdapter.get('/library/get_library_items');
          final libraryItems = <LibraryItemEntity>[
            ...response.data.map((item) => LibraryItemModel.fromMap(item)),
          ];
          final deduped = dedupeLibraryItems(libraryItems);
          return deduped;
        }
        final anonymousLibrary = await _modelAdapter.getAll();
        final libraryItems = [
          ...anonymousLibrary.map((e) => LibraryItemModel.fromMap(e)),
        ];
        final deduped = dedupeLibraryItems(libraryItems);
        return deduped;
      },
      onCatch: () async {
        final library = await _modelAdapter.getAll();
        final libraryItems = [
          ...library.map((e) => LibraryItemModel.fromMap(e)),
        ];
        final deduped = dedupeLibraryItems(libraryItems);
        return deduped;
      },
    );
  }

  @override
  Future<void> removeAlbumFromLibrary(String albumId) {
    return exec(() async {
      if (UserService.loggedIn) {
        await _httpAdapter.delete(
          '/library/remove_album_from_library/$albumId',
        );
      }
      await _modelAdapter.findByIdAndDelete(albumId);
    });
  }

  @override
  Future<void> removeArtistFromLibrary(String artistId) {
    return exec<void>(() async {
      if (UserService.loggedIn) {
        await _httpAdapter.delete(
          '/library/remove_artist_from_library/$artistId',
        );
      }
      await _modelAdapter.findByIdAndDelete(artistId);
    });
  }

  @override
  Future<void> removeTracksFromPlaylist(
    String playlistId,
    List<String> trackIds,
  ) {
    return exec<void>(() async {
      if (UserService.loggedIn) {
        await _httpAdapter.delete(
          '/library/remove_tracks_from_playlist/$playlistId',
          data: {'tracks': trackIds},
        );
      }
      final currentPlaylist = await _modelAdapter.findById(playlistId);
      if (currentPlaylist != null) {
        await userTracksDB.removeTracksFromPlaylist(playlistId, trackIds);
        final trackCount = await userTracksDB.getTrackCount(playlistId);
        currentPlaylist['playlist']?['trackCount'] = trackCount;
        await _modelAdapter.put(currentPlaylist);
      }
    });
  }

  @override
  Future<void> updateTrackInPlaylist(
    String playlistId,
    String trackId,
    TrackEntity updatedTrack,
  ) {
    return exec<void>(() async {
      if (UserService.loggedIn) {
        // TODO: Implement this route in the backend
        await _httpAdapter.put(
          '/library/update_track_in_playlist/$playlistId/$trackId',
          data: TrackModel.toMap(updatedTrack),
        );
      }
      final currentPlaylist = await _modelAdapter.findById(playlistId);
      if (currentPlaylist != null) {
        await userTracksDB.updateTrackInPlaylist(
          playlistId,
          trackId,
          updatedTrack,
        );
        final trackCount = await userTracksDB.getTrackCount(playlistId);
        currentPlaylist['playlist']?['trackCount'] = trackCount;
        await _modelAdapter.put(currentPlaylist);
      }
    });
  }

  @override
  Future<PlaylistEntity?> updatePlaylist(UpdatePlaylistDto data) {
    return exec<PlaylistEntity?>(
      () async {
        Map<String, dynamic>? responseData;
        if (UserService.loggedIn) {
          final response = await _httpAdapter.put(
            '/library/playlists/${data.id}',
            data: data.toMap(),
          );
          responseData = response.data;
        }
        final currentPlaylist = await _modelAdapter.findById(data.id);
        if (currentPlaylist != null) {
          currentPlaylist['playlist']?['title'] = data.title;
          await _modelAdapter.put(currentPlaylist);
          return PlaylistModel.fromMap(
              responseData ?? currentPlaylist['playlist']);
        }
        return null;
      },
      onCatch: () async {
        return null;
      },
    );
  }

  @override
  Future<LibraryItemEntity> updateLibraryItem(LibraryItemEntity item) {
    return exec(() async {
      final libraryItemMap = LibraryItemModel.toMap(item);
      libraryItemMap['playlist']?['tracks'] = [];
      if (UserService.loggedIn) {
        await _httpAdapter.patch(
          '/library/update_library_item',
          data: libraryItemMap,
        );
      }
      await _modelAdapter.put(libraryItemMap);
      return item;
    });
  }

  @override
  Future<void> mergeLibrary(List<LibraryItemEntity> items) {
    return exec(() async {
      final existingItems = await _modelAdapter.getAll();

      final existingByContentId = <String, Map<String, dynamic>>{};
      final duplicates = <String>[];

      for (final existing in existingItems) {
        String? contentId;
        if (existing['album'] != null && existing['album']['id'] != null) {
          contentId = 'album_${existing['album']['id']}';
        } else if (existing['artist'] != null &&
            existing['artist']['id'] != null) {
          contentId = 'artist_${existing['artist']['id']}';
        } else if (existing['playlist'] != null &&
            existing['playlist']['id'] != null) {
          contentId = 'playlist_${existing['playlist']['id']}';
        }

        if (contentId != null) {
          if (!existingByContentId.containsKey(contentId)) {
            existingByContentId[contentId] = existing;
          } else {
            final duplicateId = existing['id'];
            if (duplicateId != null) {
              duplicates.add('$duplicateId');
            }
          }
        }
      }

      if (duplicates.isNotEmpty) {
        for (final duplicateId in duplicates) {
          await _modelAdapter.findByIdAndDelete(duplicateId);
        }
      }

      final itemsToMerge = <Map<String, dynamic>>[];
      final itemsMapList = [...items.map((e) => LibraryItemModel.toMap(e))];

      for (final itemMap in itemsMapList) {
        String? contentId;
        if (itemMap['album'] != null && itemMap['album']['id'] != null) {
          contentId = 'album_${itemMap['album']['id']}';
        } else if (itemMap['artist'] != null &&
            itemMap['artist']['id'] != null) {
          contentId = 'artist_${itemMap['artist']['id']}';
        } else if (itemMap['playlist'] != null &&
            itemMap['playlist']['id'] != null) {
          contentId = 'playlist_${itemMap['playlist']['id']}';
        }

        if (contentId != null && existingByContentId.containsKey(contentId)) {
          final existingItem = existingByContentId[contentId]!;
          itemMap['id'] = existingItem['id'];

          if (itemMap['playlist'] != null && existingItem['playlist'] != null) {
            itemMap['playlist']['id'] = existingItem['playlist']['id'];
          }
        } else {}

        itemsToMerge.add(itemMap);
      }

      if (UserService.loggedIn) {
        await _httpAdapter.patch('/library/merge_library', data: {
          'items': itemsToMerge,
        });
      }

      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        if (item.playlist == null) {
          continue;
        }
        final playlistId = itemsToMerge[i]['id'];
        await userTracksDB.addTracksToPlaylist(
          playlistId,
          item.playlist!.tracks,
        );
      }

      await _modelAdapter.putMany([
        ...itemsToMerge.map((e) {
          e['playlist']?['tracks'] = [];
          return e;
        }),
      ]);
    });
  }
}
