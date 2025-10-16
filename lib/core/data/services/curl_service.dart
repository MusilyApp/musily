import 'dart:io';
import 'package:flutter_curl/flutter_curl.dart';

class CurlService {
  final Client _client = Client();
  final int maxRedirects;

  CurlService({this.maxRedirects = 5});

  Future<void> init() async {
    if (_isMobile) {
      await _client.init();
    }
  }

  Future<String> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    if (_isMobile) {
      return _getMobile(url, headers);
    } else if (_isDesktop) {
      return _getDesktop(url, headers);
    } else {
      throw UnsupportedError('CurlService does not support this platform');
    }
  }

  bool get _isMobile => Platform.isAndroid || Platform.isIOS;
  bool get _isDesktop =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  Future<String> _getMobile(String url, Map<String, String>? headers) async {
    String currentUrl = url;
    int redirectCount = 0;

    while (redirectCount <= maxRedirects) {
      final response = await _client.send(Request(
        method: 'GET',
        url: currentUrl,
        headers: headers ?? {},
      ));

      final statusCode = response.statusCode;
      if ([301, 302, 303, 307, 308].contains(statusCode)) {
        final location =
            response.headers['location'] ?? response.headers['Location'];
        if (location == null) throw Exception('Redirect without Location');

        if (location.startsWith('/')) {
          final uri = Uri.parse(currentUrl);
          currentUrl = '${uri.scheme}://${uri.host}$location';
        } else {
          currentUrl = location;
        }

        redirectCount++;
        continue;
      }

      return response.text();
    }

    throw Exception('Too many redirects ($maxRedirects)');
  }

  Future<String> _getDesktop(String url, Map<String, String>? headers) async {
    final args = <String>[
      '-L',
      '-s',
      url,
      if (headers != null)
        for (var entry in headers.entries) ...[
          '-H',
          '${entry.key}: ${entry.value}'
        ],
    ];

    final result = await Process.run('curl', args);

    if (result.exitCode != 0) {
      throw ProcessException(
          'curl', args, result.stderr.toString(), result.exitCode);
    }

    return result.stdout.toString();
  }
}
