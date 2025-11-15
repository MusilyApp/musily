import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
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
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:musily/features/track/presenter/widgets/track_options.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';

class PlayerOptions extends StatelessWidget {
  final PlayerController playerController;
  final PlayerMode playerMode;
  final TrackEntity track;
  final LibraryController libraryController;
  final GetTrackUsecase getTrackUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistUsecase getArtistUsecase;
  final CoreController coreController;

  const PlayerOptions({
    super.key,
    required this.playerController,
    required this.playerMode,
    required this.track,
    required this.libraryController,
    required this.getTrackUsecase,
    required this.getPlaylistUsecase,
    required this.getAlbumUsecase,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistUsecase,
    required this.coreController,
  });

  @override
  Widget build(BuildContext context) {
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
      child: _buildModeContent(context),
    );
  }

  Widget _buildModeContent(BuildContext context) {
    Widget content;
    String key;

    switch (playerMode) {
      case PlayerMode.queue:
        content = _buildQueueToolsButton(context);
        key = 'queue_tools';
        break;
      case PlayerMode.lyrics:
      case PlayerMode.artwork:
        content = track.isLocal
            ? const SizedBox.shrink()
            : _buildTrackOptions(context);
        key = 'track_options';
        break;
    }

    return Container(key: ValueKey(key), child: content);
  }

  Widget _buildQueueToolsButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        LyNavigator.push(
          coreController.coreContext!,
          QueueTools(
            playerController: playerController,
            libraryController: libraryController,
          ),
          contextKey: 'QueueTools',
        );
      },
      icon: Icon(
        LucideIcons.wrench,
        size: 20,
        color: context.themeData.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      tooltip: context.localization.queueTools,
    );
  }

  Widget _buildTrackOptions(BuildContext context) {
    return TrackOptions(
      getTrackUsecase: getTrackUsecase,
      getPlaylistUsecase: getPlaylistUsecase,
      track: track,
      playerController: playerController,
      getAlbumUsecase: getAlbumUsecase,
      downloaderController: downloaderController,
      getPlayableItemUsecase: getPlayableItemUsecase,
      libraryController: libraryController,
      getArtistAlbumsUsecase: getArtistAlbumsUsecase,
      getArtistSinglesUsecase: getArtistSinglesUsecase,
      getArtistTracksUsecase: getArtistTracksUsecase,
      getArtistUsecase: getArtistUsecase,
      coreController: coreController,
      hideOptions: [
        TrackTileOptions.seeAlbum,
        TrackTileOptions.seeArtist,
        TrackTileOptions.addToQueue,
      ],
    );
  }
}
