import 'dart:developer';
import 'dart:isolate';

import 'package:musily/core/presenter/extensions/string.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/ui/utils/ly_snackbar.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

Future<String?> _getYoutubeAudioUrl(String ytId) async {
  try {
    final yt = YoutubeExplode();
    final manifest = await yt.videos.streamsClient.getManifest(
      VideoId(ytId),
      requireWatchPage: true,
      ytClients: [YoutubeApiClient.androidVr],
    );
    final supportedStreams = manifest.audioOnly.sortByBitrate();

    final audioStreamInfo = supportedStreams.lastOrNull;
    if (audioStreamInfo == null) {
      return null;
    }
    final url = audioStreamInfo.url.toString();
    yt.close();
    return url;
  } catch (e) {
    log('Error getting YouTube audio URL in isolate: $e');
    return null;
  }
}

class GetPlayableItemUsecaseImpl implements GetPlayableItemUsecase {
  late final MusilyRepository _musilyRepository;

  GetPlayableItemUsecaseImpl({required MusilyRepository musilyRepository}) {
    _musilyRepository = musilyRepository;
  }

  @override
  Future<TrackEntity> exec(TrackEntity track, {String? youtubeId}) async {
    late final String ytId;

    if (youtubeId != null) {
      ytId = youtubeId;
    } else {
      ytId = track.id;
    }

    try {
      final url = await Isolate.run(() => _getYoutubeAudioUrl(ytId));

      if (url == null) {
        throw Exception('Failed to get audio URL from YouTube');
      }

      if (!(track.lowResImg?.isUrl ?? false) ||
          !(track.highResImg?.isUrl ?? false)) {
        final updatedTrack = await _musilyRepository.getTrack(track.id);
        track.highResImg = updatedTrack?.highResImg;
        track.lowResImg = updatedTrack?.lowResImg;
      }

      return TrackEntity(
        id: track.id,
        hash: track.hash,
        title: track.title,
        artist: track.artist,
        highResImg: track.highResImg,
        lowResImg: track.lowResImg,
        url: url.isUrl ? url : null,
        album: track.album,
        fromSmartQueue: track.fromSmartQueue,
        duration: track.duration,
      );
    } catch (e, stackTrace) {
      LySnackbar.show(e.toString());
      log('error: $e', stackTrace: stackTrace);
      return track;
    }
  }
}
