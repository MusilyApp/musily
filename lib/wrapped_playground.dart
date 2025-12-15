import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:musily/core/data/database/database.dart';
import 'package:musily/core/data/database/wrapped_stats_database.dart';
import 'package:musily/core/data/datasources/youtube_datasource.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_album_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_artist_entity.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_track_entity.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/most_listened_album_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/most_listened_artist_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/most_listened_track_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/thank_you_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/top_albums_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/top_artists_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/top_tracks_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/total_albums_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/total_artists_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/total_minutes_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/total_tracks_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/widgets/pages/welcome_wrapped_widget.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Database().init();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      cardTheme: const CardTheme(
        color: Color(0xFF1A1A1A),
        elevation: 0,
      ),
    ),
    home: const WrappedPlayground(),
  ));
}

class WrappedPlayground extends StatefulWidget {
  const WrappedPlayground({super.key});

  @override
  State<WrappedPlayground> createState() => _WrappedPlaygroundState();
}

class _WrappedPlaygroundState extends State<WrappedPlayground> {
  final _db = WrappedStatsDatabase.instance;
  final _ytDatasource = YoutubeDatasource();
  WrappedEntity? _currentWrapped;
  bool _loading = false;
  String? _error;
  int _currentStoryIndex = 0;
  List<Widget> _storyPages = [];
  int _selectedYear = DateTime.now().year;
  final _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _searching = false;
  String _searchType = 'track';
  String _currentSeed = 'Musily2025';
  WrappedStyle _selectedStyle = WrappedStyle.tech;
  int _selectedNavIndex = 0;
  final _customSeedController = TextEditingController(text: 'Musily2025');

  double _previewScale = 1.0;
  final _previewPresets = [
    ('Story', 9 / 16, 'Instagram/TikTok'),
    ('Square', 1.0, 'Feed'),
    ('Landscape', 16 / 9, 'YouTube'),
    ('Mobile', 9 / 19.5, 'Full Screen'),
  ];
  int _selectedPresetIndex = 3;
  double _customAspectRatio = 9 / 19.5;

  final _seedColors = [
    (const Color(0xFF764AF1), 'Deep Purple'),
    (const Color(0xFF38BDF8), 'Sky Blue'),
    (const Color(0xFF22C55E), 'Emerald'),
    (const Color(0xFFEF4444), 'Red'),
    (const Color(0xFFF97316), 'Orange'),
    (const Color(0xFFEC4899), 'Pink'),
    (const Color(0xFF8B5CF6), 'Violet'),
    (const Color(0xFF06B6D4), 'Cyan'),
    (const Color(0xFFFACC15), 'Yellow'),
    (const Color(0xFF14B8A6), 'Teal'),
    (const Color(0xFFF43F5E), 'Rose'),
    (const Color(0xFF6366F1), 'Indigo'),
  ];
  int _selectedSeedColorIndex = 0;
  Brightness _selectedBrightness = Brightness.dark;

  @override
  void initState() {
    super.initState();
    _initYoutube();
    _checkForExistingWrapped();
  }

