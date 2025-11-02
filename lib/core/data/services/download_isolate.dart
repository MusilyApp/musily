import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class DownloadIsolateParams {
  final String url;
  final String savePath;
  final SendPort sendPort;
  final String trackHash;

  DownloadIsolateParams({
    required this.url,
    required this.savePath,
    required this.sendPort,
    required this.trackHash,
  });
}

class DownloadProgressMessage {
  final String trackHash;
  final double progress;
  final String status;
  final String? error;

  DownloadProgressMessage({
    required this.trackHash,
    required this.progress,
    required this.status,
    this.error,
  });
}

class DownloadIsolate {
  static Future<void> downloadFileIsolate(DownloadIsolateParams params) async {
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(minutes: 5),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Connection': 'keep-alive',
        },
      ));

      // Send initial downloading status
      params.sendPort.send(DownloadProgressMessage(
        trackHash: params.trackHash,
        progress: 0.0,
        status: 'downloading',
      ));

      int lastProgressUpdate = DateTime.now().millisecondsSinceEpoch;

      await dio.download(
        params.url,
        params.savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final now = DateTime.now().millisecondsSinceEpoch;
            // Only send progress updates every 500ms to reduce overhead
            if (now - lastProgressUpdate > 500 || received == total) {
              final progress = received / total;
              params.sendPort.send(DownloadProgressMessage(
                trackHash: params.trackHash,
                progress: progress,
                status: 'downloading',
              ));
              lastProgressUpdate = now;
            }
          }
        },
        deleteOnError: true,
      );

      // Save MD5 hash
      final file = File(params.savePath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        final digest = md5.convert(bytes);
        final md5Hash = digest.toString();
        final md5File = File('${params.savePath}.md5');
        await md5File.writeAsString(md5Hash);
      }

      // Send completion status
      params.sendPort.send(DownloadProgressMessage(
        trackHash: params.trackHash,
        progress: 1.0,
        status: 'completed',
      ));
    } catch (e) {
      // Send error status
      params.sendPort.send(DownloadProgressMessage(
        trackHash: params.trackHash,
        progress: 0.0,
        status: 'failed',
        error: e.toString(),
      ));
    }
  }
}
