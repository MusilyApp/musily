import 'package:dart_ytmusic_api/types.dart';
import 'package:musily/core/domain/datasources/base_datasource.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/datasources/track_datasource.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class TrackDatasourceImpl extends BaseDatasource implements TrackDatasource {
  late final DownloaderController _downloaderController;
  late final MusilyRepository _musilyRepository;

  TrackDatasourceImpl({
    required DownloaderController downloaderController,
    required MusilyRepository musilyRepository,
  }) {
    _downloaderController = downloaderController;
    _musilyRepository = musilyRepository;
  }

  @override
  Future<TrackEntity?> getTrack(String id) async {
    return exec<TrackEntity?>(() async {
      final track = await _musilyRepository.getTrack(id);
      if (track == null) {
        return null;
      }
      final offlineTrack = await TrackModel.toOffline(
        track,
        _downloaderController,
      );
      return offlineTrack;
    });
  }

  @override
  Future<List<TrackEntity>> getTracks(String query) async {
    return exec<List<TrackEntity>>(() async {
      final tracks = await _musilyRepository.searchTracks(query);
      final offlineTracks = <TrackEntity>[];

      for (final item in tracks) {
        final offlineItem = await TrackModel.toOffline(
          item,
          _downloaderController,
        );
        offlineTracks.add(offlineItem);
      }
      return offlineTracks;
    });
  }

  @override
  Future<String?> getTrackLyrics(String id) async {
    return exec<String?>(() async {
      final lyrics = await _musilyRepository.getTrackLyrics(id);
      return lyrics;
    });
  }

  @override
  Future<TimedLyricsRes?> getTimedLyrics(String id) {
    return exec<TimedLyricsRes?>(() async {
      final timedLyrics = await _musilyRepository.getTimedLyrics(id);
      return timedLyrics;
    });
  }
}
