import 'dart:math';

import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:musily/core/utils/generate_section_id.dart';
import 'package:musily/core/utils/generate_track_hash.dart';
import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeDatasource {
  final ytMusic = YTMusic();

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString('locale');
    await ytMusic.initialize(hl: locale);
  }

  Future<AlbumEntity?> getAlbum(String albumId) async {
    final album = await ytMusic.getAlbum(albumId);
    return AlbumEntity(
      id: album.albumId,
      title: album.name,
      artist: SimplifiedArtist(
        id: album.artist.artistId ?? '',
        name: album.artist.name,
      ),
      year: album.year ?? 0,
      lowResImg: album.thumbnails[0].url.replaceAll(
        'w60-h60',
        'w100-h100',
      ),
      highResImg: album.thumbnails[0].url.replaceAll(
        'w60-h60',
        'w600-h600',
      ),
      tracks: List<TrackEntity>.from(
        album.songs.map(
          (track) => TrackEntity(
            id: track.videoId,
            hash: generateTrackHash(
              title: track.name,
              artist: track.artist.name,
              albumTitle: track.album?.name,
            ),
            title: track.name,
            artist: SimplifiedArtist(
              id: track.artist.artistId ?? '',
              name: track.artist.name,
            ),
            album: SimplifiedAlbum(
              id: track.album?.albumId ?? '',
              title: track.album?.name ?? '',
            ),
            lowResImg: track.thumbnails[0].url.replaceAll(
              'w60-h60',
              'w100-h100',
            ),
            highResImg: track.thumbnails[0].url.replaceAll(
              'w60-h60',
              'w600-h600',
            ),
            fromSmartQueue: false,
            duration: Duration(seconds: track.duration ?? 0),
          ),
        ),
      ),
    );
  }

  Future<ArtistEntity?> getArtist(String artistId) async {
    final artist = await ytMusic.getArtist(artistId);
    return ArtistEntity(
      id: artist.artistId,
      name: artist.name,
      lowResImg: artist.thumbnails[0].url.replaceAll(
        'w540-h225',
        'w100-h100',
      ),
      highResImg: artist.thumbnails[0].url.replaceAll(
        'w540-h225',
        'w600-h600',
      ),
      topTracks: artist.topSongs
          .map(
            (track) => TrackEntity(
              id: track.videoId,
              title: track.name,
              hash: generateTrackHash(
                title: track.name,
                artist: track.artist.name,
                albumTitle: track.album?.name,
              ),
              artist: SimplifiedArtist(
                id: track.artist.artistId ?? '',
                name: track.artist.name,
              ),
              album: SimplifiedAlbum(
                id: track.album?.albumId ?? '',
                title: track.album?.name ?? '',
              ),
              lowResImg: track.thumbnails[0].url.replaceAll(
                'w60-h60',
                'w100-h100',
              ),
              highResImg: track.thumbnails[0].url.replaceAll(
                'w60-h60',
                'w600-h600',
              ),
              fromSmartQueue: false,
              duration: Duration(seconds: track.duration ?? 0),
            ),
          )
          .toList(),
      topAlbums: artist.topAlbums
          .map(
            (album) => AlbumEntity(
              id: album.albumId,
              title: album.name,
              artist: SimplifiedArtist(
                id: album.artist.artistId ?? '',
                name: album.artist.name,
              ),
              lowResImg: album.thumbnails[0].url.replaceAll(
                'w60-h60',
                'w100-h100',
              ),
              highResImg: album.thumbnails[0].url.replaceAll(
                'w60-h60',
                'w600-h600',
              ),
              tracks: [],
              year: album.year ?? 2000,
            ),
          )
          .toList(),
      topSingles: artist.topSingles
          .map(
            (single) => AlbumEntity(
              id: single.albumId,
              title: single.name,
              artist: SimplifiedArtist(
                id: single.artist.artistId ?? '',
                name: single.artist.name,
              ),
              lowResImg: single.thumbnails[0].url.replaceAll(
                'w60-h60',
                'w100-h100',
              ),
              highResImg: single.thumbnails[0].url.replaceAll(
                'w60-h60',
                'w600-h600',
              ),
              tracks: [],
              year: single.year ?? 2000,
            ),
          )
          .toList(),
      similarArtists: artist.similarArtists
          .map(
            (similarArtist) => ArtistEntity(
              id: similarArtist.artistId,
              name: similarArtist.name,
              lowResImg: similarArtist.thumbnails[0].url.replaceAll(
                'w60-h60',
                'w60-h60',
              ),
              highResImg: similarArtist.thumbnails[0].url.replaceAll(
                'w60-h60',
                'w600-h600',
              ),
              topTracks: [],
              topAlbums: [],
              topSingles: [],
              similarArtists: [],
            ),
          )
          .toList(),
    );
  }

  Future<List<AlbumEntity>> getArtistAlbums(
    String artistId,
  ) async {
    final albums = await ytMusic.getArtistAlbums(artistId);
    return albums
        .map(
          (album) => AlbumEntity(
            id: album.albumId,
            title: album.name,
            artist: SimplifiedArtist(
              id: album.artist.artistId ?? '',
              name: album.artist.name,
            ),
            lowResImg: album.thumbnails[0].url.replaceAll(
              'w60-h60',
              'w60-h60',
            ),
            highResImg: album.thumbnails[0].url.replaceAll(
              'w60-h60',
              'w600-h600',
            ),
            tracks: [],
            year: album.year ?? 2000,
          ),
        )
        .toList();
  }

  Future<List<AlbumEntity>> getArtistSingles(
    String artistId,
  ) async {
    final singles = await ytMusic.getArtistSingles(artistId);
    return singles
        .map(
          (single) => AlbumEntity(
            id: single.albumId,
            title: single.name,
            artist: SimplifiedArtist(
              id: single.artist.artistId ?? '',
              name: single.artist.name,
            ),
            lowResImg: single.thumbnails[0].url.replaceAll(
              'w60-h60',
              'w60-h60',
            ),
            highResImg: single.thumbnails[0].url.replaceAll(
              'w60-h60',
              'w600-h600',
            ),
            tracks: [],
            year: single.year ?? 2000,
          ),
        )
        .toList();
  }

  Future<List<TrackEntity>> getArtistTracks(String artistId) async {
    final tracks = await ytMusic.getArtistSongs(artistId);
    return tracks
        .map(
          (track) => TrackEntity(
            id: track.videoId,
            title: track.name,
            hash: generateTrackHash(
              title: track.name,
              artist: track.artist.name,
              albumTitle: track.album?.name,
            ),
            artist: SimplifiedArtist(
              id: track.artist.artistId ?? '',
              name: track.artist.name,
            ),
            album: SimplifiedAlbum(
              id: track.album?.albumId ?? '',
              title: track.album?.name ?? '',
            ),
            lowResImg: track.thumbnails[0].url.replaceAll(
              'w60-h60',
              'w100-h100',
            ),
            highResImg: track.thumbnails[0].url.replaceAll(
              'w60-h60',
              'w600-h600',
            ),
            source: 'youtube',
            fromSmartQueue: false,
            duration: Duration(seconds: track.duration ?? 0),
          ),
        )
        .toList();
  }

  Future<PlaylistEntity?> getPlaylist(String playlistId) async {
    final explode = YoutubeExplode();
    final videos = await explode.playlists.getVideos(playlistId).toList();
    final playlist = await explode.playlists.get(playlistId);
    return PlaylistEntity(
      id: playlistId,
      title: playlist.title,
      artist: SimplifiedArtist(
        id: '',
        name: playlist.author,
      ),
      tracks: [
        ...videos.map(
          (video) => TrackEntity(
            id: video.id.toString(),
            title: video.title,
            hash: generateTrackHash(
              title: video.title,
              artist: video.author,
            ),
            artist: SimplifiedArtist(
              id: '',
              name: video.author,
            ),
            album: SimplifiedAlbum(
              id: '',
              title: '',
            ),
            highResImg: video.thumbnails.highResUrl,
            lowResImg: video.thumbnails.lowResUrl,
            source: 'youtube',
            fromSmartQueue: false,
            duration: video.duration ?? Duration.zero,
          ),
        ),
      ],
      trackCount: videos.length,
    );
  }

  Future<List<PlaylistEntity>> getUserPlaylists() async {
    return [];
  }

  Future<List<TrackEntity>> getRelatedTracks(List<TrackEntity> tracks) async {
    final shuffledTracks = List<TrackEntity>.from(tracks)..shuffle();
    final selectedTracks = shuffledTracks.sublist(
      0,
      min(3, shuffledTracks.length),
    );
    final random = Random();

    final explode = YoutubeExplode();
    final List<TrackEntity> relatedTracks = [...tracks];

    for (final track in selectedTracks) {
      final results =
          await explode.search('${track.title} ${track.artist.name}');
      if (results.isEmpty) {
        continue;
      }
      final relatedVideosList =
          await explode.videos.getRelatedVideos(results.first);
      final selectedVideos = (relatedVideosList?.toList() ?? []).sublist(
        0,
        min(3, relatedVideosList?.length ?? 0),
      );

      for (final video in selectedVideos) {
        final relatedSearch = await searchTracks(
          '${video.title} ${video.author}',
          includeVideos: false,
        );
        final relatedTrack = relatedSearch.firstOrNull;
        if (relatedTrack != null) {
          if (relatedTracks.map((e) => e.hash).contains(relatedTrack.hash)) {
            continue;
          }
          relatedTracks.insert(
            random.nextInt(relatedTracks.length),
            relatedTrack..fromSmartQueue = true,
          );
        }
      }
    }
    return relatedTracks;
  }

  Future<List<String>> getSearchSuggestions(String query) async {
    final suggestions = await ytMusic.getSearchSuggestions(query);
    return suggestions;
  }

  Future<TrackEntity?> getTrack(String trackId) async {
    final track = await ytMusic.getSong(trackId);
    return TrackEntity(
      id: track.videoId,
      hash: generateTrackHash(
        title: track.name,
        artist: track.artist.name,
      ),
      title: track.name,
      artist: SimplifiedArtist(
        id: track.artist.artistId ?? '',
        name: track.artist.name,
      ),
      album: SimplifiedAlbum(
        id: '',
        title: '',
      ),
      lowResImg: track.thumbnails[0].url.replaceAll(
        'w60-h60',
        'w100-h100',
      ),
      highResImg: track.thumbnails[0].url.replaceAll(
        'w60-h60',
        'w600-h600',
      ),
      source: 'youtube',
      fromSmartQueue: false,
      duration: Duration(seconds: track.duration),
    );
  }

  Future<String?> getTrackLyrics(String trackId) async {
    final lyrics = await ytMusic.getLyrics(trackId);
    return lyrics;
  }

  Future<List<AlbumEntity>> searchAlbums(
    String query,
  ) async {
    final albums = await ytMusic.searchAlbums(query);
    return albums.map((album) {
      return AlbumEntity(
        id: album.albumId,
        title: album.name,
        artist: SimplifiedArtist(
          id: album.artist.artistId ?? '',
          name: album.artist.name,
        ),
        lowResImg: album.thumbnails[0].url.replaceAll('w60-h60', 'w100-h100'),
        highResImg: album.thumbnails[0].url.replaceAll('w60-h60', 'w600-h600'),
        tracks: [],
        year: album.year ?? 2000,
      );
    }).toList();
  }

  Future<List<ArtistEntity>> searchArtists(
    String query,
  ) async {
    final artists = await ytMusic.searchArtists(query);
    return artists.map((artist) {
      return ArtistEntity(
        id: artist.artistId,
        name: artist.name,
        lowResImg: artist.thumbnails[0].url.replaceAll(
          'w60-h60',
          'w100-h100',
        ),
        highResImg: artist.thumbnails[0].url.replaceAll(
          'w60-h60',
          'w600-h600',
        ),
        similarArtists: [],
        topAlbums: [],
        topSingles: [],
        topTracks: [],
      );
    }).toList();
  }

  Future<List<TrackEntity>> searchTracks(
    String query, {
    bool includeVideos = true,
  }) async {
    final tracks = await ytMusic.searchSongs(query);
    final videos = await ytMusic.searchVideos(query);
    final trackVideos = videos.map(
      (video) => TrackEntity(
        id: video.videoId,
        hash: generateTrackHash(
          title: video.name,
          artist: video.artist.name,
        ),
        title: video.name,
        artist: SimplifiedArtist(
          id: video.artist.artistId ?? '',
          name: video.artist.name,
        ),
        album: SimplifiedAlbum(
          id: generateTrackHash(
            title: video.name,
            artist: video.artist.name,
          ),
          title: '',
        ),
        highResImg: video.thumbnails.firstOrNull?.url,
        lowResImg: video.thumbnails.firstOrNull?.url,
        source: 'youtube',
        fromSmartQueue: false,
        duration: Duration(seconds: video.duration ?? 0),
      ),
    );
    return [
      ...tracks.map((track) {
        return TrackEntity(
          id: track.videoId,
          hash: generateTrackHash(
            title: track.name,
            artist: track.artist.name,
            albumTitle: track.album?.name,
          ),
          title: track.name,
          artist: SimplifiedArtist(
            id: track.artist.artistId ?? '',
            name: track.artist.name,
          ),
          album: SimplifiedAlbum(
            id: track.album?.albumId ?? '',
            title: track.album?.name ?? '',
          ),
          lowResImg: track.thumbnails.firstOrNull?.url.replaceAll(
            'w60-h60',
            'w100-h100',
          ),
          highResImg: track.thumbnails.firstOrNull?.url.replaceAll(
            'w60-h60',
            'w600-h600',
          ),
          source: 'youtube',
          fromSmartQueue: false,
          duration: Duration(seconds: track.duration ?? 0),
        );
      }),
      if (includeVideos) ...trackVideos,
    ];
  }

  Future<List<HomeSectionEntity>> getHomeSections() async {
    final homeSections = await ytMusic.getHomeSections();
    return homeSections
        .map(
          (section) => HomeSectionEntity(
            id: generateSectionId(section.title),
            title: section.title,
            content: section.contents.map(
              (content) {
                if (content is AlbumDetailed) {
                  return AlbumEntity(
                    id: content.albumId,
                    title: content.name,
                    year: content.year ?? 0,
                    artist: SimplifiedArtist(
                      id: content.artist.artistId ?? '',
                      name: content.artist.name,
                    ),
                    tracks: [],
                    lowResImg: content.thumbnails[0].url.replaceAll(
                      'w60-h60',
                      'w100-h100',
                    ),
                    highResImg: content.thumbnails[0].url.replaceAll(
                      'w60-h60',
                      'w600-h600',
                    ),
                  );
                }
                if (content is PlaylistDetailed) {
                  return PlaylistEntity(
                    id: content.playlistId,
                    title: content.name,
                    artist: SimplifiedArtist(
                      id: content.artist.artistId ?? '',
                      name: content.artist.name,
                    ),
                    tracks: [],
                    lowResImg: content.thumbnails[0].url.replaceAll(
                      'w60-h60',
                      'w100-h100',
                    ),
                    highResImg: content.thumbnails[0].url.replaceAll(
                      'w60-h60',
                      'w600-h600',
                    ),
                    trackCount: 0,
                  );
                }
              },
            ).toList(),
          ),
        )
        .toList();
  }
}
