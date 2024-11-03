import 'package:audio_service/audio_service.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

MediaItem mapToMediaItem(TrackEntity track, String url) {
  bool isUrl(String string) {
    return RegExp(r'^https?:\/\/[^\s/$.?#].[^\s]*$').hasMatch(string);
  }

  Uri? artUri({bool useLowResImg = false}) {
    if (useLowResImg) {
      if (track.lowResImg != null) {
        return isUrl(track.lowResImg!)
            ? Uri.parse(track.lowResImg!)
            : Uri.file(track.lowResImg!);
      }
    } else {
      if (track.highResImg != null) {
        return isUrl(track.highResImg!)
            ? Uri.parse(track.highResImg!)
            : Uri.file(track.highResImg!);
      }
    }
    return null;
  }

  return MediaItem(
    id: track.id,
    album: '',
    artist: track.artist.name,
    title: track.title,
    artUri: artUri(),
    extras: {
      'url': track.url,
      if (track.lowResImg != null)
        'lowResImage': artUri(
          useLowResImg: true,
        ).toString(),
      'ytid': track.id,
      if (track.highResImg != null) 'artWorkPath': artUri().toString(),
    },
  );
}
