import 'package:musily/core/domain/errors/app_error.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/utils/string_is_url.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/musily_entities.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class GetPlayableItemUsecaseImpl implements GetPlayableItemUsecase {
  @override
  Future<MusilyTrack> exec(MusilyTrack track) async {
    final yt = YoutubeExplode();
    late final String ytId;
    final DownloaderController downloaderController = DownloaderController(
      getPlayableItemUsecase: this,
    );

    late final String url;

    final downloadedItem = await downloaderController.methods.getFile(
      'media/audios/${track.hash}',
    );
    if (downloadedItem != null && downloadedItem.filePath != null) {
      url = downloadedItem.filePath!;
      ytId = track.id;
    } else {
      if (track.ytId == track.id) {
        ytId = track.id;
      } else {
        final searchResults = await yt.search.search(
          '${track.title} ${track.artist?.name}',
        );
        if (searchResults.isEmpty) {
          throw AppError(
            code: 404,
            error: 'not_found',
            title: 'Arquivo não encontrado',
            message: 'O arquivo da música não foi encontrado.',
          );
        }
        ytId = searchResults.first.id.toString();
      }

      final manifest = await yt.videos.streamsClient.getManifest(VideoId(ytId));
      final audioSteamInfo = manifest.audioOnly.withHighestBitrate();

      url = audioSteamInfo.url.toString();
    }

    return MusilyTrack(
      id: track.id,
      hash: track.hash,
      title: track.title,
      artist: track.artist,
      highResImg: track.highResImg,
      lowResImg: track.lowResImg,
      url: stringIsUrl(url) ? url : null,
      filePath: !stringIsUrl(url) ? url : null,
      ytId: ytId,
    );
  }
}
