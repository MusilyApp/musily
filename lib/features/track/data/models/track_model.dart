import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily_player/musily_entities.dart';

class TrackModel {
  static TrackEntity fromMap(Map<String, dynamic> map) {
    return TrackEntity(
      id: map['id'],
      title: map['title'],
      hash: map['hash'],
      artist: ShortArtist(
        id: map['artist']['id'] ?? '',
        name: map['artist']['name'] ?? '',
      ),
      album: ShortAlbum(
        id: map['album']?['id'] ?? '',
        title: map['album']?['title'] ?? '',
      ),
      highResImg: map['highResImg'],
      lowResImg: map['lowResImg'],
      source: map['source'],
      fromSmartQueue: map['fromSmartQueue'] ?? map['recommendedTrack'] ?? false,
    );
  }

  static Map<String, dynamic> toMap(TrackEntity track) {
    return {
      'id': track.id,
      'title': track.title,
      'hash': track.hash,
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
      'source': track.source.toLowerCase() == 'unknown'
          ? 'youtube'
          : track.source.toLowerCase(),
    };
  }

  static MusilyTrack toMusilyTrack(TrackEntity track) {
    return MusilyTrack(
      id: track.id,
      album: MusilyAlbum(
        id: track.album.id,
        title: track.album.title,
      ),
      artist: MusilyArtist(
        id: track.artist.id,
        name: track.artist.name,
      ),
      filePath: track.url,
      hash: track.hash,
      highResImg: track.highResImg,
      lowResImg: track.lowResImg,
      title: track.title,
      url: track.url,
      fromSmartQueue: track.fromSmartQueue,
      ytId: track.source == 'youtube' ? track.id : null,
    );
  }

  static TrackEntity fromMusilyTrack(MusilyTrack track) {
    return TrackEntity(
      id: track.id,
      title: track.title ?? '',
      hash: track.hash ?? '',
      artist: ShortArtist(
        id: track.artist?.id ?? '',
        name: track.artist?.name ?? '',
      ),
      album: ShortAlbum(
        id: track.album?.id ?? '',
        title: track.album?.title ?? '',
      ),
      highResImg: track.highResImg,
      lowResImg: track.lowResImg,
      fromSmartQueue: track.fromSmartQueue,
      source: track.ytId != null ? 'youtube' : 'unknown',
    );
  }

  static Future<TrackEntity> toOffline(
    TrackEntity track,
    DownloaderController downloaderController,
  ) async {
    final item = downloaderController.methods.getItem(
      TrackModel.toMusilyTrack(
        track,
      ),
    );

    final offlineAudio = item?.track.url;
    final offlineHighResImg = item?.track.highResImg;
    final offlineLowResImg = item?.track.lowResImg;

    return TrackEntity(
      id: track.id,
      title: track.title,
      hash: track.hash,
      album: track.album,
      artist: track.artist,
      url: offlineAudio ?? track.url,
      highResImg: offlineHighResImg ?? track.highResImg,
      lowResImg: offlineLowResImg ?? track.lowResImg,
      fromSmartQueue: false,
      source: track.source,
    );
  }
}
