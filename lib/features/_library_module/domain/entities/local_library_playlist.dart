import 'dart:convert';

class LocalLibraryPlaylist {
  final String id;
  final String name;
  final String directoryPath;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int trackCount;

  const LocalLibraryPlaylist({
    required this.id,
    required this.name,
    required this.directoryPath,
    required this.createdAt,
    this.updatedAt,
    this.trackCount = 0,
  });

  LocalLibraryPlaylist copyWith({
    String? id,
    String? name,
    String? directoryPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? trackCount,
  }) {
    return LocalLibraryPlaylist(
      id: id ?? this.id,
      name: name ?? this.name,
      directoryPath: directoryPath ?? this.directoryPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      trackCount: trackCount ?? this.trackCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'directoryPath': directoryPath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'trackCount': trackCount,
    };
  }

  factory LocalLibraryPlaylist.fromMap(Map<String, dynamic> map) {
    return LocalLibraryPlaylist(
      id: map['id'] as String,
      name: map['name'] as String,
      directoryPath: map['directoryPath'] as String,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
      trackCount: (map['trackCount'] as num?)?.toInt() ?? 0,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory LocalLibraryPlaylist.fromJson(String source) =>
      LocalLibraryPlaylist.fromMap(
        jsonDecode(source) as Map<String, dynamic>,
      );
}
