import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/utils/string_is_url.dart';
import 'package:musily/features/downloader/domain/entities/item_queue_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller_data.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller_methods.dart';
import 'package:musily_player/musily_entities.dart';
import 'package:path_provider/path_provider.dart';
import 'package:queue/queue.dart';
import 'package:path/path.dart' as path;

class DownloaderController extends BaseController<DownloaderControllerData,
    DownloaderControllerMethods> {
  final Queue _queue = Queue(
    parallel: 2,
  );
  final Set<String> _downloading = {};

  final GetPlayableItemUsecase getPlayableItemUsecase;

  DownloaderController({
    required this.getPlayableItemUsecase,
  });

  @override
  DownloaderControllerData defineData() {
    return DownloaderControllerData(
      downloadingId: '',
      downloadQueue: [],
    );
  }

  @override
  DownloaderControllerMethods defineMethods() {
    return DownloaderControllerMethods(
      addDownload: (
        item, {
        required downloadingId,
        ytId,
      }) {
        if (!stringIsUrl(item.url) && item.url.isNotEmpty) {
          return;
        }
        if (item.cancelDownload) {
          return;
        }
        if (data.downloadQueue
            .where((element) => element.id == item.id)
            .isNotEmpty) {
          return;
        }
        updateData(
          data.copyWith(
            downloadingId: downloadingId,
          ),
        );
        _queue.add(
          () => methods.startDownload(
            item,
            ytId: ytId,
          ),
        );
        final updatedQueue = List<ItemQueueEntity>.from(data.downloadQueue)
          ..add(item);
        updateData(data.copyWith(downloadQueue: updatedQueue));
      },
      startDownload: (item, {String? ytId}) async {
        if (_downloading.contains(item.id)) return;

        _downloading.add(item.id);

        if (item.cancelDownload) {
          _downloading.remove(item.id);
          updateData(
            data.copyWith(
              downloadQueue: data.downloadQueue
                ..removeWhere(
                  (element) => element.id == item.id,
                ),
            ),
          );
          return;
        }

        try {
          () {
            item.updateProgress(.01);
            final updatedQueue = List<ItemQueueEntity>.from(data.downloadQueue);
            final index =
                updatedQueue.indexWhere((element) => element.id == item.id);
            if (index != -1) {
              updatedQueue[index] = item;
              updateData(data.copyWith(downloadQueue: updatedQueue));
            }
          }();

          late final String url;

          await () async {
            if (item.url.isEmpty) {
              final playableItem = await getPlayableItemUsecase.exec(
                MusilyTrack(
                  id: ytId ?? item.id,
                  ytId: ytId,
                ),
              );
              url = playableItem.url ?? '';
            } else {
              url = item.url;
            }
          }();

          if (!stringIsUrl(url)) {
            return;
          }
          final response =
              await http.Client().send(http.Request('GET', Uri.parse(url)));
          final contentLength = response.contentLength ?? 0;
          final directory = await getApplicationSupportDirectory();

          final fileDir = Directory(
            path.dirname(
              path.join(
                directory.path,
                item.fileName,
              ),
            ),
          );
          if (!await fileDir.exists()) {
            await fileDir.create(recursive: true);
          }

          final filePath = '${directory.path}/${item.fileName}';
          final file = File(filePath);
          final sink = file.openWrite();

          int downloaded = 0;

          await for (var chunk in response.stream) {
            if (item.cancelDownload) {
              break;
            }
            downloaded += chunk.length;
            item.updateProgress(downloaded / contentLength);
            final updatedQueue = List<ItemQueueEntity>.from(data.downloadQueue);
            final index =
                updatedQueue.indexWhere((element) => element.id == item.id);
            if (index != -1) {
              updatedQueue[index] = item;
              updateData(data.copyWith(downloadQueue: updatedQueue));
            }
            sink.add(chunk);
          }

          await sink.close();

          if (item.cancelDownload) {
            if (file.existsSync()) {
              await file.delete();
            }
            updateData(
              data.copyWith(
                downloadQueue: data.downloadQueue..remove(item),
              ),
            );
          } else if (file.existsSync()) {
            final md5FilePath = '$filePath.md5';
            final md5File = File(md5FilePath);
            final fileMd5 = md5.convert(await file.readAsBytes()).toString();
            await md5File.writeAsString(fileMd5);

            item.filePath = filePath;
            item.updateProgress(1.0);
          }

          final updatedQueue = List<ItemQueueEntity>.from(data.downloadQueue);
          final index =
              updatedQueue.indexWhere((element) => element.id == item.id);
          if (index != -1) {
            updatedQueue[index] = item;
            updateData(data.copyWith(downloadQueue: updatedQueue));
          }
        } finally {
          _downloading.remove(item.id);
        }
      },
      getDownloadedFiles: () async {
        final List<ItemQueueEntity> validFiles = [];
        final directory = await getApplicationSupportDirectory();
        final files = directory.listSync();

        for (var file in files) {
          if (file is File && file.path.endsWith('.md5')) {
            final fileNameWithoutMd5 =
                file.path.substring(0, file.path.length - 4);
            final fileContent = await file.readAsString();
            final fileBytes = await File(fileNameWithoutMd5).readAsBytes();
            final currentMd5 = md5.convert(fileBytes).toString();

            if (fileContent == currentMd5) {
              final item = ItemQueueEntity(
                id: fileNameWithoutMd5.split('/').last,
                fileName: fileNameWithoutMd5.split('/').last,
                filePath: fileNameWithoutMd5,
                progress: 1.0,
                url: '',
              );
              validFiles.add(item);
            } else {
              await file.delete();
              await File(fileNameWithoutMd5).delete();
            }
          }
        }
        data.downloadQueue.addAll(validFiles);
        updateData(data);
        return validFiles;
      },
      getFile: (id) async {
        final directory = await getApplicationSupportDirectory();
        final filePath = '${directory.path}/$id';
        final md5FilePath = '$filePath.md5';

        final file = File(filePath);
        final md5File = File(md5FilePath);

        final currentDownloadingItemsId = data.downloadQueue.map(
          (element) => element.id,
        );

        if (await file.exists()) {
          if (await md5File.exists()) {
            final savedMd5 = await md5File.readAsString();
            final fileBytes = await file.readAsBytes();
            final currentMd5 = md5.convert(fileBytes).toString();

            if (savedMd5 == currentMd5) {
              final item = ItemQueueEntity(
                id: id,
                url: '',
                fileName: id,
                filePath: filePath,
                progress: 1.0,
              );
              data.downloadQueue.add(item);
              return item;
            } else {
              await file.delete();
              await md5File.delete();
            }
          } else if (currentDownloadingItemsId.contains(id)) {
            return data.downloadQueue.firstWhere((element) => element.id == id);
          } else {
            await file.delete();
          }
        }
        return null;
      },
      removeDownload: (id) async {
        final directory = await getApplicationSupportDirectory();
        final filePath = '${directory.path}/$id';
        final md5FilePath = '$filePath.md5';

        final file = File(filePath);
        final md5File = File(md5FilePath);

        if (await file.exists()) {
          await file.delete();
        }
        if (await md5File.exists()) {
          await md5File.delete();
        }
        updateData(
          data.copyWith(
            downloadQueue: data.downloadQueue
              ..removeWhere(
                (element) => element.id == id,
              ),
          ),
        );
      },
      cancelDownload: (id) async {
        final itemQueue = data.downloadQueue.where(
          (element) => element.id == id,
        );
        if (itemQueue.isNotEmpty) {
          if (itemQueue.first.progress == 0) {
            itemQueue.first.cancelDownload = true;
          } else if (itemQueue.first.progress != 1) {
            itemQueue.first.cancelDownload = true;
          }
        }
      },
    );
  }
}
