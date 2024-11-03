import 'dart:convert';

class CreatePlaylistDTO {
  final String title;

  CreatePlaylistDTO({required this.title});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
    };
  }

  factory CreatePlaylistDTO.fromMap(Map<String, dynamic> map) {
    return CreatePlaylistDTO(
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatePlaylistDTO.fromJson(String source) =>
      CreatePlaylistDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