  Future<void> _initYoutube() async {
    try {
      await _ytDatasource.initialize();
    } catch (e, stackTrace) {
      dev.log('[Playground] Failed to initialize YouTube: $e',
          error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _checkForExistingWrapped() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final wrapped = await _db.getWrappedByYear(_selectedYear);
      setState(() {
        _currentWrapped = wrapped;
        _loading = false;
        if (wrapped != null) {
          _currentSeed = wrapped.visualSeed;
          _customSeedController.text = wrapped.visualSeed;
          _buildStoryPages();
        }
      });
    } catch (e, stackTrace) {
      dev.log('[Playground] Failed to check for existing wrapped: $e',
          error: e, stackTrace: stackTrace);
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _generateWrapped() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final start = DateTime(_selectedYear, 1, 1);
      final end = DateTime(_selectedYear, 12, 31, 23, 59, 59);

      final wrapped = WrappedEntity(
        id: '${_selectedYear}_wrapped',
        visualSeed: _currentSeed,
        rangeStart: start,
        rangeEnd: end,
        totalMinutesListened: await _db.getTotalMinutes(start, end),
        totalTracksListened: await _db.getTotalPlays(start, end),
        totalAlbumsListened: await _db.getDistinctAlbumsCount(start, end),
        totalArtistsListened: await _db.getDistinctArtistsCount(start, end),
        topTracks: await _db.getTopTracks(start, end, 5),
        topAlbums: await _db.getTopAlbums(start, end, 5),
        topArtists: await _db.getTopArtists(start, end, 5),
        mostListenedTrack: await _db.getMostListenedTrack(start, end),
        mostListenedAlbum: await _db.getMostListenedAlbum(start, end),
        mostListenedArtist: await _db.getMostListenedArtist(start, end),
        mostListenedTrackMinutes: await _db
            .getMostListenedTrack(start, end)
            .then((t) =>
                t != null ? _db.getTrackTotalMinutes(start, end, t.id) : null),
        mostListenedAlbumMinutes: await _db
            .getMostListenedAlbum(start, end)
            .then((a) =>
                a != null ? _db.getAlbumTotalMinutes(start, end, a.id) : null),
        mostListenedArtistMinutes: await _db
            .getMostListenedArtist(start, end)
            .then((a) =>
                a != null ? _db.getArtistTotalMinutes(start, end, a.id) : null),
        mostListenedTrackPlays: await _db.getMostListenedTrack(start, end).then(
            (t) => t != null ? _db.getTrackPlayCount(start, end, t.id) : null),
        mostListenedAlbumPlays: await _db.getMostListenedAlbum(start, end).then(
            (a) => a != null ? _db.getAlbumPlayCount(start, end, a.id) : null),
        mostListenedArtistPlays: await _db
            .getMostListenedArtist(start, end)
            .then((a) =>
                a != null ? _db.getArtistPlayCount(start, end, a.id) : null),
      );

      await _db.saveWrappedEntity(wrapped);
      setState(() {
        _currentWrapped = wrapped;
        _loading = false;
        _buildStoryPages();
      });
    } catch (e, stackTrace) {
      dev.log('[Playground] Failed to generate wrapped: $e',
          error: e, stackTrace: stackTrace);
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _buildStoryPages() {
    if (_currentWrapped == null) {
      _storyPages = [];
      return;
    }
    final wrapped = _currentWrapped!;
    final selectedSeedColor = _seedColors[_selectedSeedColorIndex].$1;
    final palette = WrappedPalette.fromSeed(selectedSeedColor,
        brightness: _selectedBrightness);
    final theme = WrappedTheme(
      palette: palette,
      style: _selectedStyle,
      seed: _currentSeed.hashCode,
    );
    _storyPages = [
      WelcomeWrappedWidget(wrapped: wrapped, theme: theme),
      TotalMinutesWrappedWidget(wrapped: wrapped, theme: theme),
      TotalTracksWrappedWidget(wrapped: wrapped, theme: theme),
      if (wrapped.topTracks.isNotEmpty)
        TopTracksWrappedWidget(wrapped: wrapped, theme: theme),
      if (wrapped.mostListenedTrack != null)
        MostListenedTrackWrappedWidget(wrapped: wrapped, theme: theme),
      TotalAlbumsWrappedWidget(wrapped: wrapped, theme: theme),
      if (wrapped.topAlbums.isNotEmpty)
        TopAlbumsWrappedWidget(wrapped: wrapped, theme: theme),
      if (wrapped.mostListenedAlbum != null)
        MostListenedAlbumWrappedWidget(wrapped: wrapped, theme: theme),
      TotalArtistsWrappedWidget(wrapped: wrapped, theme: theme),
      if (wrapped.topArtists.isNotEmpty)
        TopArtistsWrappedWidget(wrapped: wrapped, theme: theme),
      if (wrapped.mostListenedArtist != null)
        MostListenedArtistWrappedWidget(wrapped: wrapped, theme: theme),
      ThankYouWrappedWidget(wrapped: wrapped, theme: theme),
    ];
    if (_currentStoryIndex >= _storyPages.length) _currentStoryIndex = 0;
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) return;
    setState(() {
      _searching = true;
      _searchResults = [];
    });
    try {
      if (_searchType == 'track') {
        _searchResults = await _ytDatasource.searchTracks(query);
      } else if (_searchType == 'album') {
        _searchResults = await _ytDatasource.searchAlbums(query);
      } else {
        _searchResults = await _ytDatasource.searchArtists(query);
      }
      setState(() => _searching = false);
    } catch (e, stackTrace) {
      dev.log('[Playground] Failed to search: $e',
          error: e, stackTrace: stackTrace);
      setState(() {
        _searching = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _addToWrapped(
      dynamic item, int month, int year, int minutes, int plays) async {
    final seconds = minutes * 60;
    final dateToUse = DateTime(year, month, 15);

    try {
      if (item is TrackEntity) {
        String artistImageHigh = '';
        String artistImageLow = '';
        String albumImageHigh = '';
        String albumImageLow = '';

        if (item.artist.id.isNotEmpty) {
          try {
            final artist = await _ytDatasource.getArtist(item.artist.id);
            if (artist != null) {
              artistImageHigh = artist.highResImg ?? '';
              artistImageLow = artist.lowResImg ?? '';
            }
          } catch (e, stackTrace) {
            dev.log('[Playground] Failed to fetch artist by id: $e',
                error: e, stackTrace: stackTrace);
          }
        }

        if (item.album.id.isNotEmpty) {
          try {
            final album = await _ytDatasource.getAlbum(item.album.id);
            if (album != null) {
              albumImageHigh = album.highResImg ?? '';
              albumImageLow = album.lowResImg ?? '';
            }
          } catch (e, stackTrace) {
            dev.log('[Playground] Failed to fetch album by id: $e',
                error: e, stackTrace: stackTrace);
          }
        }

        final wrappedTrack = WrappedTrackEntity(
          id: item.id,
          name: item.title,
          artistName: item.artist.name,
          artistId: item.artist.id,
          imageHigh: item.highResImg ?? '',
          imageLow: item.lowResImg ?? '',
        );
        final trackJson = wrappedTrack.toJson();
        final wrappedAlbum = WrappedAlbumEntity(
          id: item.album.id,
          name: item.album.title,
          artistName: item.artist.name,
          artistId: item.artist.id,
          imageHigh: albumImageHigh,
          imageLow: albumImageLow,
        );
        final albumJson = wrappedAlbum.toJson();
        final wrappedArtist = WrappedArtistEntity(
          id: item.artist.id,
          name: item.artist.name,
          imageHigh: artistImageHigh,
          imageLow: artistImageLow,
        );
        final artistJson = wrappedArtist.toJson();
        for (var i = 0; i < plays; i++) {
          await _db.recordPlayback(
            trackId: item.id,
            trackJson: trackJson,
            albumId: item.album.id,
            albumJson: albumJson,
            artistId: item.artist.id,
            artistJson: artistJson,
            secondsPlayed: i == 0 ? seconds : 0,
            incrementPlayCount: true,
            playedAt: dateToUse,
          );
        }
      } else if (item is AlbumEntity) {
        String artistImageHigh = '';
        String artistImageLow = '';

        if (item.artist.id.isNotEmpty) {
          try {
            final artist = await _ytDatasource.getArtist(item.artist.id);
            if (artist != null) {
              artistImageHigh = artist.highResImg ?? '';
              artistImageLow = artist.lowResImg ?? '';
            }
          } catch (e, stackTrace) {
            dev.log('[Playground] Failed to fetch artist by id: $e',
                error: e, stackTrace: stackTrace);
          }
        }

        final wrappedAlbum = WrappedAlbumEntity(
          id: item.id,
          name: item.title,
          artistName: item.artist.name,
          artistId: item.artist.id,
          imageHigh: item.highResImg ?? '',
          imageLow: item.lowResImg ?? '',
        );
        final albumJson = wrappedAlbum.toJson();
        final wrappedArtist = WrappedArtistEntity(
          id: item.artist.id,
          name: item.artist.name,
          imageHigh: artistImageHigh,
          imageLow: artistImageLow,
        );
        final artistJson = wrappedArtist.toJson();
        for (var i = 0; i < plays; i++) {
          await _db.recordPlayback(
            trackId: 'dummy_track_${item.id}',
            trackJson: jsonEncode({
              'id': 'dummy_track_${item.id}',
              'name': item.title,
              'artistName': item.artist.name,
              'artistId': item.artist.id,
              'imageHigh': '',
              'imageLow': '',
            }),
            albumId: item.id,
            albumJson: albumJson,
            artistId: item.artist.id,
            artistJson: artistJson,
            secondsPlayed: i == 0 ? seconds : 0,
            incrementPlayCount: true,
            playedAt: dateToUse,
          );
        }
      } else if (item is ArtistEntity) {
        final wrappedArtist = WrappedArtistEntity(
          id: item.id,
          name: item.name,
          imageHigh: item.highResImg ?? '',
          imageLow: item.lowResImg ?? '',
        );
        final artistJson = wrappedArtist.toJson();
        for (var i = 0; i < plays; i++) {
          await _db.recordPlayback(
            trackId: 'dummy_track_${item.id}',
            trackJson: jsonEncode({
              'id': 'dummy_track_${item.id}',
              'name': item.name,
              'artistName': item.name,
              'artistId': item.id,
              'imageHigh': '',
              'imageLow': '',
            }),
            albumId: 'dummy_album_${item.id}',
            albumJson: jsonEncode({
              'id': 'dummy_album_${item.id}',
              'name': item.name,
              'artistName': item.name,
              'artistId': item.id,
              'imageHigh': '',
              'imageLow': '',
            }),
            artistId: item.id,
            artistJson: artistJson,
            secondsPlayed: i == 0 ? seconds : 0,
            incrementPlayCount: true,
            playedAt: dateToUse,
          );
        }
      }
    } catch (e, stackTrace) {
      dev.log('[Playground] Failed to add to wrapped: $e',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(LucideIcons.sparkles, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 32),
          _buildNavItem(0, LucideIcons.layoutDashboard, 'Dashboard'),
          _buildNavItem(1, LucideIcons.palette, 'Appearance'),
          _buildNavItem(2, LucideIcons.plus, 'Add'),
          _buildNavItem(3, LucideIcons.settings, 'Settings'),
          const Spacer(),
          _buildNavItem(4, LucideIcons.trash2, 'Clear', isDestructive: true),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String tooltip,
      {bool isDestructive = false}) {
    final isSelected = _selectedNavIndex == index;
    return Tooltip(
      message: tooltip,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 500),
      child: InkWell(
        onTap: () {
          if (index == 4) {
            _showDeleteAllDialog();
          } else {
            setState(() => _selectedNavIndex = index);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF8B5CF6).withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isDestructive
                ? Colors.red.withValues(alpha: 0.7)
                : isSelected
                    ? const Color(0xFF8B5CF6)
                    : Colors.white.withValues(alpha: 0.5),
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildLeftPanel(),
        ),
        Container(
          width: 400,
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            border: Border(
              left: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
          ),
          child: _buildPreviewPanel(),
        ),
      ],
    );
  }

  Widget _buildLeftPanel() {
    switch (_selectedNavIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildAppearance();
      case 2:
        return _buildAddData();
      case 3:
        return _buildSettings();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const Spacer(),
              _buildYearSelector(),
            ],
          ),
          const SizedBox(height: 32),
          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_error != null)
            _buildErrorCard()
          else if (_currentWrapped == null)
            _buildEmptyState()
          else
            _buildWrappedStats(),
        ],
      ),
    );
  }

  Widget _buildYearSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedYear--;
                _currentWrapped = null;
                _storyPages = [];
              });
              _checkForExistingWrapped();
            },
            icon: Icon(LucideIcons.chevronLeft,
                size: 18, color: Colors.white.withValues(alpha: 0.7)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$_selectedYear',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedYear++;
                _currentWrapped = null;
                _storyPages = [];
              });
              _checkForExistingWrapped();
            },
            icon: Icon(LucideIcons.chevronRight,
                size: 18, color: Colors.white.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.triangleAlert,
              color: Colors.red.withValues(alpha: 0.8)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Error loading',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(_error!,
                    style: TextStyle(
                        color: Colors.red.withValues(alpha: 0.7),
                        fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(LucideIcons.music,
                  size: 36,
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 24),
            Text(
              'No Wrapped for $_selectedYear',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add playback data and generate your wrapped',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _generateWrapped,
              icon: const Icon(LucideIcons.sparkles, size: 18),
              label: const Text('Generate Wrapped'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWrappedStats() {
    final wrapped = _currentWrapped!;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: _buildStatCard(
                        'Minutes',
                        '${wrapped.totalMinutesListened}',
                        LucideIcons.clock,
                        const Color(0xFF8B5CF6))),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildStatCard(
                        'Tracks',
                        '${wrapped.totalTracksListened}',
                        LucideIcons.music,
                        const Color(0xFFEC4899))),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildStatCard(
                        'Albums',
                        '${wrapped.totalAlbumsListened}',
                        LucideIcons.disc,
                        const Color(0xFF06B6D4))),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildStatCard(
                        'Artists',
                        '${wrapped.totalArtistsListened}',
                        LucideIcons.mic,
                        const Color(0xFF10B981))),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generateWrapped,
                    icon: const Icon(LucideIcons.refreshCw, size: 18),
                    label: const Text('Regenerate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await _db.deleteWrappedByYear(_selectedYear);
                      setState(() {
                        _currentWrapped = null;
                        _storyPages = [];
                      });
                    },
                    icon: const Icon(LucideIcons.trash2,
                        size: 18, color: Colors.red),
                    label: const Text('Delete',
                        style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side:
                          BorderSide(color: Colors.red.withValues(alpha: 0.3)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildPreviewDimensionsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewDimensionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(LucideIcons.maximize2,
                    size: 20, color: Color(0xFFF59E0B)),
              ),
              const SizedBox(width: 16),
              Text(
                'Preview Dimensions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Format',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(_previewPresets.length, (index) {
              final preset = _previewPresets[index];
              final isSelected = _selectedPresetIndex == index;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: index < _previewPresets.length - 1 ? 8 : 0),
                  child: Tooltip(
                    message: preset.$3,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPresetIndex = index;
                          _customAspectRatio = preset.$2;
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF8B5CF6).withValues(alpha: 0.2)
                              : const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF8B5CF6)
                                : Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              preset.$1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? const Color(0xFF8B5CF6)
                                    : Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              preset.$3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(LucideIcons.zoomIn,
                  size: 16, color: Colors.white.withValues(alpha: 0.5)),
              const SizedBox(width: 8),
              Text(
                'Scale',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${(_previewScale * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              activeTrackColor: const Color(0xFF8B5CF6),
              inactiveTrackColor: const Color(0xFF2A2A2A),
              thumbColor: const Color(0xFF8B5CF6),
              overlayColor: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _previewScale,
              min: 0.3,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  _previewScale = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 13, color: Colors.white.withValues(alpha: 0.5))),
        ],
      ),
    );
  }

  Widget _buildAppearance() {
    final selectedSeedColor = _seedColors[_selectedSeedColorIndex].$1;
    final currentPalette = WrappedPalette.fromSeed(selectedSeedColor,
        brightness: _selectedBrightness);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appearance',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize your wrapped look',
            style: TextStyle(
                fontSize: 14, color: Colors.white.withValues(alpha: 0.4)),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Visual Style'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: WrappedStyle.values.map((style) {
                      final isSelected = _selectedStyle == style;
                      final isDarkOnly = style.requiresDarkMode;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedStyle = style;

                            if (style.requiresDarkMode) {
                              _selectedBrightness = Brightness.dark;
                            }
                            if (_currentWrapped != null) _buildStoryPages();
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF8B5CF6)
                                : const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF8B5CF6)
                                  : Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                style.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.6),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              if (isDarkOnly) ...[
                                const SizedBox(width: 6),
                                Icon(
                                  LucideIcons.moon,
                                  size: 12,
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.8)
                                      : Colors.white.withValues(alpha: 0.4),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Seed Color (Material You)'),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: _seedColors.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedSeedColorIndex == index;
                      final seedColor = _seedColors[index].$1;
                      final seedName = _seedColors[index].$2;
                      return Tooltip(
                        message: seedName,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedSeedColorIndex = index;
                              if (_currentWrapped != null) _buildStoryPages();
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: seedColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: seedColor.withValues(alpha: 0.5),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      )
                                    ]
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(LucideIcons.check,
                                    color: Colors.white, size: 20)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Brightness'),
                  const SizedBox(height: 16),
                  if (_selectedStyle.requiresDarkMode)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.amber.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.info,
                              size: 16, color: Colors.amber.shade300),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'The style "${_selectedStyle.name}" requires dark mode',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber.shade200,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedBrightness = Brightness.dark;
                              if (_currentWrapped != null) _buildStoryPages();
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: _selectedBrightness == Brightness.dark
                                  ? const Color(0xFF1A1A1A)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedBrightness == Brightness.dark
                                    ? const Color(0xFF8B5CF6)
                                    : Colors.white.withValues(alpha: 0.1),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.moon,
                                    size: 18,
                                    color: _selectedBrightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.5)),
                                const SizedBox(width: 8),
                                Text(
                                  'Dark',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: _selectedBrightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: IgnorePointer(
                          ignoring: _selectedStyle.requiresDarkMode,
                          child: Opacity(
                            opacity:
                                _selectedStyle.requiresDarkMode ? 0.4 : 1.0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedBrightness = Brightness.light;
                                  if (_currentWrapped != null) {
                                    _buildStoryPages();
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: _selectedBrightness == Brightness.light
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _selectedBrightness ==
                                            Brightness.light
                                        ? const Color(0xFF8B5CF6)
                                        : Colors.white.withValues(alpha: 0.1),
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.sun,
                                        size: 18,
                                        color: _selectedBrightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white
                                                .withValues(alpha: 0.5)),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Light',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: _selectedBrightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white
                                                .withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Palette Preview'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: _buildColorPreview(
                                    'Background', currentPalette.background)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _buildColorPreview(
                                    'Primary', currentPalette.primary)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: _buildColorPreview(
                                    'Secondary', currentPalette.secondary)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _buildColorPreview(
                                    'Accent', currentPalette.accent)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildColorPreview('Text', currentPalette.text),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Custom Seed'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _customSeedController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type any text...',
                      hintStyle:
                          TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                      filled: true,
                      fillColor: const Color(0xFF1A1A1A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(LucideIcons.hash,
                          color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _currentSeed = value;
                        if (_currentWrapped != null) _buildStoryPages();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The seed is used for random layout variations',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.3)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPreview(String label, Color color) {
    final hexCode =
        '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color.computeLuminance() > 0.5
                  ? Colors.black54
                  : Colors.white54,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            hexCode,
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'monospace',
              color: color.computeLuminance() > 0.5
                  ? Colors.black38
                  : Colors.white38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white.withValues(alpha: 0.6),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildAddData() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Data',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search and add tracks, albums or artists to your wrapped',
            style: TextStyle(
                fontSize: 14, color: Colors.white.withValues(alpha: 0.4)),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildSearchTypeButton('track', 'Tracks', LucideIcons.music),
              const SizedBox(width: 8),
              _buildSearchTypeButton('album', 'Albums', LucideIcons.disc),
              const SizedBox(width: 8),
              _buildSearchTypeButton('artist', 'Artists', LucideIcons.mic),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(LucideIcons.search,
                  color: Colors.white.withValues(alpha: 0.3)),
              suffixIcon: _searching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  : null,
            ),
            onSubmitted: _search,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.search,
                            size: 48,
                            color: Colors.white.withValues(alpha: 0.1)),
                        const SizedBox(height: 16),
                        Text(
                          'Search to find content',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.3)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (ctx, index) {
                      final item = _searchResults[index];
                      return _buildSearchResultItem(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTypeButton(String type, String label, IconData icon) {
    final isSelected = _searchType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() {
          _searchType = type;
          _searchResults = [];
        }),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF8B5CF6).withValues(alpha: 0.2)
                : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF8B5CF6)
                  : Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: isSelected
                      ? const Color(0xFF8B5CF6)
                      : Colors.white.withValues(alpha: 0.5)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF8B5CF6)
                      : Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(dynamic item) {
    String title = '';
    String subtitle = '';
    String? imageUrl;

    if (item is TrackEntity) {
      title = item.title;
      subtitle = item.artist.name;
      imageUrl = item.lowResImg;
    } else if (item is AlbumEntity) {
      title = item.title;
      subtitle = item.artist.name;
      imageUrl = item.lowResImg;
    } else if (item is ArtistEntity) {
      title = item.name;
      imageUrl = item.lowResImg;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageUrl != null
              ? Image.network(imageUrl,
                  width: 48, height: 48, fit: BoxFit.cover)
              : Container(
                  width: 48,
                  height: 48,
                  color: const Color(0xFF2A2A2A),
                  child: Icon(LucideIcons.music,
                      color: Colors.white.withValues(alpha: 0.3)),
                ),
        ),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
        subtitle: subtitle.isNotEmpty
            ? Text(subtitle,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5), fontSize: 13))
            : null,
        trailing: IconButton(
          onPressed: () => _showAddDialog(item),
          icon: const Icon(LucideIcons.plus, color: Color(0xFF8B5CF6)),
          tooltip: 'Add',
        ),
      ),
    );
  }

  void _showAddDialog(dynamic item) {
    final monthController =
        TextEditingController(text: '${DateTime.now().month}');
    final yearController = TextEditingController(text: '$_selectedYear');
    final minutesController = TextEditingController(text: '30');
    final playsController = TextEditingController(text: '10');

    String getTitle() {
      if (item is TrackEntity) return item.title;
      if (item is AlbumEntity) return item.title;
      if (item is ArtistEntity) return item.name;
      return '';
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add "${getTitle()}"',
            style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: monthController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Month',
                      labelStyle:
                          TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: yearController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Year',
                      labelStyle:
                          TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minutesController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Minutes',
                      labelStyle:
                          TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: playsController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Plays',
                      labelStyle:
                          TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
          ),
          ElevatedButton(
            onPressed: () async {
              final month = int.tryParse(monthController.text) ?? 1;
              final year = int.tryParse(yearController.text) ?? _selectedYear;
              final minutes = int.tryParse(minutesController.text) ?? 30;
              final plays = int.tryParse(playsController.text) ?? 10;

              Navigator.pop(ctx);

              try {
                await _addToWrapped(item, month, year, minutes, plays);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Added successfully!'),
                      backgroundColor: const Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.info,
                        size: 20, color: Colors.white.withValues(alpha: 0.5)),
                    const SizedBox(width: 12),
                    Text(
                      'About Playground',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'This is a testing environment for the Musily Wrapped feature. '
                  'You can add dummy playback data, customize the appearance '
                  'and preview how your wrapped will look.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.5),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(LucideIcons.triangleAlert, color: Colors.red),
            SizedBox(width: 12),
            Text('Delete All Data', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          'This action will delete ALL wrapped data, including statistics and saved wrappeds. This action cannot be undone.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _db.clearAllData();
              setState(() {
                _currentWrapped = null;
                _storyPages = [];
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All data has been deleted'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewPanel() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: Colors.white.withValues(alpha: 0.05))),
          ),
          child: Row(
            children: [
              Text(
                'Preview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const Spacer(),
              if (_storyPages.isNotEmpty) ...[
                IconButton(
                  onPressed: _currentStoryIndex > 0
                      ? () => setState(() => _currentStoryIndex--)
                      : null,
                  icon: Icon(
                    LucideIcons.chevronLeft,
                    size: 18,
                    color: _currentStoryIndex > 0
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_currentStoryIndex + 1} / ${_storyPages.length}',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.6)),
                  ),
                ),
                IconButton(
                  onPressed: _currentStoryIndex < _storyPages.length - 1
                      ? () => setState(() => _currentStoryIndex++)
                      : null,
                  icon: Icon(
                    LucideIcons.chevronRight,
                    size: 18,
                    color: _currentStoryIndex < _storyPages.length - 1
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: _storyPages.isEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.image,
                          size: 48, color: Colors.white.withValues(alpha: 0.1)),
                      const SizedBox(height: 16),
                      Text(
                        'Generate a wrapped to\nview the preview',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3)),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final maxWidth = constraints.maxWidth * _previewScale;
                        final maxHeight = constraints.maxHeight * _previewScale;

                        double width, height;
                        if (_customAspectRatio < 1) {
                          height = maxHeight;
                          width = height * _customAspectRatio;
                          if (width > maxWidth) {
                            width = maxWidth;
                            height = width / _customAspectRatio;
                          }
                        } else {
                          width = maxWidth;
                          height = width / _customAspectRatio;
                          if (height > maxHeight) {
                            height = maxHeight;
                            width = height * _customAspectRatio;
                          }
                        }

                        return Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: _storyPages[_currentStoryIndex],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.info,
                  size: 12, color: Colors.white.withValues(alpha: 0.3)),
              const SizedBox(width: 6),
              Text(
                _getAspectRatioLabel(),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getAspectRatioLabel() {
    final preset = _previewPresets[_selectedPresetIndex];
    final ratio = preset.$2;
    if (ratio == 1.0) return '1:1 (${preset.$3})';
    if (ratio == 9 / 16) return '9:16 (${preset.$3})';
    if (ratio == 16 / 9) return '16:9 (${preset.$3})';
    if (ratio == 9 / 19.5) return '9:19.5 (${preset.$3})';
    return '${preset.$1} (${preset.$3})';
  }
}
