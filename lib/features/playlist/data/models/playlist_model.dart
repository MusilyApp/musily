import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/data/models/track_model.dart';

class PlaylistModel {
  static PlaylistEntity fromMap(
    Map<String, dynamic> map, {
    int? trackCount,
  }) {
    return PlaylistEntity(
      id: map['id'],
      title: map['title'] ?? map['name'],
      artist: SimplifiedArtist(
        id: map['artist']?['id'] ?? '',
        name: map['artist']?['name'] ?? '',
      ),
      highResImg: map['highResImg'],
      lowResImg: map['lowResImg'],
      trackCount: trackCount ?? (map['trackCount'] ?? 0),
      tracks: [
        ...(map['tracks'] ?? []).map(
          (track) => TrackModel.fromMap(track),
        ),
      ],
    );
  }

  static Map<String, dynamic> toMap(PlaylistEntity playlist) {
    return <String, dynamic>{
      'id': playlist.id,
      'title': playlist.title,
      'artist': {
        'id': playlist.artist?.id,
        'name': playlist.artist?.name,
      },
      'highResImg': playlist.highResImg,
      'lowResImg': playlist.lowResImg,
      'trackCount': playlist.trackCount,
      'tracks': playlist.tracks.map((x) => TrackModel.toMap(x)).toList(),
    };
  }
}
