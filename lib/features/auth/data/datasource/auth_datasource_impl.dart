import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musily/core/data/database/library_database.dart';
import 'package:musily/core/data/database/user_tracks_db.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/domain/adapters/http_adapter.dart';
import 'package:musily/core/domain/datasources/base_datasource.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/auth/data/models/user_model.dart';
import 'package:musily/features/auth/domain/datasource/auth_datasource.dart';
import 'package:musily/features/auth/domain/entities/user_entity.dart';

class AuthDatasourceImpl extends BaseDatasource implements AuthDatasource {
  // TODO create flutter secure storage abstraction
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final HttpAdapter _httpAdapter;
  late final LibraryController _libraryController;

  final db = LibraryDatabase();

  AuthDatasourceImpl({
    required HttpAdapter httpAdapter,
    required LibraryController libraryController,
  }) {
    _httpAdapter = httpAdapter;
    _libraryController = libraryController;
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    return exec<UserEntity>(
      () async {
        final response = await _httpAdapter.post(
          '/auth/login',
          data: {
            'email': email,
            'password': password,
          },
        );
        await _storeTokens(
          response.data['token'],
          response.data['refreshToken'],
        );
        final user = UserModel.fromMap(response.data['user']);
        await _storeUser(user);
        return user;
      },
    );
  }

  @override
  Future<UserEntity?> getAuthenticatedUser() async {
    return exec<UserEntity?>(
      () async {
        final user = await _secureStorage.read(key: 'user');
        if (user != null) {
          return UserModel.fromJson(user);
        }
        return null;
      },
    );
  }

  @override
  Future<UserEntity> createAccount(
    String name,
    String email,
    String password,
  ) async {
    return exec<UserEntity>(
      () async {
        final response = await _httpAdapter.post(
          '/auth/create_account',
          data: {
            'email': email,
            'password': password,
            'name': name,
          },
        );
        await _storeTokens(
          response.data['token'],
          response.data['refreshToken'],
        );
        final user = UserModel.fromMap(response.data['user']);
        await _storeUser(user);
        return user;
      },
    );
  }

  @override
  Future<void> logout() async {
    return exec<void>(
      () async {
        await _httpAdapter.post('/auth/logout');
        await _secureStorage.delete(key: 'token');
        await _secureStorage.delete(key: 'refreshToken');
        await _secureStorage.delete(key: 'user');
        await db.cleanCloudLibrary();
        await UserTracksDB().cleanCloudUserTracks();
        await UserService().initialize();
        _libraryController.updateData(_libraryController.data.copyWith(
          loadedFavoritesHash: [],
        ));
        await _libraryController.methods.getLibraryItems();
      },
      onCatch: () async {
        await _secureStorage.delete(key: 'token');
        await _secureStorage.delete(key: 'refreshToken');
        await _secureStorage.delete(key: 'user');
        await db.cleanCloudLibrary();
        await UserTracksDB().cleanCloudUserTracks();
        await UserService().initialize();
        _libraryController.updateData(_libraryController.data.copyWith(
          loadedFavoritesHash: [],
        ));
        await _libraryController.methods.getLibraryItems();
      },
    );
  }

  Future<void> _storeUser(UserEntity user) async {
    return exec<void>(
      () async {
        final userModel = UserModel.fromMap({
          'id': user.id,
          'name': user.name,
          'email': user.email,
        });
        await _secureStorage.write(
          key: 'user',
          value: userModel.toJson(),
        );
        await UserService().initialize();
        await _libraryController.methods.getLibraryItems();
      },
    );
  }

  Future<void> _storeTokens(String token, String? refreshToken) async {
    return exec<void>(
      () async {
        await _secureStorage.write(key: 'token', value: token);
        await _secureStorage.write(key: 'refreshToken', value: refreshToken);
      },
    );
  }
}
