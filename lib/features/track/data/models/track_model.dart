import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class TrackModel {
  static TrackEntity fromMap(Map<String, dynamic> map) {
    return TrackEntity(
      id: map['trackId'] ?? map['id'],
      title: map['title'],
      orderIndex: map['orderIndex'] ?? 0,
      hash: map['hash'],
      url: map['url'],
      artist: SimplifiedArtist(
        id: map['artist']['id'] ?? '',
        name: map['artist']['name'] ?? '',
      ),
      album: SimplifiedAlbum(
        id: map['album']?['id'] ?? '',
        title: map['album']?['title'] ?? '',
      ),
      highResImg: map['highResImg'],
      lowResImg: map['lowResImg'],
      source: map['source'],
      fromSmartQueue: map['fromSmartQueue'] ?? map['recommendedTrack'] ?? false,
      duration: Duration(seconds: map['duration'] ?? 0),
    );
  }

  static Map<String, dynamic> toMap(TrackEntity track, {bool withUrl = false}) {
    return {
      'id': track.id,
      'title': track.title,
      'orderIndex': track.orderIndex,
      'trackId': track.id,
      'hash': track.hash,
      if (withUrl && track.url != null) 'url': track.url,
      'artist': {
        'id': track.artist.id,
        'name': track.artist.name,
      },
      'album': {
        'id': track.album.id,
        'title': track.album.title,
      },
      'highResImg': track.highResImg,
      'lowResImg': track.lowResImg,
      'recommendedTrack': track.fromSmartQueue,
      'duration': track.duration.inSeconds,
      'source': track.source?.toLowerCase() == 'unknown'
          ? 'youtube'
          : track.source?.toLowerCase(),
    };
  }

  static Future<TrackEntity> toOffline(
    TrackEntity track,
    DownloaderController downloaderController,
  ) async {
    final item = downloaderController.methods.getItem(
      track,
    );

    final offlineAudio = item?.track.url;

    return TrackEntity(
      id: track.id,
      title: track.title,
      hash: track.hash,
      album: track.album,
      artist: track.artist,
      url: offlineAudio ?? track.url,
      highResImg: track.highResImg,
      lowResImg: track.lowResImg,
      fromSmartQueue: false,
      source: track.source,
      duration: track.duration,
    );
  }
}
