import 'package:musily/features/album/data/models/album_model.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/data/models/track_model.dart';

class ArtistModel {
  static ArtistEntity fromMap(Map<String, dynamic> map) {
    return ArtistEntity(
      id: map['id'],
      name: map['name'],
      highResImg: map['highResImg'],
      lowResImg: map['lowResImg'],
      topTracks: map['topTracks'] == null
          ? []
          : [
              ...(map['topTracks'] as List).map(
                (track) => TrackModel.fromMap(track),
              ),
            ],
      topAlbums: map['topAlbums'] == null
          ? []
          : [
              ...(map['topAlbums'] as List).map(
                (album) => AlbumModel.fromMap(
                  album,
                ),
              ),
            ],
      topSingles: map['topSingles'] == null
          ? []
          : [
              ...(map['topSingles'] as List).map(
                (single) => AlbumModel.fromMap(
                  single,
                ),
              ),
            ],
      similarArtists: map['similarArtists'] == null
          ? []
          : [
              ...(map['similarArtists'] as List).map(
                (artist) => ArtistModel.fromMap(
                  artist,
                ),
              ),
            ],
    );
  }

  static Map<String, dynamic> toMap(ArtistEntity artist) {
    return {
      'id': artist.id,
      'name': artist.name,
      'highResImg': artist.highResImg,
      'lowResImg': artist.lowResImg,
      'topTracks': [
        ...artist.topTracks.map(
          (track) => TrackModel.toMap(track),
        ),
      ],
      'topAlbums': [
        ...artist.topAlbums.map(
          (album) => AlbumModel.toMap(
            album,
          ),
        ),
      ],
      'topSingles': [
        ...artist.topSingles.map(
          (single) => AlbumModel.toMap(single),
        ),
      ],
      'similarArtists': [
        ...artist.similarArtists.map(
          (similarArtist) => ArtistModel.toMap(similarArtist),
        ),
      ],
    };
  }
}
