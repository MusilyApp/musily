import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musily_repository/core/data/models/musily_user.dart';
import 'package:musily_repository/core/utils/http_client.dart';
import 'package:musily_repository/features/auth/data/errors/signup_error.dart';
import 'package:musily_repository/features/auth/data/errors/login_error.dart';

class AuthDatasource {
  final HttpClient _httpClient = HttpClient();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<MusilyUser> login(String email, String password) async {
    try {
      final response = await _httpClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      await _storeTokens(
        response.data['token'],
        response.data['refreshToken'],
      );
      final user = MusilyUser.fromMap(response.data['user']);
      await _storeUser(user);
      return user;
    } catch (e) {
      throw LoginError();
    }
  }

  Future<MusilyUser?> getAuthenticatedUser() async {
    try {
      final user = await _secureStorage.read(key: 'user');
      if (user != null) {
        return MusilyUser.fromJson(user);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<MusilyUser> createAccount(
      String name, String email, String password) async {
    try {
      final response = await _httpClient.dio.post(
        '/auth/signup',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      if (response.statusCode == 201) {
        await _storeTokens(
          response.data['token'],
          response.data['refreshToken'],
        );
        final user = MusilyUser.fromMap(response.data['user']);
        await _storeUser(user);
        return user;
      } else {
        throw SignupError();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _httpClient.dio.post('/auth/logout');
    } finally {
      await _secureStorage.delete(key: 'token');
      await _secureStorage.delete(key: 'refreshToken');
      await _secureStorage.delete(key: 'user');
    }
  }

  Future<void> _storeUser(MusilyUser user) async {
    await _secureStorage.write(
      key: 'user',
      value: user.toJson(),
    );
  }

  Future<void> _storeTokens(String token, String? refreshToken) async {
    await _secureStorage.write(key: 'token', value: token);
    await _secureStorage.write(key: 'refreshToken', value: refreshToken);
  }
}
