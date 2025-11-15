import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/window/draggable_box.dart';
import 'package:musily/core/presenter/widgets/empty_state.dart';
import 'package:musily/core/presenter/widgets/musily_loading.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/domain/enums/player_mode.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/player/presenter/widgets/queue_tools.dart';
import 'package:musily/features/player/presenter/widgets/queue_widget.dart';
import 'package:musily/features/player/presenter/widgets/track_lyrics.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class DesktopPlayerPanel extends StatefulWidget {
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final CoreController coreController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetTrackUsecase getTrackUsecase;
  final PlayerMode mode;
  final TrackEntity? track;

  const DesktopPlayerPanel({
    super.key,
    required this.playerController,
    required this.downloaderController,
    required this.libraryController,
    required this.getAlbumUsecase,
    required this.getPlayableItemUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getArtistTracksUsecase,
    required this.coreController,
    required this.getPlaylistUsecase,
    required this.getArtistUsecase,
    required this.getTrackUsecase,
    required this.mode,
    this.track,
  });

  @override
  State<DesktopPlayerPanel> createState() => _DesktopPlayerPanelState();
}

class _DesktopPlayerPanelState extends State<DesktopPlayerPanel> {
  bool _showQueueTools = false;

  @override
  void initState() {
    super.initState();
    if (widget.mode == PlayerMode.artwork) {
      widget.playerController.methods.setPlayerMode(PlayerMode.queue);
    }
    _enforceNonLyricsModeIfNeeded();
  }

  @override
  void didUpdateWidget(covariant DesktopPlayerPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _enforceNonLyricsModeIfNeeded();
  }

  void _enforceNonLyricsModeIfNeeded() {
    final isLocalTrack = widget.track?.isLocal ??
        widget.playerController.data.currentPlayingItem?.isLocal ??
        false;
    if (!isLocalTrack) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentMode = widget.playerController.data.playerMode;
      if (currentMode == PlayerMode.lyrics) {
        widget.playerController.methods.setPlayerMode(PlayerMode.queue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.playerController.builder(
      builder: (context, data) {
        return Container(
          color: context.themeData.scaffoldBackgroundColor,
          child: _buildContent(context, data),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, dynamic data) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _buildModeContent(context, data),
    );
  }

  Widget _buildModeContent(BuildContext context, dynamic data) {
    final isLocalTrack = widget.track?.isLocal ??
        widget.playerController.data.currentPlayingItem?.isLocal ??
        false;
    final effectiveMode = isLocalTrack && widget.mode == PlayerMode.lyrics
        ? PlayerMode.queue
        : widget.mode;
    switch (effectiveMode) {
      case PlayerMode.lyrics:
        return DraggableBox(
          child: Container(
            color: context.themeData.scaffoldBackgroundColor,
            key:
                ValueKey('lyrics_${data.currentPlayingItem?.id ?? 'no_track'}'),
            child: _buildLyricsContent(context, data),
          ),
        );
      default:
        return Container(
          key: const ValueKey('queue'),
          child: Column(
            children: [
              if (widget.playerController.data.currentPlayingItem != null &&
                  !_showQueueTools) ...[
                DraggableBox(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            _showQueueTools = true;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: context.themeData.colorScheme.primary
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  LucideIcons.wrench,
                                  size: 20,
                                  color: context.themeData.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.localization.queueTools,
                                      style: context
                                          .themeData.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      context
                                          .localization.queueToolsDescription,
                                      style: context
                                          .themeData.textTheme.bodySmall
                                          ?.copyWith(
                                        color: context.themeData.colorScheme
                                            .onSurfaceVariant
                                            .withValues(alpha: 0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
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
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ));

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: _showQueueTools
                      ? Container(
                          key: const ValueKey('queue_tools'),
                          child: QueueTools(
                            playerController: widget.playerController,
                            libraryController: widget.libraryController,
                            showAsPage: false,
                            onBack: () {
                              setState(() {
                                _showQueueTools = false;
                              });
                            },
                          ),
                        )
                      : DraggableBox(
                          child: Container(
                            color: context.themeData.scaffoldBackgroundColor,
                            key: const ValueKey('queue_content'),
                            child: _buildQueueContent(context, data),
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildLyricsContent(BuildContext context, dynamic data) {
    if (widget.track == null) {
      return const Center(
        child: EmptyState(
          title: 'No track playing',
          message: 'Start playing a song to see lyrics',
          icon: Icon(LucideIcons.music, size: 50),
        ),
      );
    }

    if (data.loadingLyrics) {
      return Center(
        child: MusilyDotsLoading(
            color:
                context.themeData.colorScheme.onSurface.withValues(alpha: 0.7),
            size: 45),
      );
    }

    if (data.lyrics.lyrics == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: EmptyState(
            icon: Icon(
              LucideIcons.music2,
              size: 50,
              color: context.themeData.iconTheme.color?.withValues(alpha: .5),
            ),
            title: context.localization.lyricsNotFound,
            message: context.localization.lyricsNotAvailable,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TrackLyrics(
        totalDuration: widget.track!.duration,
        currentPosition: widget.track!.position,
        synced: data.syncedLyrics,
        timedLyrics: data.lyrics.timedLyrics,
        lyrics: data.lyrics.lyrics!,
        onTimeSelected: (duration) =>
            widget.playerController.methods.seek(duration),
      ),
    );
  }

  Widget _buildQueueContent(BuildContext context, dynamic data) {
    if (widget.playerController.data.queue.length <= 1) {
      return Center(
        child: Container(
          color: context.themeData.scaffoldBackgroundColor,
          padding: const EdgeInsets.all(16),
          child: EmptyState(
            title: context.localization.queueEmptyTitle,
            message: context.localization.queueEmptyMessage,
            icon: const Icon(LucideIcons.music, size: 50),
          ),
        ),
      );
    }

    return QueueWidget(
      playerController: widget.playerController,
      hideNowPlaying: true,
      showSmartQueue: true,
    );
  }
}
