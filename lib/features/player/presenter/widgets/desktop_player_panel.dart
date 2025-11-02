import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/widgets/empty_state.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/domain/enums/player_mode.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
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
    switch (widget.mode) {
      case PlayerMode.lyrics:
        return Container(
          key: ValueKey('lyrics_${data.currentPlayingItem?.id ?? 'no_track'}'),
          child: _buildLyricsContent(context, data),
        );
      default:
        return Container(
          key: const ValueKey('queue'),
          child: Column(
            children: [
              if (widget.playerController.data.currentPlayingItem != null) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: context.themeData.colorScheme.outline
                            .withValues(alpha: .1),
                      ),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: data.loadingSmartQueue
                          ? null
                          : () {
                              widget.playerController.methods
                                  .toggleSmartQueue();
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: data.autoSmartQueue
                                    ? context.themeData.colorScheme.primary
                                        .withValues(alpha: 0.15)
                                    : context.themeData.colorScheme
                                        .surfaceContainerHighest
                                        .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TweenAnimationBuilder<Color?>(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                tween: ColorTween(
                                  begin: data.autoSmartQueue
                                      ? context.themeData.colorScheme
                                          .onSurfaceVariant
                                      : context.themeData.colorScheme.primary,
                                  end: data.autoSmartQueue
                                      ? context.themeData.colorScheme.primary
                                      : context.themeData.colorScheme
                                          .onSurfaceVariant,
                                ),
                                builder: (context, color, child) {
                                  return Icon(
                                    CupertinoIcons.wand_stars,
                                    size: 20,
                                    color: color,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.localization.smartSuggestionsTitle,
                                    style: context
                                        .themeData.textTheme.bodyMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    tween: Tween<double>(
                                      begin: data.autoSmartQueue ? 0.5 : 0.7,
                                      end: data.autoSmartQueue ? 0.7 : 0.5,
                                    ),
                                    builder: (context, opacity, child) {
                                      return Text(
                                        context.localization
                                            .smartSuggestionsDescription,
                                        style: context
                                            .themeData.textTheme.bodySmall
                                            ?.copyWith(
                                          color: context.themeData.colorScheme
                                              .onSurfaceVariant
                                              .withValues(alpha: opacity),
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: AnimatedScale(
                                key: const ValueKey('switch'),
                                scale: data.autoSmartQueue ? 1.0 : 0.95,
                                duration: const Duration(milliseconds: 200),
                                child: Switch(
                                  value: data.autoSmartQueue,
                                  onChanged: data.loadingSmartQueue
                                      ? null
                                      : (value) {
                                          widget.playerController.methods
                                              .toggleSmartQueue();
                                        },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              Expanded(child: _buildQueueContent(context, data)),
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
        child: LoadingAnimationWidget.waveDots(
            color:
                context.themeData.colorScheme.onSurface.withValues(alpha: 0.7),
            size: 45),
      );
    }

    if (data.lyrics.lyrics == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.music_off_rounded,
              size: 45,
              color: context.themeData.iconTheme.color?.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 12),
            Text(
              context.localization.lyricsNotFound,
              style: const TextStyle(fontSize: 14),
            ),
          ],
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: EmptyState(
            title: context.localization.queueEmptyTitle,
            message: context.localization.queueEmptyMessage,
            icon: const Icon(LucideIcons.music, size: 50),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: QueueWidget(
            playerController: widget.playerController,
            hideNowPlaying: true,
            showSmartQueue: true,
          ),
        ),
      ],
    );
  }
}
