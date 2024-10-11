import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class HttpClient {
  static final _instance = HttpClient._internal();

  factory HttpClient() => _instance;

  HttpClient._internal() {
    _dio = Dio(BaseOptions(baseUrl: 'http://localhost:4000'));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await _getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshToken = await _getRefreshToken();
          if (refreshToken != null) {
            try {
              final refreshedToken = await _refreshToken(refreshToken);
              if (refreshedToken != null) {
                await _setAccessToken(refreshedToken);

                final newOptions = Options(
                  headers: {
                    'Authorization': 'Bearer $refreshedToken',
                  },
                );
                final newRequest = await _dio.request(
                  error.requestOptions.path,
                  options: newOptions,
                );
                return handler.resolve(newRequest);
              }
            } catch (refreshError) {
              await _logout();
              return handler.reject(DioException(
                requestOptions: error.requestOptions,
                response: Response(
                  statusCode: 401,
                  requestOptions: error.requestOptions,
                ),
                error: 'Token inválido. Faça login novamente.',
              ));
            }
          }
        }
        return handler.next(error);
      },
    ));
  }

  final storage.FlutterSecureStorage _secureStorage =
      const storage.FlutterSecureStorage();
  late Dio _dio;

  Future<String?> _getAccessToken() async {
    return await _secureStorage.read(key: 'accessToken');
  }

  Future<String?> _getRefreshToken() async {
    return await _secureStorage.read(key: 'refreshToken');
  }

  Future<void> _setAccessToken(String accessToken) async {
    await _secureStorage.write(key: 'accessToken', value: accessToken);
  }

  Future<String?> _refreshToken(String refreshToken) async {
    final response = await _dio.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    if (response.statusCode == 200) {
      return response.data['accessToken'];
    } else {
      throw Exception('Falha ao atualizar token');
    }
  }

  Future<void> _logout() async {
    await _secureStorage.delete(key: 'accessToken');
    await _secureStorage.delete(key: 'refreshToken');
  }

  Dio get dio => _dio;
}
