import 'dart:async';
import 'dart:developer';

import 'package:musily/core/data/database/wrapped_stats_database.dart';
import 'package:musily/core/data/repositories/musily_repository_impl.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_album_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_artist_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_track_entity.dart';

class PlaybackHistoryService {
  static final PlaybackHistoryService _instance =
      PlaybackHistoryService._internal();
  factory PlaybackHistoryService() => _instance;
  PlaybackHistoryService._internal();

  final _statsDatabase = WrappedStatsDatabase.instance;

  String? _currentTrackId;
  String? _currentTrackJson;
  String? _currentAlbumId;
  String? _currentAlbumJson;
  String? _currentArtistId;
  String? _currentArtistJson;
  int _currentSecondsPlayed = 0;
  int _lastSavedSeconds = 0;
  bool _playCountedForCurrentTrack = false;

  Timer? _updateTimer;
  DateTime? _trackStartTime;
  final MusilyRepository musilyRepository = MusilyRepositoryImpl();

  final artistCache = <String, ArtistEntity>{};

  bool _isValidTrackData(TrackEntity track) {
    if (track.id.isEmpty || track.title.isEmpty) {
      return false;
    }
    if (track.artist.id.isEmpty || track.artist.name.isEmpty) {
      return false;
    }
    if (track.album.id.isEmpty || track.album.title.isEmpty) {
      return false;
    }
    return true;
  }

  Future<ArtistEntity?> loadAndCacheArtist(String artistId) async {
    if (!artistCache.containsKey(artistId)) {
      final artistEntity = await musilyRepository.getArtist(artistId);
      if (artistEntity != null) {
        artistCache[artistId] = artistEntity;
      }
    }
    return artistCache[artistId];
  }

  Future<void> startTracking(TrackEntity track) async {
    try {
      if (!_isValidTrackData(track)) {
        log('[PlaybackHistoryService] ⚠️ Invalid track data - skipping tracking');
        return;
      }

      log('[PlaybackHistoryService] 🎵 Starting tracking: ${track.title} by ${track.artist.name}');

      await _saveCurrentEntry();

      _trackStartTime = DateTime.now();

      final artist = await loadAndCacheArtist(track.artist.id);

      final wrappedTrackEntity = WrappedTrackEntity(
        id: track.id,
        name: track.title,
        artistName: track.artist.name,
        artistId: track.artist.id,
        imageHigh: track.highResImg ?? '',
        imageLow: track.lowResImg ?? '',
      );
      final wrappedArtistEntity = WrappedArtistEntity(
        id: track.artist.id,
        name: track.artist.name,
        imageHigh: artist?.highResImg ?? '',
        imageLow: artist?.lowResImg ?? '',
      );
      final wrappedAlbumEntity = WrappedAlbumEntity(
        id: track.album.id,
        name: track.album.title,
        artistName: track.artist.name,
        artistId: track.artist.id,
        imageHigh: track.highResImg ?? '',
        imageLow: track.lowResImg ?? '',
      );

      _currentTrackId = track.id;
      _currentTrackJson = wrappedTrackEntity.toJson();
      _currentAlbumId = track.album.id;
      _currentAlbumJson = wrappedAlbumEntity.toJson();
      _currentArtistId = track.artist.id;
      _currentArtistJson = wrappedArtistEntity.toJson();
      _currentSecondsPlayed = 0;
      _lastSavedSeconds = 0;
      _playCountedForCurrentTrack = false;

      log('[PlaybackHistoryService] ✅ New entry created at $_trackStartTime');

      _startUpdateTimer();
    } catch (e, stackTrace) {
      log(
        '[PlaybackHistoryService] Error starting tracking',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void updateProgress(Duration position) {
    if (_currentTrackId != null && _trackStartTime != null) {
      final oldSeconds = _currentSecondsPlayed;
      _currentSecondsPlayed = position.inSeconds;

      if (oldSeconds != position.inSeconds) {
        log('[PlaybackHistoryService] ⏱️  Progress updated: ${position.inSeconds}s');
      }
    }
  }

  Future<void> stopTracking() async {
    try {
      log('[PlaybackHistoryService] ⏹️  Stopping tracking');
      await _saveCurrentEntry();
      _stopUpdateTimer();
      _currentTrackId = null;
      _currentTrackJson = null;
      _currentAlbumId = null;
      _currentAlbumJson = null;
      _currentArtistId = null;
      _currentArtistJson = null;
      _currentSecondsPlayed = 0;
      _lastSavedSeconds = 0;
      _playCountedForCurrentTrack = false;
      _trackStartTime = null;
      log('[PlaybackHistoryService] ✅ Tracking stopped');
    } catch (e, stackTrace) {
      log(
        '[PlaybackHistoryService] Error stopping tracking',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> pauseTracking() async {
    try {
      log('[PlaybackHistoryService] ⏸️  Pausing tracking');
      await _saveCurrentEntry();
      _stopUpdateTimer();
      log('[PlaybackHistoryService] ✅ Tracking paused');
    } catch (e, stackTrace) {
      log(
        '[PlaybackHistoryService] Error pausing tracking',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void resumeTracking() {
    if (_currentTrackId != null) {
      log('[PlaybackHistoryService] ▶️  Resuming tracking');
      _startUpdateTimer();
      log('[PlaybackHistoryService] ✅ Tracking resumed');
    }
  }

  void _startUpdateTimer() {
    _stopUpdateTimer();
    log('[PlaybackHistoryService] ⏰ Timer started (saves every 10s)');
    _updateTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _saveCurrentEntry(),
    );
  }

  void _stopUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  Future<void> _saveCurrentEntry() async {
    if (_currentTrackId == null) {
      log('[PlaybackHistoryService] ⚠️  No entry to save');
      return;
    }

    if (_currentSecondsPlayed < 3) {
      log('[PlaybackHistoryService] ⚠️  Entry not saved: only ${_currentSecondsPlayed}s played (min: 3s)');
      return;
    }

    final secondsDelta = _currentSecondsPlayed - _lastSavedSeconds;
    if (secondsDelta <= 0 && _playCountedForCurrentTrack) {
      log('[PlaybackHistoryService] ⚠️  No new seconds to save');
      return;
    }

    try {
      final isFirstSave = !_playCountedForCurrentTrack;

      log('[PlaybackHistoryService] 💾 Saving stats: ${secondsDelta}s delta (total: ${_currentSecondsPlayed}s), isFirstSave: $isFirstSave');

      await _statsDatabase.recordPlayback(
        trackId: _currentTrackId!,
        trackJson: _currentTrackJson!,
        albumId: _currentAlbumId!,
        albumJson: _currentAlbumJson!,
        artistId: _currentArtistId!,
        artistJson: _currentArtistJson!,
        secondsPlayed: secondsDelta,
        incrementPlayCount: isFirstSave,
      );

      _lastSavedSeconds = _currentSecondsPlayed;
      _playCountedForCurrentTrack = true;

      log('[PlaybackHistoryService] ✅ Stats saved successfully!');
    } catch (e, stackTrace) {
      log(
        '[PlaybackHistoryService] Error saving stats',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> forceSave() async {
    await _saveCurrentEntry();
  }

  void dispose() {
    _stopUpdateTimer();
    _currentTrackId = null;
    _currentTrackJson = null;
    _currentAlbumId = null;
    _currentAlbumJson = null;
    _currentArtistId = null;
    _currentArtistJson = null;
    _currentSecondsPlayed = 0;
    _lastSavedSeconds = 0;
    _playCountedForCurrentTrack = false;
    _trackStartTime = null;
  }
}
