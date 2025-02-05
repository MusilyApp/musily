import 'package:musily/core/domain/datasources/base_datasource.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/features/_library_module/domain/datasources/library_datasource.dart';
import 'package:musily/features/album/data/models/album_model.dart';
import 'package:musily/features/album/domain/datasources/album_datasource.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';

class AlbumDatasourceImpl extends BaseDatasource implements AlbumDatasource {
  late final DownloaderController _downloaderController;
  late final LibraryDatasource _libraryDatasource;
  late final MusilyRepository _musilyRepository;

  AlbumDatasourceImpl({
    required DownloaderController downloaderController,
    required LibraryDatasource libraryDatasource,
    required MusilyRepository musilyRepository,
  }) {
    // Inicializa os controladores e repositórios
    _downloaderController = downloaderController;
    _libraryDatasource = libraryDatasource;
    _musilyRepository = musilyRepository;
  }

  @override
  Future<AlbumEntity?> getAlbum(String id) async {
    return exec<AlbumEntity?>(() async {
      // Tenta recuperar o álbum da biblioteca local
      final libraryItem = await _libraryDatasource.getLibraryItem(
        id,
      );
      if (libraryItem?.album != null) {
        // Converte o álbum da biblioteca para o formato offline usando o downloader
        final offlineLibraryItem = await AlbumModel.toOffline(
          libraryItem!.album!,
          _downloaderController,
        );
        return offlineLibraryItem;
      }
      // Se não encontrar na biblioteca, busca no repositório principal
      final album = await _musilyRepository.getAlbum(id);
      if (album == null) {
        return null;
      }
      // Converte o álbum obtido para o formato offline
      final offlineAlbum = await AlbumModel.toOffline(
        album,
        _downloaderController,
      );
      return offlineAlbum;
    }, onCatch: (error, stackTrace) async {
      // Log detalhado do erro para facilitar o diagnóstico
      print("Erro ao obter álbum (ID: $id): $error");
      rethrow;
    });
  }

  @override
  Future<List<AlbumEntity>> getAlbums(String query) async {
    return exec<List<AlbumEntity>>(() async {
      // Busca álbuns no repositório com base na consulta fornecida
      final albums = await _musilyRepository.searchAlbums(query);
      final offlineAlbums = <AlbumEntity>[];
      for (final album in albums) {
        // Converte cada álbum para o formato offline utilizando o downloader
        final offilneAlbum = await AlbumModel.toOffline(
          album,
          _downloaderController,
        );
        offlineAlbums.add(offilneAlbum);
      }
      return offlineAlbums;
    }, onCatch: (error, stackTrace) async {
      // Registra o erro ocorrido durante a busca de álbuns
      print("Erro ao buscar álbuns com query '$query': $error");
      rethrow;
    });
  }
}
