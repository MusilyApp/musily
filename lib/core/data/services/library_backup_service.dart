import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
// import 'package:audiotags/audiotags.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/domain/errors/musily_error.dart';
import 'package:musily/core/presenter/extensions/date_time.dart';
import 'package:musily/features/_library_module/data/models/library_item_model.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_data.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

enum BackupOptions { library, downloads }

class BackupService {
  final DownloaderController downloaderController;
  final LibraryController libraryController;

  BackupService({
    required this.downloaderController,
    required this.libraryController,
  });

  Future<void> backupLibrary(List<BackupOptions> options) async {
    final tempDir = await getTemporaryDirectory();

    // Get the backup directory
    final backupDirectory = Directory(path.join(
      (await _getDownloadsDirectory()).path,
      'backups',
    ));
    if (!await backupDirectory.exists()) {
      await backupDirectory.create(recursive: true);
    }

    final backupFilePath = path.join(
      backupDirectory.path,
      'backup-${DateTime.now().toFormattedDate()}.lybak',
    );

    final archive = Archive();

    if (options.contains(BackupOptions.downloads)) {
      // Add downloads.json to the archive
      final downloads = downloaderController.data.queue.map(
        (e) => TrackModel.toMap(e.track, withUrl: true),
      );
      final downloadsJson = jsonEncode(downloads.toList());
      archive.addFile(ArchiveFile(
        'downloads.json',
        downloadsJson.length,
        utf8.encode(downloadsJson),
      ));

      // Add songs directory to the archive
      final songsDirectory = Directory(
        path.join(
          (await getApplicationSupportDirectory()).path,
          'media',
          'audios',
        ),
      );
      if (await songsDirectory.exists()) {
        _addDirectoryToArchive(songsDirectory, archive, 'songs');
      }
    }

    if (options.contains(BackupOptions.library)) {
      if (libraryController.data.items.isEmpty) {
        await libraryController.methods.getLibraryItems();
      }

      for (final item in libraryController.data.items) {
        if (item.playlist != null && item.playlist!.tracks.isEmpty) {
          await libraryController.methods.getLibraryItem(item.id);
        }
        if (item.album != null && item.album!.tracks.isEmpty) {
          await libraryController.methods.getLibraryItem(item.id);
        }
      }

      final library = libraryController.data.items.map(
        (e) => LibraryItemModel.toMap(e),
      );
      final libraryJson = jsonEncode(library.toList());
      archive.addFile(ArchiveFile(
        'library.json',
        libraryJson.length,
        utf8.encode(libraryJson),
      ));
    }

    // Write the archive to a file
    final zipEncoder = ZipEncoder();
    final backupFile = File(backupFilePath);
    final backupBytes = zipEncoder.encode(archive);
    if (Platform.isAndroid) {
      final tempFile = File(path.join(
        tempDir.path,
        'backup-${DateTime.now().toFormattedDate()}.lybak',
      ));
      await tempFile.writeAsBytes(backupBytes!);
      await mediaStorePlugin.saveFile(
        dirName: DirName.download,
        dirType: DirType.download,
        tempFilePath: path.join(
          tempDir.path,
          'backup-${DateTime.now().toFormattedDate()}.lybak',
        ),
        relativePath: path.join('Musily', 'backups'),
      );
    } else {
      await backupFile.writeAsBytes(backupBytes!);
    }
  }

  Future<void> saveTrackToDownloads(TrackEntity track) async {
    final downloadsDir = await _getDownloadsDirectory();

    final tempDir = await getTemporaryDirectory();
    final appDir = await getApplicationSupportDirectory();

    final trackDir = path.join(
      appDir.path,
      'media',
      'audios',
      track.hash,
    );
    final tempTrackDir = path.join(
      tempDir.path,
      '${track.title} (${track.artist.name}).mp3',
    );

    final trackFile = File(trackDir);
    final tempTrackFile = File(tempTrackDir);
    // late final Uint8List? thumbBytes;

    // if (track.highResImg != null) {
    //   thumbBytes = await fetchImageBytes(track.highResImg!);
    // } else {
    //   thumbBytes = null;
    // }

    final file = File(
      path.join(
        downloadsDir.path,
        'songs',
        '${track.title} (${track.artist.name}).mp3',
      ),
    );

    // final tag = Tag(
    //   title: track.title,
    //   trackArtist: track.artist.name,
    //   album: track.album.title,
    //   albumArtist: track.artist.name,
    //   pictures: [
    //     if (thumbBytes != null)
    //       Picture(
    //         bytes: thumbBytes,
    //         mimeType: MimeType.jpeg,
    //         pictureType: PictureType.coverFront,
    //       )
    //   ],
    // );

    if (Platform.isAndroid) {
      await tempTrackFile.writeAsBytes(await trackFile.readAsBytes());

      await mediaStorePlugin.saveFile(
        dirName: DirName.download,
        dirType: DirType.download,
        tempFilePath: tempTrackDir,
        relativePath: path.join('Musily', 'songs'),
      );
    } else {
      final directory = Directory(
        path.join(downloadsDir.path, 'songs'),
      );
      await directory.create(recursive: true);
      await file.writeAsBytes(await trackFile.readAsBytes());
    }

    // await AudioTags.write(file.path, tag);
  }

