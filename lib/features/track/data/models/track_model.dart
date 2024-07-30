import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
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
      fromSmartQueue: map['fromSmartQueue'] ?? false,
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
      'source': track.source,
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
      ytId: track.id,
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
      fromSmartQueue: false,
      source: track.ytId != null ? 'YouTube' : 'unknown',
    );
  }

  static Future<TrackEntity> toOffline(
    TrackEntity track,
    DownloaderController downloaderController,
  ) async {
    final offlineAudio = await downloaderController.methods.getFile(
      'media/audios/${track.hash}',
    );
    final offlineHighResImg = await downloaderController.methods.getFile(
      'media/images/${track.album.id}-600x600',
    );
    final offlineLowResImg = await downloaderController.methods.getFile(
      'media/images/${track.album.id}-60x60',
    );
    return TrackEntity(
      id: track.id,
      title: track.title,
      hash: track.hash,
      album: track.album,
      artist: track.artist,
      url: offlineAudio?.filePath ?? track.url,
      highResImg: offlineHighResImg?.filePath ?? track.highResImg,
      lowResImg: offlineLowResImg?.filePath ?? track.lowResImg,
      fromSmartQueue: false,
      source: track.source,
    );
  }
}
