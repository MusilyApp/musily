import 'package:isar/isar.dart';

part 'download_queue.g.dart';

@collection
class DownloadQueueItem {
  Id id = Isar.autoIncrement;

  @Index()
  late String hash;

  late String trackId;
  late String title;
  late String artistId;
  late String artistName;
  late String albumId;
  late String albumTitle;
  String? highResImg;
  String? lowResImg;
  String? url;
  late int durationSeconds;
  late double progress;
  late String status;
  late int addedAt;

  DownloadQueueItem();
}
