import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class DownloadProgressMessage {
  final String trackHash;
  final double progress;
  final String status;
  final int? downloadedBytes;
  final int? totalBytes;
  final String? error;

  const DownloadProgressMessage({
    required this.trackHash,
    required this.progress,
    required this.status,
    this.downloadedBytes,
    this.totalBytes,
    this.error,
  });
}

class DownloadIsolateParams {
  final String url;
  final String savePath;
  final SendPort sendPort;
  final String trackHash;
  final int? maxConnections;
  final int? initialConnections;
  final int? minConnections;
  final int? timeoutMs;
  final int? maxRetriesPerPart;
  final bool? useIsolates;

  const DownloadIsolateParams({
    required this.url,
    required this.savePath,
    required this.sendPort,
    required this.trackHash,
    this.maxConnections,
    this.initialConnections,
    this.minConnections,
    this.timeoutMs,
    this.maxRetriesPerPart,
    this.useIsolates,
  });

  ParallelDownloader buildDownloader() {
    return ParallelDownloader(
      maxConnections: maxConnections ?? 16,
      initialConnections: initialConnections ?? 8,
      minConnections: minConnections ?? 2,
      timeoutMs: timeoutMs ?? 15000,
      maxRetriesPerPart: maxRetriesPerPart ?? 3,
      useIsolates: useIsolates ?? true,
    );
  }
}

class DownloadIsolate {
  static Future<void> downloadFileIsolate(DownloadIsolateParams params) async {
    final downloader = params.buildDownloader();
    int finalDownloadedBytes = 0;
    int finalTotalBytes = 0;
    try {
      await downloader.download(
        url: params.url,
        savePath: params.savePath,
        trackHash: params.trackHash,
        onProgress: (progress, downloadedBytes, totalBytes) {
          finalDownloadedBytes = downloadedBytes;
          finalTotalBytes = totalBytes;
          params.sendPort.send(
            DownloadProgressMessage(
              trackHash: params.trackHash,
              progress: progress,
              status: 'downloading',
              downloadedBytes: downloadedBytes,
              totalBytes: totalBytes,
            ),
          );
        },
      );

      params.sendPort.send(
        DownloadProgressMessage(
          trackHash: params.trackHash,
          progress: 1.0,
          status: 'completed',
          downloadedBytes: finalDownloadedBytes,
          totalBytes: finalTotalBytes,
        ),
      );
    } catch (e, s) {
      log(
        'Download failed for track ${params.trackHash}',
        error: e,
        stackTrace: s,
        name: 'ParallelDownloader',
      );
      try {
        final outFile = File(params.savePath);
        if (await outFile.exists()) await outFile.delete();
        final md5File = File('${params.savePath}.md5');
        if (await md5File.exists()) await md5File.delete();
      } catch (_) {}

      params.sendPort.send(
        DownloadProgressMessage(
          trackHash: params.trackHash,
          progress: 0.0,
          status: 'failed',
          error: e.toString(),
        ),
      );
    }
  }
}

class PartProgress {
  final int partIndex;
  final int downloaded;
  final int total;
  final String status;
  final String? error;

  PartProgress({
    required this.partIndex,
    required this.downloaded,
    required this.total,
    required this.status,
    this.error,
  });
}

class PartParams {
  final String url;
  final String savePath;
  final int partIndex;
  final int start;
  final int end;
  final SendPort sendPort;
  final int attempt;
  final int timeoutMs;

  PartParams({
    required this.url,
    required this.savePath,
    required this.partIndex,
    required this.start,
    required this.end,
    required this.sendPort,
    required this.attempt,
    required this.timeoutMs,
  });
}

