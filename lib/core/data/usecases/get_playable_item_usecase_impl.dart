import 'package:musily/core/presenter/extensions/string.dart';
import 'package:musily/core/domain/errors/musily_error.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class GetPlayableItemUsecaseImpl implements GetPlayableItemUsecase {
  late final MusilyRepository _musilyRepository;

  GetPlayableItemUsecaseImpl({
    required MusilyRepository musilyRepository,
  }) {
    _musilyRepository = musilyRepository;
  }

  @override
  Future<TrackEntity> exec(TrackEntity track, {String? youtubeId}) async {
    final yt = YoutubeExplode();
    late final String ytId;

    late final String url;
    if (youtubeId != null) {
      ytId = track.id;
    } else {
      final searchResults = await _musilyRepository.searchTracks(
        '${track.title} ${track.artist.name}',
      );
      if (searchResults.isEmpty) {
        throw MusilyError(code: 404, id: 'track_not_found');
      }
      ytId = searchResults.first.id.toString();
    }

    final manifest = await yt.videos.streamsClient.getManifest(VideoId(ytId));
    final audioSteamInfo = manifest.audioOnly.withHighestBitrate();

    url = audioSteamInfo.url.toString();

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
  }
}
