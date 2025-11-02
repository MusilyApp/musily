import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:musily/core/data/services/library_backup_service.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/presenter/extensions/date_time.dart';
import 'package:musily/features/_library_module/data/models/library_item_model.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_data.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:path/path.dart' as path;

class BackupProgressMessage {
  final double progress;
  final String message;
  final String? messageKey;
  final Map<String, String>? messageParams;
  final bool isComplete;
  final String? error;
  final String? filePath;
  final String? tempFilePath;

  BackupProgressMessage({
    required this.progress,
    required this.message,
    this.messageKey,
    this.messageParams,
    this.isComplete = false,
    this.error,
    this.filePath,
    this.tempFilePath,
  });
}

class BackupIsolateParams {
  final SendPort sendPort;
  final List<BackupOptions> options;
  final List<LibraryItemEntity> libraryItems;
  final List<DownloadingItem> downloads;
  final String tempDirectoryPath;
  final String downloadsDirectoryPath;
  final String applicationSupportDirectoryPath;

  BackupIsolateParams({
    required this.sendPort,
    required this.options,
    required this.libraryItems,
    required this.downloads,
    required this.tempDirectoryPath,
    required this.downloadsDirectoryPath,
    required this.applicationSupportDirectoryPath,
  });
}

class RestoreIsolateParams {
  final SendPort sendPort;
  final String backupFilePath;
  final List<String> existingDownloadHashes;
  final String? existingFavoritesId;
  final String applicationSupportDirectoryPath;

  RestoreIsolateParams({
    required this.sendPort,
    required this.backupFilePath,
    required this.existingDownloadHashes,
    this.existingFavoritesId,
    required this.applicationSupportDirectoryPath,
  });
}

class RestoreResultMessage {
  final List<LibraryItemEntity>? libraryItems;
  final List<TrackEntity>? tracks;
  final LibraryItemEntity? favoritesPlaylist;
  final bool hasLibrary;
  final bool hasDownloads;

  RestoreResultMessage({
    this.libraryItems,
    this.tracks,
    this.favoritesPlaylist,
    this.hasLibrary = false,
    this.hasDownloads = false,
  });
}

class LibraryBackupIsolate {
  static Future<void> backupLibraryIsolate(BackupIsolateParams params) async {
    try {
      params.sendPort.send(BackupProgressMessage(
        progress: 0.0,
        message: 'Initializing backup...',
        messageKey: 'initializingBackup',
      ));

      final tempDir = Directory(params.tempDirectoryPath);

      final downloadsDir = Directory(params.downloadsDirectoryPath);

      final backupDirectory = Directory(path.join(
        downloadsDir.path,
        'backups',
      ));

      if (!await backupDirectory.exists()) {
        await backupDirectory.create(recursive: true);
      }

      params.sendPort.send(BackupProgressMessage(
        progress: 0.1,
        message: 'Creating backup archive...',
        messageKey: 'creatingBackupArchive',
      ));

      final backupFilePath = path.join(
        backupDirectory.path,
        'backup-${DateTime.now().toFormattedDate()}.lybak',
      );

      final archive = Archive();
      double currentProgress = 0.1;

      if (params.options.contains(BackupOptions.downloads)) {
        params.sendPort.send(BackupProgressMessage(
          progress: 0.2,
          message: 'Backing up downloads metadata...',
          messageKey: 'backingUpDownloadsMetadata',
        ));

        final downloads = params.downloads.map((e) {
          final trackMap = TrackModel.toMap(e.track, withUrl: true);
          if (trackMap['url'] != null) {
            final url = trackMap['url'] as String;
            if (!url.startsWith('http://') && !url.startsWith('https://')) {
              final hash = e.track.hash;
              trackMap['url'] = 'local://$hash';
            }
          }
          return trackMap;
        });
        final downloadsJson = jsonEncode(downloads.toList());
        archive.addFile(ArchiveFile(
          'downloads.json',
          downloadsJson.length,
          utf8.encode(downloadsJson),
        ));

        currentProgress = 0.3;
        params.sendPort.send(BackupProgressMessage(
          progress: currentProgress,
          message: 'Backing up audio files...',
          messageKey: 'backingUpAudioFiles',
        ));

        final songsDirectory = Directory(
          path.join(
            params.applicationSupportDirectoryPath,
            'media',
            'audios',
          ),
        );

        if (await songsDirectory.exists()) {
          await _addDirectoryToArchive(
            songsDirectory,
            archive,
            'songs',
            params.sendPort,
            0.3,
            0.5,
          );
          currentProgress = 0.5;
        }
      }

      if (params.options.contains(BackupOptions.library)) {
        params.sendPort.send(BackupProgressMessage(
          progress: 0.6,
          message: 'Backing up library data...',
          messageKey: 'backingUpLibraryData',
        ));

        final library = params.libraryItems.map(
          (e) => LibraryItemModel.toMap(e),
        );
        final libraryJson = jsonEncode(library.toList());
        archive.addFile(ArchiveFile(
          'library.json',
          libraryJson.length,
          utf8.encode(libraryJson),
        ));
        currentProgress = 0.7;
      }

      params.sendPort.send(BackupProgressMessage(
        progress: 0.8,
        message: 'Writing backup file...',
        messageKey: 'writingBackupFile',
      ));

      final zipEncoder = ZipEncoder();
      final backupBytes = zipEncoder.encode(archive);

      String finalPath = backupFilePath;

      if (Platform.isAndroid) {
        final tempFilePath = path.join(
          tempDir.path,
          'backup-${DateTime.now().toFormattedDate()}.lybak',
        );
        final tempFile = File(tempFilePath);
        await tempFile.writeAsBytes(backupBytes!);

        params.sendPort.send(BackupProgressMessage(
          progress: 0.9,
          message: 'Saving to storage...',
          messageKey: 'savingToStorage',
          tempFilePath: tempFilePath,
        ));

        return;
      } else {
        final backupFile = File(backupFilePath);

        params.sendPort.send(BackupProgressMessage(
          progress: 0.9,
          message: 'Saving to ${backupDirectory.path}...',
          messageKey: 'savingToStorage',
        ));

        if (!await backupDirectory.exists()) {
          await backupDirectory.create(recursive: true);
        }

        await backupFile.writeAsBytes(backupBytes!);

        finalPath = backupFile.path;

        final fileExists = await backupFile.exists();

        if (!fileExists) {
          throw Exception('Failed to write backup file to ${backupFile.path}');
        }
      }

      params.sendPort.send(BackupProgressMessage(
        progress: 1.0,
        message: 'Saved to: ${path.basename(finalPath)}',
        messageKey: 'savedTo',
        messageParams: {'filename': path.basename(finalPath)},
        isComplete: true,
        filePath: finalPath,
      ));
    } catch (e) {
      params.sendPort.send(BackupProgressMessage(
        progress: 0.0,
        message: 'Backup failed',
        messageKey: 'backupFailed',
        isComplete: true,
        error: e.toString(),
      ));
    }
  }

