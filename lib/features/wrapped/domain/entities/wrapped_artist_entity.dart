import 'dart:convert';

class WrappedArtistEntity {
  final String id;
  final String name;
  final String imageHigh;
  final String imageLow;

  const WrappedArtistEntity({
    required this.id,
    required this.name,
    required this.imageHigh,
    required this.imageLow,
  });

  factory WrappedArtistEntity.fromMap(Map<String, dynamic> map) {
    return WrappedArtistEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      imageHigh: map['imageHigh'] as String? ?? '',
      imageLow: map['imageLow'] as String? ?? '',
    );
  }

  factory WrappedArtistEntity.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return WrappedArtistEntity.fromMap(map);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageHigh': imageHigh,
      'imageLow': imageLow,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
