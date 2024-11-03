import 'dart:convert';

class UpdatePlaylistDto {
  final String id;
  final String title;

  UpdatePlaylistDto({required this.id, required this.title});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
    };
  }

  factory UpdatePlaylistDto.fromMap(Map<String, dynamic> map) {
    return UpdatePlaylistDto(
      id: map['id'] as String,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdatePlaylistDto.fromJson(String source) =>
      UpdatePlaylistDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
