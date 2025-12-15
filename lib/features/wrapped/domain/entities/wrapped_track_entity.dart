import 'dart:convert';

class WrappedTrackEntity {
  final String id;
  final String name;
  final String artistName;
  final String? artistId;
  final String imageHigh;
  final String imageLow;

  const WrappedTrackEntity({
    required this.id,
    required this.name,
    required this.artistName,
    required this.artistId,
    required this.imageHigh,
    required this.imageLow,
  });

  factory WrappedTrackEntity.fromMap(Map<String, dynamic> json) {
    return WrappedTrackEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      artistName: json['artistName'] as String,
      artistId: json['artistId'] as String?,
      imageHigh: json['imageHigh'] as String? ?? '',
      imageLow: json['imageLow'] as String? ?? '',
    );
  }

  factory WrappedTrackEntity.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return WrappedTrackEntity.fromMap(map);
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