Future<void> _partIsolateEntry(PartParams params) async {
  final partFilePath = "${params.savePath}.part${params.partIndex}";
  try {
    final client = http.Client();
    final request = http.Request('GET', Uri.parse(params.url));
    request.headers['Range'] = 'bytes=${params.start}-${params.end}';
    request.headers['User-Agent'] = 'ParallelDownloader/1.0';

    final streamed = await client
        .send(request)
        .timeout(Duration(milliseconds: params.timeoutMs));

    final expectedTotal = (params.end - params.start) + 1;
    final partFile = File(partFilePath);
    final sink = partFile.openWrite();
    int downloaded = 0;
    final completer = Completer<void>();

    final sub = streamed.stream.listen(
      (chunk) {
        sink.add(chunk);
        downloaded += chunk.length;
        params.sendPort.send(PartProgress(
          partIndex: params.partIndex,
          downloaded: downloaded,
          total: expectedTotal,
          status: 'downloading',
        ));
      },
      onDone: () async {
        try {
          await sink.close();
        } catch (_) {}
        client.close();

        if (!await partFile.exists()) {
          log(
            'Part file does not exist after download: ${partFile.path}',
            name: 'ParallelDownloader',
          );
          params.sendPort.send(PartProgress(
            partIndex: params.partIndex,
            downloaded: downloaded,
            total: expectedTotal,
            status: 'failed',
            error: 'Part file not created',
          ));
          completer.complete();
          return;
        }

        final actualLen = await partFile.length();
        if (actualLen != expectedTotal) {
          final error =
              'Part size mismatch: expected $expectedTotal got $actualLen';
          log(error, name: 'ParallelDownloader');
          params.sendPort.send(PartProgress(
            partIndex: params.partIndex,
            downloaded: actualLen,
            total: expectedTotal,
            status: 'failed',
            error: error,
          ));
        } else {
          params.sendPort.send(PartProgress(
            partIndex: params.partIndex,
            downloaded: actualLen,
            total: expectedTotal,
            status: 'completed',
          ));
        }
        completer.complete();
      },
      onError: (e, s) async {
        try {
          await sink.close();
        } catch (_) {}
        client.close();
        log(
          'Part ${params.partIndex} stream error',
          error: e,
          stackTrace: s,
          name: 'ParallelDownloader',
        );
        params.sendPort.send(PartProgress(
          partIndex: params.partIndex,
          downloaded: downloaded,
          total: expectedTotal,
          status: 'failed',
          error: e.toString(),
        ));
        completer.completeError(e);
      },
      cancelOnError: true,
    );

    await completer.future;
    await sub.cancel();
  } on TimeoutException catch (e, s) {
    log(
      'Part ${params.partIndex} timed out after ${params.timeoutMs}ms',
      error: e,
      stackTrace: s,
      name: 'ParallelDownloader',
    );
    try {
      final f = File(partFilePath);
      if (await f.exists()) await f.delete();
    } catch (_) {}
    params.sendPort.send(PartProgress(
      partIndex: params.partIndex,
      downloaded: 0,
      total: (params.end - params.start) + 1,
      status: 'failed',
      error: 'timeout ${params.timeoutMs}ms',
    ));
  } catch (e, s) {
    log(
      'Unhandled error in part ${params.partIndex}',
      error: e,
      stackTrace: s,
      name: 'ParallelDownloader',
    );
    try {
      final f = File(partFilePath);
      if (await f.exists()) await f.delete();
    } catch (_) {}
    params.sendPort.send(PartProgress(
      partIndex: params.partIndex,
      downloaded: 0,
      total: (params.end - params.start) + 1,
      status: 'failed',
      error: e.toString(),
    ));
  }
}

class ParallelDownloader {
  int maxConnections;
  final int minConnections;
  final int initialConnections;
  final int timeoutMs;
  final int maxRetriesPerPart;
  final bool useIsolates;

  ParallelDownloader({
    this.maxConnections = 16,
    this.initialConnections = 8,
    this.minConnections = 2,
    this.timeoutMs = 15000,
    this.maxRetriesPerPart = 3,
    this.useIsolates = true,
  }) {
    assert(initialConnections <= maxConnections,
        'initialConnections must be less than or equal to maxConnections');
  }

