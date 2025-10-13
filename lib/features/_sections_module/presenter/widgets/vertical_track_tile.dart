import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class VerticalTrackTile extends StatelessWidget {
  final TrackEntity track;
  final PlayerController playerController;
  final LibraryController libraryController;
  final DownloaderController downloaderController;
  final CoreController coreController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;
  final SectionsController sectionsController;

  const VerticalTrackTile({
    required this.track,
    required this.playerController,
    required this.libraryController,
    required this.downloaderController,
    required this.coreController,
    required this.getPlayableItemUsecase,
    required this.getAlbumUsecase,
    required this.getPlaylistUsecase,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
    required this.getTrackUsecase,
    required this.sectionsController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            playerController.methods.loadAndPlay(track, track.hash);
            libraryController.methods.updateLastTimePlayed(track.hash);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 48,
              height: 48,
              child: track.lowResImg != null
                  ? AppImage(
                      track.lowResImg!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: 0.3),
                      child: Icon(
                        LucideIcons.music,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                        size: 20,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Track info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                track.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                track.artist.name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Play button
        IconButton.filledTonal(
          onPressed: () {
            final index =
                sectionsController.data.moreRecommendedTracks.indexOf(track);
            playerController.methods.playPlaylist(
              sectionsController.data.moreRecommendedTracks,
              'recommended_section',
              startFrom: index,
            );
            libraryController.methods.updateLastTimePlayed(track.hash);
          },
          icon: Icon(
            LucideIcons.play,
            color: Colors.white.withValues(alpha: 0.8),
            size: 20,
          ),
        ),
      ],
    );
  }
}
