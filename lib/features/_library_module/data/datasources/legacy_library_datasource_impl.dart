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
    // Inicializa os adaptadores de HTTP e de banco de dados.
    _httpAdapter = httpAdapter;
    _modelAdapter = modelAdapter;
  }

  @override
  Future<LibraryItemEntity> addAlbumToLibrary(AlbumEntity album) {
    return exec<LibraryItemEntity>(() async {
      // Verifica se o usuário está logado para decidir entre operação remota ou anônima.
      if (UserService.loggedIn) {
        final response = await _httpAdapter.post(
          '/library/add_album_to_library',
          data: AlbumModel.toMap(
            album,
          ),
        );
        await _modelAdapter.put(response.data);
        final libraryItem = LibraryItemModel.fromMap(response.data);
        return libraryItem;
      }
      // Operação para usuário não logado.
      final anonymousItem = LibraryItemModel.newInstance(
        album: album,
      );
      await _modelAdapter.put(LibraryItemModel.toMap(anonymousItem));
      return anonymousItem;
    }, onCatch: (error, stackTrace) async {
      // Loga o erro e relança exceção se necessário
      print("Erro ao adicionar álbum à biblioteca: $error");
      rethrow;
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
      final anonymousItem = LibraryItemModel.newInstance(
        artist: artist,
      );
      await _modelAdapter.put(LibraryItemModel.toMap(anonymousItem));
      return anonymousItem;
    }, onCatch: (error, stackTrace) async {
      print("Erro ao adicionar artista à biblioteca: $error");
      rethrow;
    });
  }

  @override
  Future<void> addTracksToPlaylist(
    String playlistId,
    List<TrackEntity> tracks,
  ) {
    return exec<void>(() async {
      // Se usuário estiver logado, realiza a operação via API remota.
      if (UserService.loggedIn) {
        await _httpAdapter.post(
          '/library/add_tracks_to_playlist',
          data: {
            'playlistId': playlistId,
            'tracks': [
              ...tracks.map(
                (e) => TrackModel.toMap(e),
              ),
            ],
          },
        );
      }
      // Atualiza a playlist armazenada localmente.
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
    }, onCatch: (error, stackTrace) async {
      print("Erro ao adicionar faixas à playlist (ID: $playlistId): $error");
      rethrow;
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
            LibraryItemModel.newInstance(
              playlist: playlist,
            ),
          ),
        );
        return playlist;
      }
      // Para usuários não logados, gera um ID novo e cria playlist anônima.
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
    }, onCatch: (error, stackTrace) async {
      print("Erro ao criar playlist: $error");
      rethrow;
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
    }, onCatch: (error, stackTrace) async {
      print("Erro ao deletar playlist (ID: $playlistId): $error");
      rethrow;
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
        // Trata playlist: remove as faixas e adiciona via banco de dados.
        if (libraryItem.playlist != null) {
          final tracks = libraryItem.playlist!.tracks;
          response.data['playlist']['tracks'] = [];
          await userTracksDB.addTracksToPlaylist(itemId, tracks);
        }
        // Trata artista: atualiza dados do artista se disponível.
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
    } catch (error, stackTrace) {
      print("Erro ao obter item da biblioteca (ID: $itemId): $error");
      // Em caso de erro, tenta recuperar o item de forma offline.
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
    return exec<List<LibraryItemEntity>>(
      () async {
        if (UserService.loggedIn) {
          final response = await _httpAdapter.get('/library/get_library_items');
          final libraryItems = <LibraryItemEntity>[
            ...response.data.map(
              (item) => LibraryItemModel.fromMap(item),
            ),
          ];
          return libraryItems;
        }
        final anonymousLibrary = await _modelAdapter.getAll();
        return [
          ...anonymousLibrary.map(
            (e) => LibraryItemModel.fromMap(e),
          )
        ];
      },
      onCatch: () async {
        print("Erro ao recuperar itens da biblioteca, tentando modo offline.");
        final library = await _modelAdapter.getAll();
        return [
          ...library.map(
            (e) => LibraryItemModel.fromMap(e),
          ),
        ];
      },
    );
  }

  @override
  Future<void> removeAlbumFromLibrary(String albumId) {
    return exec(() async {
      if (UserService.loggedIn) {
        await _httpAdapter
            .delete('/library/remove_album_from_library/$albumId');
      }
      await _modelAdapter.findByIdAndDelete(albumId);
    }, onCatch: (error, stackTrace) async {
      print("Erro ao remover álbum da biblioteca (ID: $albumId): $error");
      rethrow;
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
    }, onCatch: (error, stackTrace) async {
      print("Erro ao remover artista da biblioteca (ID: $artistId): $error");
      rethrow;
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
          data: {
            'tracks': trackIds,
          },
        );
      }
      final currentPlaylist = await _modelAdapter.findById(playlistId);
      if (currentPlaylist != null) {
        await userTracksDB.removeTracksFromPlaylist(playlistId, trackIds);
        final trackCount = await userTracksDB.getTrackCount(playlistId);
        currentPlaylist['playlist']?['trackCount'] = trackCount;
        await _modelAdapter.put(currentPlaylist);
      }
    }, onCatch: (error, stackTrace) async {
      print("Erro ao remover faixas da playlist (ID: $playlistId): $error");
      rethrow;
    });
  }

  @override
  Future<PlaylistEntity?> updatePlaylist(
    UpdatePlaylistDto data,
  ) {
    return exec<PlaylistEntity?>(() async {
      Map<String, dynamic>? responseData;
      if (UserService.loggedIn) {
        final response = await _httpAdapter.put(
          '/library/playlists/${data.id}',
          data: data.toMap(),
        );
        responseData = response.data;
      }
      final currentPlaylist = await _modelAdapter.findById(data.id);
      currentPlaylist?['title'] = data.title;
      if (currentPlaylist != null) {
        await _modelAdapter.put(currentPlaylist);
        return PlaylistModel.fromMap(responseData ?? currentPlaylist);
      }
      return null;
    }, onCatch: (error, stackTrace) async {
      print("Erro ao atualizar a playlist (ID: ${data.id}): $error");
      return null;
    });
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
    }, onCatch: (error, stackTrace) async {
      print("Erro ao atualizar item da biblioteca (ID: ${item.id}): $error");
      rethrow;
    });
  }

  @override
  Future<void> mergeLibrary(List<LibraryItemEntity> items) {
    return exec(() async {
      final itemsMapList = [
        ...items.map((e) => LibraryItemModel.toMap(e)),
      ];
      if (UserService.loggedIn) {
        await _httpAdapter.patch(
          '/library/merge_library',
          data: itemsMapList,
        );
      }
      for (final item in items) {
        if (item.playlist == null) {
          continue;
        }
        await userTracksDB.addTracksToPlaylist(
          item.id,
          item.playlist!.tracks,
        );
      }
      await _modelAdapter.putMany([
        ...itemsMapList.map((e) {
          e['playlist']?['tracks'] = [];
          return e;
        })
      ]);
    }, onCatch: (error, stackTrace) async {
      print("Erro ao mesclar biblioteca: $error");
      rethrow;
    });
  }
}
