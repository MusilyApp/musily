import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_icon.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/pages/playlist_page.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class LibraryTile extends StatelessWidget {
  final LibraryItemEntity item;
  final CoreController coreController;
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;

  const LibraryTile({
    required this.item,
    required this.coreController,
    required this.playerController,
    required this.getAlbumUsecase,
    super.key,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getPlaylistUsecase,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
    required this.getTrackUsecase,
  });

  @override
  Widget build(BuildContext context) {
    if (item.album != null) {
      return _buildTile(
        context: context,
        imageUrl: item.album!.highResImg,
        title: item.album!.title,
        onTap: () => _navigateToAlbum(context),
      );
    }
    if (item.playlist != null) {
      return _buildTile(
        context: context,
        title: item.playlist!.id == UserService.favoritesId
            ? context.localization.favorites
            : item.playlist!.title,
        onTap: () => _navigateToPlaylist(context),
        customLeading: item.playlist!.id == UserService.favoritesId
            ? playerController.builder(
                builder: (context, data) {
                  return SizedBox(
                    width: 48,
                    height: 48,
                    child: FavoriteIcon(
                      animated: data.isPlaying &&
                          data.playingId.startsWith('favorites'),
                    ),
                  );
                },
              )
            : Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.themeData.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.8),
                      context.themeData.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  LucideIcons.listMusic,
                  size: 20,
                  color:
                      context.themeData.iconTheme.color?.withValues(alpha: 0.6),
                ),
              ),
      );
    }
    if (item.artist != null) {
      return _buildTile(
        context: context,
        imageUrl: item.artist!.highResImg,
        title: item.artist!.name,
        onTap: () => _navigateToArtist(context),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTile({
    required BuildContext context,
    String? imageUrl,
    required String title,
    required VoidCallback onTap,
    Widget? customLeading,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      highlightColor:
          context.themeData.colorScheme.primary.withValues(alpha: 0.1),
      splashColor: context.themeData.colorScheme.primary.withValues(alpha: 0.3),
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: context.themeData.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  context.themeData.colorScheme.outline.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: context.themeData.colorScheme.primary
                    .withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // Leading image or custom widget
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: customLeading ??
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              context
                                  .themeData.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.8),
                              context
                                  .themeData.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.4),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? AppImage(
                                imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                LucideIcons.music,
                                color: context.themeData.iconTheme.color
                                    ?.withValues(alpha: 0.6),
                                size: 24,
                              ),
                      ),
                ),
                const SizedBox(width: 12),
                // Title
                Expanded(
                  child: InfinityMarquee(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
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

  void _navigateToAlbum(BuildContext context) {
    LyNavigator.push(
      context.showingPageContext,
      item.album!.tracks.isEmpty
          ? AsyncAlbumPage(
              getTrackUsecase: getTrackUsecase,
              albumId: item.album!.id,
              getPlaylistUsecase: getPlaylistUsecase,
              coreController: coreController,
              playerController: playerController,
              getAlbumUsecase: getAlbumUsecase,
              downloaderController: downloaderController,
              getPlayableItemUsecase: getPlayableItemUsecase,
              libraryController: libraryController,
              getArtistAlbumsUsecase: getArtistAlbumsUsecase,
              getArtistSinglesUsecase: getArtistSinglesUsecase,
              getArtistTracksUsecase: getArtistTracksUsecase,
              getArtistUsecase: getArtistUsecase,
            )
          : AlbumPage(
              getTrackUsecase: getTrackUsecase,
              coreController: coreController,
              album: item.album!,
              playerController: playerController,
              getAlbumUsecase: getAlbumUsecase,
              getPlaylistUsecase: getPlaylistUsecase,
              downloaderController: downloaderController,
              getPlayableItemUsecase: getPlayableItemUsecase,
              libraryController: libraryController,
              getArtistAlbumsUsecase: getArtistAlbumsUsecase,
              getArtistSinglesUsecase: getArtistSinglesUsecase,
              getArtistTracksUsecase: getArtistTracksUsecase,
              getArtistUsecase: getArtistUsecase,
            ),
    );
  }

  void _navigateToPlaylist(BuildContext context) {
    LyNavigator.push(
      context.showingPageContext,
      item.playlist!.tracks.isEmpty
          ? AsyncPlaylistPage(
              getTrackUsecase: getTrackUsecase,
              origin: ContentOrigin.library,
              playlistId: item.playlist!.id,
              getPlaylistUsecase: getPlaylistUsecase,
              coreController: coreController,
              playerController: playerController,
              downloaderController: downloaderController,
              getPlayableItemUsecase: getPlayableItemUsecase,
              libraryController: libraryController,
              getAlbumUsecase: getAlbumUsecase,
              getArtistUsecase: getArtistUsecase,
              getArtistTracksUsecase: getArtistTracksUsecase,
              getArtistAlbumsUsecase: getArtistAlbumsUsecase,
              getArtistSinglesUsecase: getArtistSinglesUsecase,
            )
          : PlaylistPage(
              getTrackUsecase: getTrackUsecase,
              playlist: item.playlist!,
              coreController: coreController,
              getPlaylistUsecase: getPlaylistUsecase,
              playerController: playerController,
              downloaderController: downloaderController,
              getPlayableItemUsecase: getPlayableItemUsecase,
              libraryController: libraryController,
              getAlbumUsecase: getAlbumUsecase,
              getArtistAlbumsUsecase: getArtistAlbumsUsecase,
              getArtistSinglesUsecase: getArtistSinglesUsecase,
              getArtistTracksUsecase: getArtistTracksUsecase,
              getArtistUsecase: getArtistUsecase,
            ),
    );
  }

  void _navigateToArtist(BuildContext context) {
    LyNavigator.push(
      context.showingPageContext,
      item.artist!.topTracks.isEmpty
          ? AsyncArtistPage(
              getTrackUsecase: getTrackUsecase,
              artistId: item.artist!.id,
              coreController: coreController,
              playerController: playerController,
              getPlaylistUsecase: getPlaylistUsecase,
              downloaderController: downloaderController,
              getPlayableItemUsecase: getPlayableItemUsecase,
              libraryController: libraryController,
              getAlbumUsecase: getAlbumUsecase,
              getArtistUsecase: getArtistUsecase,
              getArtistAlbumsUsecase: getArtistAlbumsUsecase,
              getArtistTracksUsecase: getArtistTracksUsecase,
              getArtistSinglesUsecase: getArtistSinglesUsecase,
            )
          : ArtistPage(
              getTrackUsecase: getTrackUsecase,
              artist: item.artist!,
              coreController: coreController,
              playerController: playerController,
              getPlaylistUsecase: getPlaylistUsecase,
              downloaderController: downloaderController,
              getPlayableItemUsecase: getPlayableItemUsecase,
              libraryController: libraryController,
              getAlbumUsecase: getAlbumUsecase,
              getArtistUsecase: getArtistUsecase,
              getArtistTracksUsecase: getArtistTracksUsecase,
              getArtistAlbumsUsecase: getArtistAlbumsUsecase,
              getArtistSinglesUsecase: getArtistSinglesUsecase,
            ),
    );
  }
}
