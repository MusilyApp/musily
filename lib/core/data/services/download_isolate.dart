import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

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
      final client = http.Client();

      final request = http.Request('GET', Uri.parse(params.url));
      final response = await client.send(request);

      final total = response.contentLength ?? -1;

      params.sendPort.send(
        DownloadProgressMessage(
          trackHash: params.trackHash,
          progress: 0.0,
          status: 'downloading',
        ),
      );

      final file = File(params.savePath);
      await file.create(recursive: true);
      final sink = file.openWrite();

      const chunkSize = 64 * 1024;
      int downloaded = 0;
      int lastProgress = DateTime.now().millisecondsSinceEpoch;

      final stream = response.stream;

      while (true) {
        final chunk = await stream.firstWhere(
          (data) => data.isNotEmpty,
          orElse: () => Uint8List(0),
        );

        if (chunk.isEmpty) break;

        await sink.addStream(Stream.value(chunk));

        downloaded += chunk.length;

        final now = DateTime.now().millisecondsSinceEpoch;
        if (total > 0 && (now - lastProgress) >= 500) {
          params.sendPort.send(
            DownloadProgressMessage(
              trackHash: params.trackHash,
              progress: downloaded / total,
              status: 'downloading',
            ),
          );
          lastProgress = now;
        }

        if (chunk.length < chunkSize) {
          break;
        }
      }

      await sink.close();
      client.close();

      final md5Hash = await md5.bind(file.openRead()).single;
      await File("${params.savePath}.md5").writeAsString(md5Hash.toString());

      params.sendPort.send(
        DownloadProgressMessage(
          trackHash: params.trackHash,
          progress: 1.0,
          status: 'completed',
        ),
      );
    } catch (e) {
      params.sendPort.send(
        DownloadProgressMessage(
          trackHash: params.trackHash,
          progress: 0.0,
          status: "failed",
          error: e.toString(),
        ),
      );
    }
  }
}
