import 'dart:async';

class ItemQueueEntity {
  final String id;
  final String url;
  final String fileName;
  double progress;
  String? filePath;
  bool cancelDownload;
  final StreamController<double> _progressController =
      StreamController<double>.broadcast();

  ItemQueueEntity({
    required this.id,
    required this.url,
    required this.fileName,
    this.cancelDownload = false,
    this.progress = 0.0,
    this.filePath,
  });

  Stream<double> get progressStream => _progressController.stream;

  void updateProgress(double newProgress) {
    progress = newProgress;
    _progressController.add(progress);
  }

  void dispose() {
    _progressController.close();
  }
}