  Future<Uint8List?> fetchImageBytes(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> restoreLibraryBackup(File backupFile) async {
    if (!await backupFile.exists()) {
      throw MusilyError(
        code: 401,
        id: 'backup_file_does_not_exist',
      );
    }

    try {
      // Read and decode the backup file
      final bytes = await backupFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // Extract library.json if present
      final libraryFile = archive.files
          .where(
            (file) => file.name == 'library.json',
          )
          .firstOrNull;

      if (libraryFile?.content is List<int>) {
        final libraryJson = utf8.decode(libraryFile!.content as List<int>);
        final libraryItems = (jsonDecode(libraryJson) as List)
            .map((item) => LibraryItemModel.fromMap(item))
            .toList();

        // Restore library data
        final backupFavoritesPlaylist =
            libraryItems.where((e) => e.id.startsWith('favorites')).firstOrNull;
        final libraryFavoritesPalylist = libraryController.data.items
            .where((e) => e.id.startsWith('favorites'))
            .firstOrNull;
        if (libraryFavoritesPalylist != null) {
          await libraryController.methods.addTracksToPlaylist(
            UserService.favoritesId,
            backupFavoritesPlaylist?.playlist?.tracks ?? [],
          );
          libraryItems.removeWhere((e) => e.id.startsWith('favorites'));
        } else if (backupFavoritesPlaylist != null) {
          backupFavoritesPlaylist.id = UserService.favoritesId;
          backupFavoritesPlaylist.playlist?.id = UserService.favoritesId;
        }
        await libraryController.methods.mergeLibrary(libraryItems);
      }

      // Extract downloads.json if present
      final downloadsFile = archive.files
          .where((file) => file.name == 'downloads.json')
          .firstOrNull;

      if (downloadsFile != null && downloadsFile.content is List<int>) {
        final downloadsJson = utf8.decode(downloadsFile.content as List<int>);
        final tracks = (jsonDecode(downloadsJson) as List)
            .map((track) => TrackModel.fromMap(track))
            .toList();

        // Restore downloaded tracks
        final tracksHashs = downloaderController.data.queue.map(
          (e) => e.track.hash,
        );
        final filteredDownloads = tracks.where(
          (e) => !tracksHashs.contains(
            e.hash,
          ),
        );
        downloaderController.data.queue.addAll(
          filteredDownloads.map(
            (e) => DownloadingItem(
              track: e,
              progress: 1,
              status: DownloadStatus.completed,
            ),
          ),
        );
        await downloaderController.methods.updateStoredQueue();
      }

      // Extract and restore songs directory if present
      final songsDirectory = archive.files.where(
        (file) => file.name.startsWith('songs/'),
      );

      if (songsDirectory.isNotEmpty) {
        final appDir = await getApplicationSupportDirectory();
        final songsDir = Directory(path.join(appDir.path, 'media', 'audios'));

        if (!await songsDir.exists()) {
          await songsDir.create(recursive: true);
        }

        for (final file in songsDirectory) {
          if (file.isFile) {
            final filePath =
                path.join(songsDir.path, file.name.replaceFirst('songs/', ''));
            final restoredFile = File(filePath);
            await restoredFile.create(recursive: true);
            await restoredFile.writeAsBytes(file.content as List<int>);
          }
        }
      }
    } catch (e) {
      throw MusilyError(
        code: 401,
        id: 'backup_failed',
      );
    }
  }

  Future<File?> pickBackupFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        if (result.files.single.path!.endsWith('.lybak')) {
          return File(result.files.single.path!);
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<Directory> _getDownloadsDirectory() async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download/');
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      directory = await getDownloadsDirectory();
    }

    if (directory == null) {
      throw Exception('Could not find a suitable directory for backup.');
    }

    return Directory(path.join(directory.path, 'Musily'));
  }

  void _addDirectoryToArchive(
    Directory directory,
    Archive archive,
    String rootPath,
  ) {
    final files = directory.listSync(recursive: true);
    for (final file in files) {
      if (file is File) {
        final relativePath = path.relative(file.path, from: directory.path);
        final archivePath =
            path.join(rootPath, relativePath).replaceAll('\\', '/');
        final fileBytes = file.readAsBytesSync();
        archive.addFile(ArchiveFile(
          archivePath,
          fileBytes.length,
          fileBytes,
        ));
      }
    }
  }
}