  static Future<void> restoreLibraryIsolate(RestoreIsolateParams params) async {
    try {
      params.sendPort.send(BackupProgressMessage(
        progress: 0.0,
        message: 'Initializing restore...',
        messageKey: 'initializingRestore',
      ));

      final backupFile = File(params.backupFilePath);
      if (!await backupFile.exists()) {
        params.sendPort.send(BackupProgressMessage(
          progress: 0.0,
          message: 'Backup file not found',
          messageKey: 'backupFileNotFound',
          isComplete: true,
          error: 'Backup file does not exist',
        ));
        return;
      }

      params.sendPort.send(BackupProgressMessage(
        progress: 0.1,
        message: 'Reading backup file...',
        messageKey: 'readingBackupFile',
      ));

      final bytes = await backupFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      params.sendPort.send(BackupProgressMessage(
        progress: 0.3,
        message: 'Extracting library data...',
        messageKey: 'extractingLibraryData',
      ));

      List<LibraryItemEntity>? libraryItems;
      LibraryItemEntity? favoritesPlaylist;
      List<TrackEntity>? tracks;
      bool hasLibrary = false;
      bool hasDownloads = false;

      final libraryFile = archive.files
          .where((file) => file.name == 'library.json')
          .firstOrNull;

      if (libraryFile?.content is List<int>) {
        hasLibrary = true;
        final libraryJson = utf8.decode(libraryFile!.content as List<int>);
        final items = (jsonDecode(libraryJson) as List)
            .map((item) => LibraryItemModel.fromMap(item))
            .toList();

        final backupFavoritesPlaylist =
            items.where((e) => e.id.startsWith('favorites')).firstOrNull;

        if (backupFavoritesPlaylist != null) {
          if (params.existingFavoritesId != null) {
            favoritesPlaylist = backupFavoritesPlaylist;
            items.removeWhere((e) => e.id.startsWith('favorites'));
          } else {
            backupFavoritesPlaylist.id = UserService.favoritesId;
            backupFavoritesPlaylist.playlist?.id = UserService.favoritesId;
          }
        }

        libraryItems = items;
      }

      params.sendPort.send(BackupProgressMessage(
        progress: 0.5,
        message: 'Extracting downloads data...',
        messageKey: 'extractingDownloadsData',
      ));

      final downloadsFile = archive.files
          .where((file) => file.name == 'downloads.json')
          .firstOrNull;

      if (downloadsFile != null && downloadsFile.content is List<int>) {
        hasDownloads = true;
        final downloadsJson = utf8.decode(downloadsFile.content as List<int>);
        final allTracks = (jsonDecode(downloadsJson) as List).map((trackMap) {
          final url = trackMap['url'] as String?;
          if (url != null) {
            if (url.startsWith('local://')) {
              final hash = url.replaceFirst('local://', '');
              final reconstructedPath = path.join(
                params.applicationSupportDirectoryPath,
                'media',
                'audios',
                hash,
              );
              trackMap['url'] = reconstructedPath;
            } else if (url.startsWith('http://') ||
                url.startsWith('https://')) {
            } else if (!path.isAbsolute(url)) {
              final pathParts = url.split('/');
              String? hash;
              if (pathParts.contains('audios')) {
                final audiosIndex = pathParts.indexOf('audios');
                if (audiosIndex < pathParts.length - 1) {
                  hash = pathParts[audiosIndex + 1];
                }
              } else {
                hash = pathParts.isNotEmpty ? pathParts.last : null;
              }

              final hashToUse = hash ?? trackMap['hash'] as String;
              final reconstructedPath = path.join(
                params.applicationSupportDirectoryPath,
                'media',
                'audios',
                hashToUse,
              );
              trackMap['url'] = reconstructedPath;
            } else {
              final hash = trackMap['hash'] as String;
              final reconstructedPath = path.join(
                params.applicationSupportDirectoryPath,
                'media',
                'audios',
                hash,
              );
              trackMap['url'] = reconstructedPath;
            }
          }
          return TrackModel.fromMap(trackMap);
        }).toList();

        tracks = allTracks
            .where(
              (e) => !params.existingDownloadHashes.contains(e.hash),
            )
            .toList();
      }

      params.sendPort.send(BackupProgressMessage(
        progress: 0.7,
        message: 'Extracting audio files...',
        messageKey: 'extractingAudioFiles',
      ));

      final songsDirectory = archive.files.where(
        (file) => file.name.startsWith('songs/'),
      );

      if (songsDirectory.isNotEmpty) {
        final songsDir = Directory(path.join(
          params.applicationSupportDirectoryPath,
          'media',
          'audios',
        ));

        if (!await songsDir.exists()) {
          await songsDir.create(recursive: true);
        }

        int filesProcessed = 0;
        final totalFiles = songsDirectory.where((f) => f.isFile).length;

        for (final file in songsDirectory) {
          if (file.isFile) {
            final filePath =
                path.join(songsDir.path, file.name.replaceFirst('songs/', ''));
            final restoredFile = File(filePath);
            await restoredFile.create(recursive: true);
            await restoredFile.writeAsBytes(file.content as List<int>);

            filesProcessed++;
            final progress = 0.7 + (0.2 * filesProcessed / totalFiles);
            params.sendPort.send(BackupProgressMessage(
              progress: progress,
              message: 'Restoring audio files ($filesProcessed/$totalFiles)...',
            ));
          }
        }
      }

      params.sendPort.send(BackupProgressMessage(
        progress: 0.95,
        message: 'Finalizing restore...',
        messageKey: 'finalizingRestore',
      ));

      params.sendPort.send(RestoreResultMessage(
        libraryItems: libraryItems,
        tracks: tracks,
        favoritesPlaylist: favoritesPlaylist,
        hasLibrary: hasLibrary,
        hasDownloads: hasDownloads,
      ));

      params.sendPort.send(BackupProgressMessage(
        progress: 1.0,
        message: 'Restore completed successfully!',
        messageKey: 'restoreCompletedSuccessfully',
        isComplete: true,
      ));
    } catch (e) {
      params.sendPort.send(BackupProgressMessage(
        progress: 0.0,
        message: 'Restore failed',
        messageKey: 'restoreFailed',
        isComplete: true,
        error: e.toString(),
      ));
    }
  }

  static Future<void> _addDirectoryToArchive(
    Directory directory,
    Archive archive,
    String rootPath,
    SendPort sendPort,
    double startProgress,
    double endProgress,
  ) async {
    final files = directory.listSync(recursive: true);
    final filesList = files.whereType<File>().toList();
    int filesProcessed = 0;

    for (final file in filesList) {
      final relativePath = path.relative(file.path, from: directory.path);
      final archivePath =
          path.join(rootPath, relativePath).replaceAll('\\', '/');
      final fileBytes = await file.readAsBytes();
      archive.addFile(ArchiveFile(
        archivePath,
        fileBytes.length,
        fileBytes,
      ));

      filesProcessed++;
      final progress = startProgress +
          ((endProgress - startProgress) * filesProcessed / filesList.length);

      if (filesProcessed % 10 == 0 || filesProcessed == filesList.length) {
        sendPort.send(BackupProgressMessage(
          progress: progress,
          message:
              'Processing audio files ($filesProcessed/${filesList.length})...',
        ));
      }
    }
  }
}
