import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musily/core/domain/adapters/http_adapter.dart';
import 'package:musily/core/domain/errors/musily_error.dart';

class HttpAdapterImpl extends HttpAdapter {
  final Dio _dio = Dio();

  HttpAdapterImpl()
      // TODO Set Api Url
      : super('') {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.add(
      InterceptorsWrapper(
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
                    headers: {'Authorization': 'Bearer $refreshedToken'},
                  );
                  final newRequest = await _dio.request(
                    error.requestOptions.path,
                    options: newOptions,
                  );
                  return handler.resolve(newRequest);
                }
              } catch (refreshError) {
                await _logout();
                return handler.reject(
                  DioException(
                    requestOptions: error.requestOptions,
                    response: Response(
                      statusCode: 401,
                      requestOptions: error.requestOptions,
                    ),
                    error: 'Token inválido. Faça login novamente.',
                  ),
                );
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
  @override
  Future<HttpResponse> get(String url, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(url, queryParameters: params);
      return HttpResponse(
        response.statusCode ?? 500,
        response.data,
        response.headers.map,
      );
    } catch (e, stackTracke) {
      throw _handleError(e, stackTracke);
    }
  }

  @override
  Future<HttpResponse> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: params,
      );
      return HttpResponse(
        response.statusCode ?? 500,
        response.data,
        response.headers.map,
      );
    } catch (e, stackTracke) {
      throw _handleError(e, stackTracke);
    }
  }

  @override
  Future<HttpResponse> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dio.patch(
        url,
        data: data,
        queryParameters: params,
      );
      return HttpResponse(
        response.statusCode ?? 500,
        response.data,
        response.headers.map,
      );
    } catch (e, stackTracke) {
      throw _handleError(e, stackTracke);
    }
  }

  @override
  Future<HttpResponse> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dio.put(url, data: data, queryParameters: params);
      return HttpResponse(
        response.statusCode ?? 500,
        response.data,
        response.headers.map,
      );
    } catch (e, stackTracke) {
      throw _handleError(e, stackTracke);
    }
  }

  @override
  Future<HttpResponse> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: params,
      );
      return HttpResponse(
        response.statusCode ?? 500,
        response.data,
        response.headers.map,
      );
    } catch (e, stackTracke) {
      throw _handleError(e, stackTracke);
    }
  }

  HttpResponse _handleError(dynamic error, StackTrace stackTracke) {
    if (error is DioException) {
      // log('$error - $stackTracke');
      return HttpResponse(
        error.response?.statusCode ?? 500,
        error.response?.data ?? {},
        error.response?.headers.map ?? {},
      );
    }
    return HttpResponse(500, {
      'error': 'app.internal_error',
      'message': 'internal_error',
    }, {});
  }

  // final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> _getAccessToken() async {
    // final token = await _secureStorage.read(key: 'token');
    // return token;
    return null;
  }

  Future<String?> _getRefreshToken() async {
    // return await _secureStorage.read(key: 'refreshToken');
    return null;
  }

  Future<void> _setAccessToken(String accessToken) async {
    // await _secureStorage.write(key: 'accessToken', value: accessToken);
  }

  Future<String?> _refreshToken(String refreshToken) async {
    final response = await _dio.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    if (response.statusCode == 200) {
      return response.data['accessToken'];
    } else {
      throw MusilyError(
        code: 403,
        id: 'refresh_token_failed',
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<void> _logout() async {
    // await _secureStorage.delete(key: 'accessToken');
    // await _secureStorage.delete(key: 'refreshToken');
  }
}
