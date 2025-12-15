import 'dart:convert';

import 'package:musily/features/wrapped/domain/entities/wrapped_album_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_artist_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_track_entity.dart';

class WrappedEntity {
  final String id;

  final DateTime rangeStart;
  final DateTime rangeEnd;

  final String visualSeed;

  final int totalMinutesListened;
  final int totalTracksListened;
  final int totalAlbumsListened;
  final int totalArtistsListened;

  final List<WrappedTrackEntity> topTracks;
  final List<WrappedAlbumEntity> topAlbums;
  final List<WrappedArtistEntity> topArtists;

  final WrappedTrackEntity? mostListenedTrack;
  final int? mostListenedTrackMinutes;
  final int? mostListenedTrackPlays;

  final WrappedAlbumEntity? mostListenedAlbum;
  final int? mostListenedAlbumMinutes;
  final int? mostListenedAlbumPlays;

  final WrappedArtistEntity? mostListenedArtist;
  final int? mostListenedArtistMinutes;
  final int? mostListenedArtistPlays;

  const WrappedEntity({
    required this.id,
    required this.rangeStart,
    required this.rangeEnd,
    required this.visualSeed,
    required this.totalMinutesListened,
    required this.totalTracksListened,
    required this.totalAlbumsListened,
    required this.totalArtistsListened,
    required this.topTracks,
    required this.topAlbums,
    required this.topArtists,
    required this.mostListenedTrack,
    required this.mostListenedTrackMinutes,
    required this.mostListenedTrackPlays,
    required this.mostListenedAlbum,
    required this.mostListenedAlbumMinutes,
    required this.mostListenedAlbumPlays,
    required this.mostListenedArtist,
    required this.mostListenedArtistMinutes,
    required this.mostListenedArtistPlays,
  });

  factory WrappedEntity.fromMap(Map<String, dynamic> map) {
    return WrappedEntity(
      id: map['id'],
      rangeStart: DateTime.parse(map['rangeStart']),
      rangeEnd: DateTime.parse(map['rangeEnd']),
      visualSeed: map['visualSeed'],
      totalMinutesListened: map['totalMinutesListened'],
      totalTracksListened: map['totalTracksListened'],
      totalAlbumsListened: map['totalAlbumsListened'],
      totalArtistsListened: map['totalArtistsListened'],
      topTracks: (map['topTracks'] as List)
          .map((e) => WrappedTrackEntity.fromMap(e))
          .toList(),
      topAlbums: (map['topAlbums'] as List)
          .map((e) => WrappedAlbumEntity.fromMap(e))
          .toList(),
      topArtists: (map['topArtists'] as List)
          .map((e) => WrappedArtistEntity.fromMap(e))
          .toList(),
      mostListenedTrack: map['mostListenedTrack'] != null
          ? WrappedTrackEntity.fromMap(map['mostListenedTrack'])
          : null,
      mostListenedTrackMinutes: map['mostListenedTrackMinutes'],
      mostListenedTrackPlays: map['mostListenedTrackPlays'],
      mostListenedAlbum: map['mostListenedAlbum'] != null
          ? WrappedAlbumEntity.fromMap(map['mostListenedAlbum'])
          : null,
      mostListenedAlbumMinutes: map['mostListenedAlbumMinutes'],
      mostListenedAlbumPlays: map['mostListenedAlbumPlays'],
      mostListenedArtist: map['mostListenedArtist'] != null
          ? WrappedArtistEntity.fromMap(map['mostListenedArtist'])
          : null,
      mostListenedArtistMinutes: map['mostListenedArtistMinutes'],
      mostListenedArtistPlays: map['mostListenedArtistPlays'],
    );
  }

  factory WrappedEntity.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return WrappedEntity.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rangeStart': rangeStart.toIso8601String(),
      'rangeEnd': rangeEnd.toIso8601String(),
      'visualSeed': visualSeed,
      'totalMinutesListened': totalMinutesListened,
      'totalTracksListened': totalTracksListened,
      'totalAlbumsListened': totalAlbumsListened,
      'totalArtistsListened': totalArtistsListened,
      'topTracks': topTracks.map((e) => e.toJson()).toList(),
      'topAlbums': topAlbums.map((e) => e.toJson()).toList(),
      'topArtists': topArtists.map((e) => e.toJson()).toList(),
      'mostListenedTrack': mostListenedTrack?.toJson(),
      'mostListenedTrackMinutes': mostListenedTrackMinutes,
      'mostListenedTrackPlays': mostListenedTrackPlays,
      'mostListenedAlbum': mostListenedAlbum?.toJson(),
      'mostListenedAlbumMinutes': mostListenedAlbumMinutes,
      'mostListenedAlbumPlays': mostListenedAlbumPlays,
      'mostListenedArtist': mostListenedArtist?.toJson(),
      'mostListenedArtistMinutes': mostListenedArtistMinutes,
      'mostListenedArtistPlays': mostListenedArtistPlays,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
