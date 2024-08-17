import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/datasources/track_datasource.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily_repository/core/data/mappers/track_mapper.dart';
import 'package:musily_repository/musily_repository.dart';

class TrackDatasourceImpl implements TrackDatasource {
  final DownloaderController downloaderController;

  TrackDatasourceImpl({
    required this.downloaderController,
  });

  @override
  Future<TrackEntity?> getTrack(String id) async {
    try {
      final musilyRepository = MusilyRepository();
      final track = await musilyRepository.getTrack(id);
      if (track == null) {
        return null;
      }
      final offlineTrack = await TrackModel.toOffline(
        TrackModel.fromMap(
          TrackMapper().toMap(
            track,
          ),
        ),
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
      final musilyRepository = MusilyRepository();
      final data = await musilyRepository.searchTracks(query);
      final tracks = [
        ...data.map(
          (element) => TrackModel.fromMap(
            TrackMapper().toMap(
              element,
            ),
          ),
        ),
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
      final musilyRepository = MusilyRepository();
      final lyrics = await musilyRepository.getTrackLyrics(id);
      return lyrics;
    } catch (e) {
      return null;
    }
  }
}
