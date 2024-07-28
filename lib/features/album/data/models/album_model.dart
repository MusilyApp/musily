import 'package:musily/core/data/database/library_database.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class AlbumModel {
  static AlbumEntity fromMap(Map<String, dynamic> map) {
    return AlbumEntity(
      id: map['id'],
      title: map['title'] ?? '',
      year: map['year'] ?? 0,
      artist: ShortArtist(
        id: map['artist']?['id'] ?? '',
        name: map['artist']?['name'] ?? '',
      ),
      highResImg: map['highResImg'],
      lowResImg: map['lowResImg'],
      tracks: [
        ...(map['tracks'] ?? []).map(
          (element) => TrackModel.fromMap(
            element,
          ),
        )
      ],
    );
  }

  static Map<String, dynamic> toMap(AlbumEntity album) {
    return <String, dynamic>{
      'id': album.id,
      'title': album.title,
      'year': album.year,
      'artist': {
        'id': album.artist.id,
        'name': album.artist.name,
      },
      'tracks': album.tracks.map((x) => TrackModel.toMap(x)).toList(),
      'lowResImg': album.lowResImg,
      'highResImg': album.highResImg,
    };
  }

  static Future<AlbumEntity> toOffline(
    AlbumEntity album,
    DownloaderController downloaderController,
  ) async {
    final db = LibraryDatabase();
    final libraryTracks = <TrackEntity>[];
    final offlineHighResImg = await downloaderController.methods.getFile(
      'media/images/${album.id}-600x600',
    );
    final offlineLowResImg = await downloaderController.methods.getFile(
      'media/images/${album.id}-60x60',
    );
    if (album.tracks.isEmpty) {
      final libraryAlbumMap = await db.findById(album.id);
      if (libraryAlbumMap != null) {
        final libraryAlbum = AlbumModel.fromMap(libraryAlbumMap);
        libraryTracks.addAll(libraryAlbum.tracks);
      }
    } else {
      libraryTracks.addAll(album.tracks);
    }

    final offlineTracks = <TrackEntity>[];
    for (final track in libraryTracks) {
      final offilineTrack = await TrackModel.toOffline(
        track,
        downloaderController,
      );
      offlineTracks.add(offilineTrack);
    }
    return AlbumEntity(
      title: album.title,
      id: album.id,
      artist: album.artist,
      tracks: offlineTracks,
      highResImg: offlineHighResImg?.filePath ?? album.highResImg,
      lowResImg: offlineLowResImg?.filePath ?? album.lowResImg,
      year: album.year,
    );
  }
}
