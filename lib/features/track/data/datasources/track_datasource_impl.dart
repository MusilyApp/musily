import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/datasources/track_datasource.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily_repository/musily_repository.dart' as repo;

class TrackDatasourceImpl implements TrackDatasource {
  final DownloaderController downloaderController;

  TrackDatasourceImpl({
    required this.downloaderController,
  });

  @override
  Future<TrackEntity?> getTrack(String id) async {
    try {
      final track = await repo.getTrack(id);
      final offlineTrack = await TrackModel.toOffline(
        TrackModel.fromMap(track),
        downloaderController,
      );
      return offlineTrack;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<TrackEntity>> getTracks(String query) async {
    try {
      final data = await repo.getTracks(query);
      final tracks = [
        ...(data as List).map((element) => TrackModel.fromMap(element))
      ];
      final offlineTracks = <TrackEntity>[];

      for (final item in tracks) {
        final offlineItem = await TrackModel.toOffline(
          item,
          downloaderController,
        );
        offlineTracks.add(offlineItem);
      }
      return offlineTracks;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<String?> getTrackLyrics(String id) async {
    try {
      final lyrics = await repo.getTrackLyrics(id);
      return lyrics;
    } catch (e) {
      return null;
    }
  }
}
