import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/duration.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/widgets/download_button.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_button.dart';
import 'package:musily/features/player/domain/enums/musily_repeat_mode.dart';
import 'package:musily/features/player/domain/enums/player_mode.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/player/presenter/widgets/queue_widget.dart';
import 'package:musily/features/player/presenter/widgets/track_lyrics.dart';
import 'package:musily/features/player/presenter/widgets/sleep_timer_dialog.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:musily/features/track/presenter/widgets/track_options.dart';
import 'package:window_manager/window_manager.dart';

class DesktopFullPlayer extends StatefulWidget {
  final PlayerController playerController;
  final LibraryController libraryController;
  final DownloaderController downloaderController;
  final CoreController coreController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final VoidCallback? onClose;

  const DesktopFullPlayer({
    super.key,
    required this.playerController,
    required this.libraryController,
    required this.downloaderController,
    required this.coreController,
    required this.getPlayableItemUsecase,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getTrackUsecase,
    required this.getPlaylistUsecase,
    this.onClose,
  });

  @override
  State<DesktopFullPlayer> createState() => _DesktopFullPlayerState();
}

class _DesktopFullPlayerState extends State<DesktopFullPlayer> {
  Duration _seekDuration = Duration.zero;
  bool _useSeekDuration = false;
  double _previousVolume = 1.0;
  bool _isFullScreenActive = false;

