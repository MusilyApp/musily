import 'dart:convert';

class LocalTrackMetadata {
  final String? title;
  final String? artist;
  final String? album;
  final String? artworkPath;

  const LocalTrackMetadata({
    this.title,
    this.artist,
    this.album,
    this.artworkPath,
  });

  LocalTrackMetadata copyWith({
    String? title,
    String? artist,
    String? album,
    String? artworkPath,
  }) {
    return LocalTrackMetadata(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      artworkPath: artworkPath ?? this.artworkPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'album': album,
      'artworkPath': artworkPath,
    };
  }

  factory LocalTrackMetadata.fromMap(Map<String, dynamic> map) {
    final mappedArtworkPath = map['artworkPath'] as String?;
    final legacyArtworkDataUri = map['artworkDataUri'] as String?;

    return LocalTrackMetadata(
      title: map['title'] as String?,
      artist: map['artist'] as String?,
      album: map['album'] as String?,
      artworkPath: mappedArtworkPath ?? legacyArtworkDataUri,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory LocalTrackMetadata.fromJson(String source) =>
      LocalTrackMetadata.fromMap(
        jsonDecode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'LocalTrackMetadata(title: $title, artist: $artist, album: $album, artworkPath: $artworkPath)';
  }
}
