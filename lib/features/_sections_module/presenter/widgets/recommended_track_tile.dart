import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
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
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:musily/features/track/presenter/widgets/track_options.dart';

class RecommendedTrackTile extends StatelessWidget {
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
  final Color? backgroundColor;
  final Color? textColor;

  const RecommendedTrackTile({
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
    this.backgroundColor,
    this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.backgroundColor ?? const Color(0xFFD8B4FA);
    final textColor = this.textColor ?? const Color(0xFF1A0033);
    return Container(
      width: 350,
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Left side - Content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title and subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        track.artist.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  // Action buttons
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Play button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            playerController.methods.loadAndPlay(
                              track,
                              track.hash,
                            );
                          },
                          child: Icon(
                            LucideIcons.play,
                            color: textColor,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Heart icon (Favorite button)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: IconTheme(
                          data: IconThemeData(color: textColor, size: 20),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: FavoriteButton(
                              libraryController: libraryController,
                              track: track,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Download icon
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: IconTheme(
                          data: IconThemeData(color: textColor, size: 20),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: DownloadButton(
                              color: textColor,
                              controller: downloaderController,
                              track: track,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // More options
                      TrackOptions(
                        getTrackUsecase: getTrackUsecase,
                        color: textColor,
                        track: track,
                        playerController: playerController,
                        libraryController: libraryController,
                        downloaderController: downloaderController,
                        coreController: coreController,
                        getPlayableItemUsecase: getPlayableItemUsecase,
                        getAlbumUsecase: getAlbumUsecase,
                        getPlaylistUsecase: getPlaylistUsecase,
                        getArtistUsecase: getArtistUsecase,
                        getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                        getArtistTracksUsecase: getArtistTracksUsecase,
                        getArtistSinglesUsecase: getArtistSinglesUsecase,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Right side - Image
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: SizedBox(
                height: 150,
                child: track.highResImg != null && track.highResImg!.isNotEmpty
                    ? AppImage(
                        track.highResImg!,
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: textColor.withValues(alpha: 0.1),
                        child: Icon(
                          LucideIcons.music,
                          size: 40,
                          color: textColor,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
