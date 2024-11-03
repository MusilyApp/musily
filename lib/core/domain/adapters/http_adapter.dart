// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class HttpAdapter {
  Future<HttpResponse> get(
    String url, {
    Map<String, dynamic>? params,
  });

  Future<HttpResponse> post(
    String url, {
    dynamic data,
    Map<String, dynamic> params,
  });

  Future<HttpResponse> patch(
    String url, {
    dynamic data,
    Map<String, dynamic> params,
  });

  Future<HttpResponse> put(
    String url, {
    dynamic data,
    Map<String, dynamic> params,
  });

  Future<HttpResponse> delete(
    String url, {
    dynamic data,
    Map<String, dynamic> params,
  });

  String baseUrl;

  HttpAdapter(this.baseUrl);
}

class HttpResponse {
  final int statusCode;
  final dynamic data;
  final Map<String, dynamic> headers;

  HttpResponse(this.statusCode, this.data, this.headers);

  @override
  String toString() =>
      'HttpResponse(statusCode: $statusCode, data: $data, headers: $headers)';
}
