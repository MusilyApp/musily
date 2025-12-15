import 'dart:convert';

class WrappedAlbumEntity {
  final String id;
  final String name;
  final String artistName;
  final String? artistId;
  final String imageHigh;
  final String imageLow;

  const WrappedAlbumEntity({
    required this.id,
    required this.name,
    required this.artistName,
    required this.artistId,
    required this.imageHigh,
    required this.imageLow,
  });

  factory WrappedAlbumEntity.fromMap(Map<String, dynamic> map) {
    return WrappedAlbumEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      artistName: map['artistName'] as String? ?? 'Unknown Artist',
      artistId: map['artistId'] as String?,
      imageHigh: map['imageHigh'] as String? ?? '',
      imageLow: map['imageLow'] as String? ?? '',
    );
  }

  factory WrappedAlbumEntity.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return WrappedAlbumEntity.fromMap(map);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'artistName': artistName,
      'artistId': artistId,
      'imageHigh': imageHigh,
      'imageLow': imageLow,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
