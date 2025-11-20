import 'dart:convert';

import 'package:musily/features/_library_module/domain/entities/local_library_playlist.dart';
import 'package:musily/features/_library_module/domain/entities/local_track_metadata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalLibraryService {
  static const _prefsKey = 'local_library_playlists';
  static const _metadataPrefsKey = 'local_library_track_metadata';

  Future<List<LocalLibraryPlaylist>> loadPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(LocalLibraryPlaylist.fromMap)
            .toList();
      }
      if (decoded is List<dynamic>) {
        return decoded
            .map(
              (item) => LocalLibraryPlaylist.fromMap(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();
      }
    } catch (_) {
      return [];
    }
    return [];
  }

  Future<void> savePlaylists(List<LocalLibraryPlaylist> playlists) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(playlists.map((e) => e.toMap()).toList());
    await prefs.setString(_prefsKey, payload);
  }

  Future<Map<String, LocalTrackMetadata>> loadTrackMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_metadataPrefsKey);
    if (raw == null || raw.isEmpty) {
      return {};
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded.map(
          (key, value) => MapEntry(
            key,
            LocalTrackMetadata.fromMap(
              Map<String, dynamic>.from(value as Map),
            ),
          ),
        );
      }
    } catch (_) {
      return {};
    }
    return {};
  }

  Future<void> saveTrackMetadata(
    Map<String, LocalTrackMetadata> metadata,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(
      metadata.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
    );
    await prefs.setString(_metadataPrefsKey, payload);
  }
}
