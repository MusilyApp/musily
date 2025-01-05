// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class CreatePlaylistDTO {
  final String title;
  final String? id;
  final List<TrackEntity> tracks;

  CreatePlaylistDTO({
    required this.title,
    this.id,
    this.tracks = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'id': id,
      'tracks': tracks.map((x) => TrackModel.toMap(x)).toList(),
    };
  }

  factory CreatePlaylistDTO.fromMap(Map<String, dynamic> map) {
    return CreatePlaylistDTO(
      title: map['title'] as String,
      id: map['id'] != null ? map['id'] as String : null,
      tracks: List<TrackEntity>.from(
        (map['tracks'] as List<int>).map<TrackEntity>(
          (x) => TrackModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatePlaylistDTO.fromJson(String source) =>
      CreatePlaylistDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
