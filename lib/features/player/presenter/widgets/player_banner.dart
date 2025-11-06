import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/empty_state.dart';
import 'package:musily/core/presenter/widgets/musily_loading.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
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

class PlayerBanner extends StatefulWidget {
  final TrackEntity track;
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

  const PlayerBanner({
    super.key,
    required this.track,
    required this.playerController,
    required this.libraryController,
    required this.getAlbumUsecase,
    required this.getPlayableItemUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getArtistTracksUsecase,
    required this.coreController,
    required this.getArtistUsecase,
    required this.downloaderController,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<PlayerBanner> createState() => _PlayerBannerState();
}

class _PlayerBannerState extends State<PlayerBanner> {
  @override
  Widget build(BuildContext context) {
    return widget.playerController.builder(
      builder: (context, data) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
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
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: child,
          ),
        );
      },
      child: _buildModeContent(context, data),
    );
  }

  Widget _buildModeContent(BuildContext context, dynamic data) {
    Widget content;
    String key;

    switch (data.playerMode) {
      case PlayerMode.lyrics:
        content = _buildLyricsContent(context, data);
        key = 'lyrics_${data.currentPlayingItem?.id ?? 'no_track'}';
        break;
      case PlayerMode.queue:
        content = _buildQueueContent(context, data);
        key = 'queue';
        break;
      case PlayerMode.artwork:
      default:
        content = _buildArtworkContent(context, data);
        key = 'artwork_${data.currentPlayingItem?.id ?? 'no_track'}';
        break;
    }

    return Container(key: ValueKey(key), child: content);
  }

  Widget _buildLyricsContent(BuildContext context, dynamic data) {
    if (data.loadingLyrics) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: MusilyDotsLoading(
            color: IconTheme.of(context).color ?? Colors.white,
            size: 45,
          ),
        ),
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
    return TrackLyrics(
      totalDuration: widget.track.duration,
      currentPosition: widget.track.position,
      synced: data.syncedLyrics,
      timedLyrics: data.lyrics.timedLyrics,
      lyrics: data.lyrics.lyrics!,
      onTimeSelected: (duration) =>
          widget.playerController.methods.seek(duration),
    );
  }

  Widget _buildQueueContent(BuildContext context, dynamic data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Builder(
        builder: (context) {
          if (widget.playerController.data.queue.length <= 1) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: EmptyState(
                  icon: Icon(
                    LucideIcons.music,
                    size: 50,
                    color: context.themeData.iconTheme.color
                        ?.withValues(alpha: .5),
                  ),
                  title: context.localization.queueEmptyTitle,
                  message: context.localization.queueEmptyMessage,
                ),
              ),
            );
          }
          return QueueWidget(
            playerController: widget.playerController,
            hideNowPlaying: true,
          );
        },
      ),
    );
  }

  Widget _buildArtworkContent(BuildContext context, dynamic data) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              LyNavigator.close('player');
              LyNavigator.push(
                context.showingPageContext,
                AsyncAlbumPage(
                  getTrackUsecase: widget.getTrackUsecase,
                  albumId: data.currentPlayingItem!.album.id,
                  coreController: widget.coreController,
                  getPlaylistUsecase: widget.getPlaylistUsecase,
                  playerController: widget.playerController,
                  getAlbumUsecase: widget.getAlbumUsecase,
                  downloaderController: widget.downloaderController,
                  getPlayableItemUsecase: widget.getPlayableItemUsecase,
                  libraryController: widget.libraryController,
                  getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                  getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                  getArtistTracksUsecase: widget.getArtistTracksUsecase,
                  getArtistUsecase: widget.getArtistUsecase,
                ),
              );
            },
            child: Stack(
              children: [
                Builder(
                  builder: (context) {
                    if (widget.track.highResImg != null &&
                        widget.track.highResImg!.isNotEmpty) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: context.themeData.dividerColor.withValues(
                              alpha: .2,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: AppImage(
                            height: 350,
                            width: 350,
                            widget.track.highResImg!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          width: 1,
                          color: context.themeData.colorScheme.outline
                              .withValues(alpha: .2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 350,
                            width: 350,
                            child: Icon(
                              Icons.music_note,
                              size: 75,
                              color: context.themeData.iconTheme.color
                                  ?.withValues(alpha: .8),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (data.tracksFromSmartQueue.contains(widget.track.hash))
                  Container(
                    height: 350,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          context.themeData.colorScheme.primary,
                          context.themeData.colorScheme.primary.withValues(
                            alpha: .2,
                          ),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.wand_stars,
                        color: context.themeData.colorScheme.onPrimary,
                        size: 60,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
