import 'package:musily/features/downloader/domain/entities/item_queue_entity.dart';

class DownloaderControllerMethods {
  void Function(
    ItemQueueEntity item, {
    required String downloadingId,
    String? ytId,
  }) addDownload;
  Future<void> Function(
    ItemQueueEntity item, {
    String? ytId,
  }) startDownload;
  Future<List<ItemQueueEntity>> Function() getDownloadedFiles;
  Future<void> Function(String id) removeDownload;
  Future<void> Function(String id) cancelDownload;
  Future<ItemQueueEntity?> Function(String id) getFile;

  DownloaderControllerMethods({
    required this.addDownload,
    required this.startDownload,
    required this.getDownloadedFiles,
    required this.removeDownload,
    required this.getFile,
    required this.cancelDownload,
  });
}