  Future<void> download({
    required String url,
    required String savePath,
    required String trackHash,
    required void Function(double progress, int downloadedBytes, int totalBytes)
        onProgress,
  }) async {
    final head = await http.head(Uri.parse(url));
    final total = int.tryParse(head.headers['content-length'] ?? '');
    if (total == null) {
      throw Exception('Server did not return Content-Length');
    }
    final acceptRanges = head.headers['accept-ranges'] ?? '';
    final supportsRange = acceptRanges.toLowerCase().contains('bytes');

    if (!supportsRange) {
      log(
        'Server does not support Range requests, falling back to single-stream download.',
        name: 'ParallelDownloader',
      );
      await _singleStreamDownload(
        url: url,
        savePath: savePath,
        trackHash: trackHash,
        total: total,
        onProgress: onProgress,
        timeoutMs: timeoutMs,
      );
      return;
    }

    int currentConnections = initialConnections;
    if (currentConnections > maxConnections) {
      currentConnections = maxConnections;
    }

    final partSize = (total / currentConnections).ceil();
    final parts = <Map<String, dynamic>>[];
    for (int i = 0; i < currentConnections; i++) {
      final start = i * partSize;
      final end =
          (i == currentConnections - 1) ? total - 1 : (start + partSize - 1);
      parts.add({
        'index': i,
        'start': start,
        'end': end,
        'status': 'pending',
        'downloaded': 0,
        'retries': 0,
      });
    }

    final partProgress = List<double>.filled(parts.length, 0.0);
    final partDownloaded = List<int>.filled(parts.length, 0);

    final rp = ReceivePort();
    final isolates = <int, Isolate>{};
    final completerAll = Completer<void>();
    int completedParts = 0;

    Future<void> dispatchPart(int partIndex) async {
      final p = parts[partIndex];
      p['status'] = 'downloading';
      p['retries'] = (p['retries'] as int);

      final params = PartParams(
        url: url,
        savePath: savePath,
        partIndex: partIndex,
        start: p['start'] as int,
        end: p['end'] as int,
        sendPort: rp.sendPort,
        attempt: p['retries'],
        timeoutMs: timeoutMs,
      );

      if (useIsolates) {
        try {
          final isolate = await Isolate.spawn(_partIsolateEntry, params);
          isolates[partIndex] = isolate;
        } catch (e, s) {
          log(
            'Failed to spawn isolate for part $partIndex, running inline.',
            error: e,
            stackTrace: s,
            name: 'ParallelDownloader',
          );
          await _partIsolateEntry(params);
        }
      } else {
        await _partIsolateEntry(params);
      }
    }

    rp.listen((dynamic msg) async {
      if (msg is PartProgress) {
        final idx = msg.partIndex;

        if (msg.status == 'downloading') {
          partDownloaded[idx] = msg.downloaded;
          partProgress[idx] = msg.total > 0 ? msg.downloaded / msg.total : 0.0;
          final global = partProgress.fold<double>(0.0, (a, b) => a + b) /
              partProgress.length;
          final totalDownloaded = partDownloaded.fold<int>(0, (a, b) => a + b);
          onProgress(global, totalDownloaded, total);
        } else if (msg.status == 'completed') {
          parts[idx]['status'] = 'completed';
          partDownloaded[idx] = msg.downloaded;
          partProgress[idx] = 1.0;
          completedParts++;

          final global = partProgress.fold<double>(0.0, (a, b) => a + b) /
              partProgress.length;
          final totalDownloaded = partDownloaded.fold<int>(0, (a, b) => a + b);
          onProgress(global, totalDownloaded, total);

          if (isolates.containsKey(idx)) {
            try {
              isolates[idx]?.kill(priority: Isolate.immediate);
            } catch (_) {}
            isolates.remove(idx);
          }
        } else if (msg.status == 'failed') {
          parts[idx]['status'] = 'failed';
          parts[idx]['retries'] = (parts[idx]['retries'] as int) + 1;
          log(
            'Part $idx failed (attempt ${parts[idx]['retries']}): ${msg.error}',
            name: 'ParallelDownloader',
          );

          if (isolates.containsKey(idx)) {
            try {
              isolates[idx]?.kill(priority: Isolate.immediate);
            } catch (_) {}
            isolates.remove(idx);
          }

          if (parts[idx]['retries'] <= maxRetriesPerPart) {
            Future.delayed(
                Duration(milliseconds: 200 * (parts[idx]['retries'] as int)),
                () => dispatchPart(idx));
          } else {
            completerAll
                .completeError(Exception('Part $idx failed after max retries'));
          }
        }
      }

      if (!completerAll.isCompleted && completedParts == parts.length) {
        try {
          final totalDownloaded = partDownloaded.fold<int>(0, (a, b) => a + b);
          await _mergeParts(savePath, parts.length,
              expectedSize: totalDownloaded);
          final file = File(savePath);
          final digest = await md5.bind(file.openRead()).single;
          await File("$savePath.md5").writeAsString(digest.toString());
          completerAll.complete();
        } catch (e, s) {
          log(
            'Error during file merge',
            error: e,
            stackTrace: s,
            name: 'ParallelDownloader',
          );
          completerAll.completeError(e);
        } finally {
          rp.close();
        }
      }
    });

    for (int i = 0; i < parts.length; i++) {
      dispatchPart(i);
    }

    try {
      await completerAll.future;
    } finally {
      rp.close();
      for (final iso in isolates.values) {
        try {
          iso.kill(priority: Isolate.immediate);
        } catch (_) {}
      }
    }
  }

  Future<void> _singleStreamDownload({
    required String url,
    required String savePath,
    required String trackHash,
    required int total,
    required void Function(double progress, int downloadedBytes, int totalBytes)
        onProgress,
    required int timeoutMs,
  }) async {
    final client = http.Client();
    final res = await client.send(http.Request('GET', Uri.parse(url)));
    final file = File(savePath);
    await file.create(recursive: true);
    final sink = file.openWrite();
    int downloaded = 0;
    final completer = Completer<void>();

    res.stream.listen(
      (chunk) {
        sink.add(chunk);
        downloaded += chunk.length;
        if (total > 0) {
          onProgress(downloaded / total, downloaded, total);
        }
      },
      onDone: () async {
        await sink.close();
        final digest = await md5.bind(file.openRead()).single;
        await File('$savePath.md5').writeAsString(digest.toString());
        onProgress(1.0, total, total);
        completer.complete();
      },
      onError: (e, s) {
        log(
          'Single-stream download failed',
          error: e,
          stackTrace: s,
          name: 'ParallelDownloader',
        );
        completer.completeError(e);
      },
      cancelOnError: true,
    );
    await completer.future;
  }

  Future<void> _mergeParts(
    String savePath,
    int partsCount, {
    required int expectedSize,
  }) async {
    final out = File(savePath).openWrite();
    for (int i = 0; i < partsCount; i++) {
      final partFile = File('$savePath.part$i');
      if (!await partFile.exists()) {
        throw Exception('Missing part file: ${partFile.path}');
      }
      await out.addStream(partFile.openRead());
      try {
        await partFile.delete();
      } catch (_) {}
    }
    await out.close();

    final mergedFile = File(savePath);
    if (!await mergedFile.exists()) {
      throw Exception('Merged file does not exist at $savePath');
    }

    final actualSize = await mergedFile.length();
    if (expectedSize > 0 && actualSize != expectedSize) {
      throw Exception(
          'Merged file size mismatch: expected $expectedSize got $actualSize');
    }
  }
}