  String _formatRemainingTime(DateTime endTime) {
    final now = DateTime.now();
    final remaining = endTime.difference(now);

    if (remaining.isNegative || remaining.inSeconds == 0) {
      return '0:00';
    }

    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    // Wait for widget to be fully built before entering fullscreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add a small delay to ensure everything is ready
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          _enterFullScreen();
        }
      });
    });
  }

  @override
  void dispose() {
    // Exit fullscreen - fire and forget since we can't await in dispose
    if (_isFullScreenActive) {
      _exitFullScreen().catchError((_) {
        // Ignore errors on dispose
      });
    }
    super.dispose();
  }

  Future<void> _enterFullScreen() async {
    if (!Platform.isLinux && !Platform.isWindows && !Platform.isMacOS) return;
    if (_isFullScreenActive) return;

    try {
      bool isVisible = await windowManager.isVisible();
      if (!isVisible) {
        // aguarda a janela estar visível
        await Future.delayed(const Duration(milliseconds: 500));
      }

      await windowManager.setFullScreen(true);
      if (mounted) {
        setState(() => _isFullScreenActive = true);
      }
    } catch (e, st) {
      debugPrint('Error entering fullscreen: $e\n$st');
    }
  }

  Future<void> _exitFullScreen() async {
    if (!Platform.isLinux && !Platform.isWindows && !Platform.isMacOS) {
      return;
    }

    if (!_isFullScreenActive) {
      return;
    }

    try {
      await windowManager.setFullScreen(false);
      _isFullScreenActive = false;
    } catch (e, stackTrace) {
      // Log the error for debugging
      debugPrint('Error exiting fullscreen: $e');
      debugPrint('Stack trace: $stackTrace');
      // Mark as inactive even if there was an error
      _isFullScreenActive = false;
    }
  }

  Future<void> _handleClose() async {
    await _exitFullScreen();
    if (!mounted) return;

    if (widget.onClose != null) {
      widget.onClose!();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.playerController.builder(
      builder: (context, data) {
        final TrackEntity? track = data.currentPlayingItem;

        if (track == null) {
          return Container(
            color: context.themeData.scaffoldBackgroundColor,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.music,
                    size: 64,
                    color: context.themeData.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No track playing',
                    style: context.themeData.textTheme.headlineSmall?.copyWith(
                      color: context.themeData.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          color: context.themeData.scaffoldBackgroundColor,
          child: Stack(
            children: [
              // Background with Blur Effect
              Positioned.fill(
                child: track.highResImg != null && track.highResImg!.isNotEmpty
                    ? Stack(
                        children: [
                          AppImage(
                            track.highResImg!,
                            fit: BoxFit.cover,
                          ),
                          // Gradient Overlays
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  context.themeData.scaffoldBackgroundColor
                                      .withValues(alpha: 0.7),
                                  context.themeData.scaffoldBackgroundColor
                                      .withValues(alpha: 0.85),
                                  context.themeData.scaffoldBackgroundColor,
                                ],
                                stops: const [0.0, 0.6, 1.0],
                              ),
                            ),
                          ),
                          // Radial gradient for subtle effect
                          Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.topCenter,
                                radius: 1.2,
                                colors: [
                                  context.themeData.scaffoldBackgroundColor
                                      .withValues(alpha: 0.4),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              context.themeData.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              context.themeData.colorScheme.secondary
                                  .withValues(alpha: 0.05),
                            ],
                          ),
                        ),
                      ),
              ),
              // Content
              SafeArea(
                child: Column(
                  children: [
                    // Header Bar
                    _buildHeader(context, track, data),
                    // Main Content
                    Expanded(
                      child: Row(
                        children: [
                          // Left Side - Album Art & Track Info
                          Expanded(
                            flex: 2,
                            child: _buildLeftPanel(context, track, data),
                          ),
                          // Right Side - Queue/Lyrics
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 16,
                                right: 24,
                                bottom: 16,
                              ),
                              decoration: BoxDecoration(
                                color: context.themeData.colorScheme
                                    .surfaceContainerHighest
                                    .withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: context.themeData.colorScheme.outline
                                      .withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: _buildRightPanel(context, data),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bottom Controls Bar
                    _buildBottomControls(context, track, data),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, TrackEntity track, dynamic data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Close Button
          Material(
            color: context.themeData.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: _handleClose,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: Icon(
                  LucideIcons.chevronDown,
                  color: context.themeData.colorScheme.onSurface,
                  size: 20,
                ),
              ),
            ),
          ),
          const Spacer(),
          // Mode Toggle
          Container(
            decoration: BoxDecoration(
              color: context.themeData.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModeButton(
                  context,
                  icon: LucideIcons.listMusic,
                  label: 'Queue',
                  mode: PlayerMode.queue,
                  currentMode: data.playerMode,
                ),
                _buildModeButton(
                  context,
                  icon: LucideIcons.micVocal,
                  label: 'Lyrics',
                  mode: PlayerMode.lyrics,
                  currentMode: data.playerMode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required PlayerMode mode,
    required PlayerMode currentMode,
  }) {
    final isActive = currentMode == mode;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.playerController.methods.setPlayerMode(mode);
        },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? context.themeData.colorScheme.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive
                    ? context.themeData.colorScheme.primary
                    : context.themeData.colorScheme.onSurface
                        .withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? context.themeData.colorScheme.primary
                      : context.themeData.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftPanel(
      BuildContext context, TrackEntity track, dynamic data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSize = constraints.maxHeight * 0.5;
        final artworkSize = maxSize.clamp(280.0, 420.0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Album Artwork
              Hero(
                tag: 'album-art-${track.id}',
                child: Container(
                  width: artworkSize,
                  height: artworkSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: context.themeData.colorScheme.primary
                            .withValues(alpha: 0.2),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child:
                        track.highResImg != null && track.highResImg!.isNotEmpty
                            ? AppImage(
                                track.highResImg!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      context.themeData.colorScheme.primary
                                          .withValues(alpha: 0.6),
                                      context.themeData.colorScheme.primary
                                          .withValues(alpha: 0.3),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Icon(
                                  LucideIcons.music,
                                  size: artworkSize * 0.3,
                                  color: context.themeData.colorScheme.onPrimary
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                  ),
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.05),
              // Track Title
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    track.title,
                    style: context.themeData.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: context.themeData.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Artist Name
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.micVocal,
                        size: 14,
                        color: context.themeData.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          track.artist.name,
                          style:
                              context.themeData.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.themeData.colorScheme.onSurface
                                .withValues(alpha: 0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRightPanel(BuildContext context, dynamic data) {
    switch (data.playerMode) {
      case PlayerMode.lyrics:
        return _buildLyricsView(context, data);
      default:
        return _buildQueueView(context, data);
    }
  }

  Widget _buildLyricsView(BuildContext context, dynamic data) {
    final track = data.currentPlayingItem;

    if (track == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.music,
              size: 48,
              color: context.themeData.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No track playing',
              style: context.themeData.textTheme.bodyLarge?.copyWith(
                color: context.themeData.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    if (data.loadingLyrics) {
      return Center(
        child: CircularProgressIndicator(
          color: context.themeData.colorScheme.primary,
        ),
      );
    }

    if (data.lyrics.lyrics == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.music2,
              size: 48,
              color: context.themeData.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              context.localization.lyricsNotFound,
              style: context.themeData.textTheme.bodyLarge?.copyWith(
                color: context.themeData.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: TrackLyrics(
        totalDuration: track.duration,
        currentPosition: track.position,
        synced: data.syncedLyrics,
        timedLyrics: data.lyrics.timedLyrics,
        lyrics: data.lyrics.lyrics!,
        onTimeSelected: (duration) =>
            widget.playerController.methods.seek(duration),
      ),
    );
  }

  Widget _buildQueueView(BuildContext context, dynamic data) {
    if (widget.playerController.data.queue.length <= 1) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.listMusic,
              size: 48,
              color: context.themeData.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              context.localization.queueEmptyTitle,
              style: context.themeData.textTheme.bodyLarge?.copyWith(
                color: context.themeData.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return QueueWidget(
      playerController: widget.playerController,
      hideNowPlaying: true,
      showSmartQueue: true,
    );
  }

  Widget _buildBottomControls(
      BuildContext context, TrackEntity track, dynamic data) {
    return Container(
      padding: const EdgeInsets.fromLTRB(48, 16, 48, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            context.themeData.scaffoldBackgroundColor.withValues(alpha: 0.8),
            context.themeData.scaffoldBackgroundColor,
          ],
        ),
      ),
      child: Column(
        children: [
          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  (_useSeekDuration ? _seekDuration : track.position)
                      .formatDuration,
                  style: context.themeData.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.themeData.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 5,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 14,
                        ),
                        activeTrackColor:
                            context.themeData.colorScheme.primary.withValues(
                          alpha: 0.9,
                        ),
                        inactiveTrackColor:
                            context.themeData.colorScheme.primary.withValues(
                          alpha: 0.15,
                        ),
                        thumbColor: context.themeData.colorScheme.primary,
                        overlayColor:
                            context.themeData.colorScheme.primary.withValues(
                          alpha: 0.15,
                        ),
                      ),
                      child: Slider(
                        min: 0,
                        max: track.duration.inSeconds.toDouble(),
                        value: () {
                          if (track.position.inSeconds >
                              track.duration.inSeconds) {
                            return 0.0;
                          }
                          if (_useSeekDuration) {
                            return _seekDuration.inSeconds.toDouble();
                          }
                          if (track.position.inSeconds.toDouble() >= 0) {
                            return track.position.inSeconds.toDouble();
                          }
                          return 0.0;
                        }(),
                        onChanged: (value) {
                          setState(() {
                            _useSeekDuration = true;
                            _seekDuration = Duration(seconds: value.toInt());
                          });
                        },
                        onChangeEnd: (value) async {
                          setState(() {
                            _useSeekDuration = false;
                          });
                          await widget.playerController.methods
                              .seek(_seekDuration);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  track.duration.formatDuration,
                  style: context.themeData.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.themeData.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Favorite & Download
              Row(
                children: [
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      LucideIcons.heart,
                      size: 20,
                      color: context.themeData.colorScheme.onSurface
                          .withValues(alpha: 0.0),
                    ),
                  ),
                  FavoriteButton(
                    libraryController: widget.libraryController,
                    track: track,
                  ),
                  const SizedBox(width: 4),
                  DownloadButton(
                    controller: widget.downloaderController,
                    track: track,
                  ),
                ],
              ),
              // Center: Playback Controls
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildControlButton(
                    context,
                    icon: LucideIcons.shuffle,
                    size: 18,
                    isActive: data.shuffleEnabled,
                    onTap: () =>
                        widget.playerController.methods.toggleShuffle(),
                  ),
                  const SizedBox(width: 12),
                  _buildControlButton(
                    context,
                    icon: LucideIcons.skipBack,
                    size: 22,
                    onTap: () =>
                        widget.playerController.methods.previousInQueue(),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: context.themeData.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: context.themeData.colorScheme.primary
                              .withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (data.isPlaying) {
                            widget.playerController.methods.pause();
                          } else {
                            widget.playerController.methods.resume();
                          }
                        },
                        customBorder: const CircleBorder(),
                        child: Icon(
                          data.isPlaying ? LucideIcons.pause : LucideIcons.play,
                          size: 24,
                          color: context.themeData.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildControlButton(
                    context,
                    icon: LucideIcons.skipForward,
                    size: 22,
                    onTap: () => widget.playerController.methods.nextInQueue(),
                  ),
                  const SizedBox(width: 12),
                  _buildRepeatButton(context, data),
                ],
              ),
              // Right: Volume & Options
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (data.volume > 0) {
                        setState(() {
                          _previousVolume = data.volume;
                        });
                        widget.playerController.methods.setVolume(0.0);
                      } else {
                        widget.playerController.methods
                            .setVolume(_previousVolume);
                      }
                    },
                    icon: Icon(
                      () {
                        if (data.volume == 0) {
                          return LucideIcons.volumeOff;
                        } else if (data.volume < 0.5) {
                          return LucideIcons.volume1;
                        } else {
                          return LucideIcons.volume2;
                        }
                      }(),
                      size: 18,
                      color: context.themeData.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Material(
                      color: Colors.transparent,
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 5,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 10,
                          ),
                          activeTrackColor: context
                              .themeData.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                          inactiveTrackColor: context
                              .themeData.colorScheme.onSurface
                              .withValues(alpha: 0.15),
                          thumbColor: context.themeData.colorScheme.onSurface
                              .withValues(alpha: 0.8),
                          overlayColor: context.themeData.colorScheme.onSurface
                              .withValues(alpha: 0.1),
                        ),
                        child: Slider(
                          value: data.volume,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) {
                            widget.playerController.methods.setVolume(value);
                          },
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Tooltip(
                        message: data.sleepTimerActive &&
                                data.sleepTimerEndTime != null
                            ? context.localization.sleepTimerActive(
                                _formatRemainingTime(data.sleepTimerEndTime!))
                            : context.localization.sleepTimer,
                        child: IconButton(
                          onPressed: () {
                            if (data.sleepTimerActive) {
                              SleepTimerDialog.showActiveTimer(
                                context,
                                endTime: data.sleepTimerEndTime!,
                                onCancel: () {
                                  widget.playerController.methods
                                      .cancelSleepTimer();
                                },
                                onAddTime: (duration) {
                                  widget.playerController.methods
                                      .setSleepTimer(duration);
                                },
                              );
                            } else {
                              SleepTimerDialog.show(
                                context,
                                onTimerSet: (duration) {
                                  widget.playerController.methods
                                      .setSleepTimer(duration);
                                },
                              );
                            }
                          },
                          icon: Icon(
                            data.sleepTimerActive
                                ? LucideIcons.timerOff
                                : LucideIcons.timer,
                            size: 18,
                            color: data.sleepTimerActive
                                ? context.themeData.colorScheme.primary
                                : context.themeData.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      if (data.sleepTimerActive)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: context.themeData.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  TrackOptions(
                    coreController: widget.coreController,
                    track: track,
                    playerController: widget.playerController,
                    downloaderController: widget.downloaderController,
                    getPlayableItemUsecase: widget.getPlayableItemUsecase,
                    libraryController: widget.libraryController,
                    getAlbumUsecase: widget.getAlbumUsecase,
                    getArtistUsecase: widget.getArtistUsecase,
                    getArtistTracksUsecase: widget.getArtistTracksUsecase,
                    getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                    getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                    getTrackUsecase: widget.getTrackUsecase,
                    getPlaylistUsecase: widget.getPlaylistUsecase,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required double size,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: size,
        color: isActive
            ? context.themeData.colorScheme.primary
            : context.themeData.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildRepeatButton(BuildContext context, dynamic data) {
    IconData icon = LucideIcons.repeat;
    bool isActive = false;

    switch (data.repeatMode) {
      case MusilyRepeatMode.noRepeat:
        icon = LucideIcons.repeat;
        isActive = false;
        break;
      case MusilyRepeatMode.repeat:
        icon = LucideIcons.repeat;
        isActive = true;
        break;
      case MusilyRepeatMode.repeatOne:
        icon = LucideIcons.repeat1;
        isActive = true;
        break;
    }

    return _buildControlButton(
      context,
      icon: icon,
      size: 18,
      isActive: isActive,
      onTap: () => widget.playerController.methods.toggleRepeatState(),
    );
  }
}
