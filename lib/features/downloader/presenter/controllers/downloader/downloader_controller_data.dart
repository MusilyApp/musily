import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/downloader/domain/entities/item_queue_entity.dart';

class DownloaderControllerData implements BaseControllerData {
  final String downloadingId;
  final List<ItemQueueEntity> downloadQueue;

  DownloaderControllerData({
    required this.downloadQueue,
    required this.downloadingId,
  });

  @override
  DownloaderControllerData copyWith({
    List<ItemQueueEntity>? downloadQueue,
    String? downloadingId,
  }) {
    return DownloaderControllerData(
      downloadQueue: downloadQueue ?? this.downloadQueue,
      downloadingId: downloadingId ?? this.downloadingId,
    );
  }
}
