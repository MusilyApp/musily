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

class LibraryTile extends StatefulWidget {
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
  State<LibraryTile> createState() => _LibraryTileState();
}

class _LibraryTileState extends State<LibraryTile> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (widget.item.album != null) {
          return _LibraryTileContent(
            imageUrl: widget.item.album!.lowResImg,
            title: widget.item.album!.title,
            onTap: () => _navigateToAlbum(context),
            playerController: widget.playerController,
          );
        }
        if (widget.item.playlist != null) {
          return _LibraryTileContent(
            title: widget.item.playlist!.id == UserService.favoritesId
                ? context.localization.favorites
                : widget.item.playlist!.title,
            onTap: () => _navigateToPlaylist(context),
            playerController: widget.playerController,
            customLeading: widget.item.playlist!.id == UserService.favoritesId
                ? widget.playerController.builder(
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
                : _PlaylistIcon(),
          );
        }
        if (widget.item.artist != null) {
          return _LibraryTileContent(
            imageUrl: widget.item.artist!.highResImg,
            title: widget.item.artist!.name,
            onTap: () => _navigateToArtist(context),
            playerController: widget.playerController,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _navigateToAlbum(BuildContext context) {
    LyNavigator.push(
      context.showingPageContext,
      widget.item.album!.tracks.isEmpty
          ? AsyncAlbumPage(
              getTrackUsecase: widget.getTrackUsecase,
              albumId: widget.item.album!.id,
              getPlaylistUsecase: widget.getPlaylistUsecase,
              coreController: widget.coreController,
              playerController: widget.playerController,
              getAlbumUsecase: widget.getAlbumUsecase,
              downloaderController: widget.downloaderController,
              getPlayableItemUsecase: widget.getPlayableItemUsecase,
              libraryController: widget.libraryController,
              getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
              getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
              getArtistTracksUsecase: widget.getArtistTracksUsecase,
              getArtistUsecase: widget.getArtistUsecase,
            )
          : AlbumPage(
              getTrackUsecase: widget.getTrackUsecase,
              coreController: widget.coreController,
              album: widget.item.album!,
              playerController: widget.playerController,
              getAlbumUsecase: widget.getAlbumUsecase,
              getPlaylistUsecase: widget.getPlaylistUsecase,
              downloaderController: widget.downloaderController,
              getPlayableItemUsecase: widget.getPlayableItemUsecase,
              libraryController: widget.libraryController,
              getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
              getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
              getArtistTracksUsecase: widget.getArtistTracksUsecase,
              getArtistUsecase: widget.getArtistUsecase,
            ),
    );
  }

  void _navigateToPlaylist(BuildContext context) {
    LyNavigator.push(
      context.showingPageContext,
      widget.item.playlist!.tracks.isEmpty
          ? AsyncPlaylistPage(
              getTrackUsecase: widget.getTrackUsecase,
              origin: ContentOrigin.library,
              playlistId: widget.item.playlist!.id,
              getPlaylistUsecase: widget.getPlaylistUsecase,
              coreController: widget.coreController,
              playerController: widget.playerController,
              downloaderController: widget.downloaderController,
              getPlayableItemUsecase: widget.getPlayableItemUsecase,
              libraryController: widget.libraryController,
              getAlbumUsecase: widget.getAlbumUsecase,
              getArtistUsecase: widget.getArtistUsecase,
              getArtistTracksUsecase: widget.getArtistTracksUsecase,
              getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
              getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
            )
          : PlaylistPage(
              getTrackUsecase: widget.getTrackUsecase,
              playlist: widget.item.playlist!,
              coreController: widget.coreController,
              getPlaylistUsecase: widget.getPlaylistUsecase,
              playerController: widget.playerController,
              downloaderController: widget.downloaderController,
              getPlayableItemUsecase: widget.getPlayableItemUsecase,
              libraryController: widget.libraryController,
              getAlbumUsecase: widget.getAlbumUsecase,
              getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
              getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
              getArtistTracksUsecase: widget.getArtistTracksUsecase,
              getArtistUsecase: widget.getArtistUsecase,
            ),
    );
  }

  void _navigateToArtist(BuildContext context) {
    LyNavigator.push(
      context.showingPageContext,
      widget.item.artist!.topTracks.isEmpty
          ? AsyncArtistPage(
              getTrackUsecase: widget.getTrackUsecase,
              artistId: widget.item.artist!.id,
              coreController: widget.coreController,
              playerController: widget.playerController,
              getPlaylistUsecase: widget.getPlaylistUsecase,
              downloaderController: widget.downloaderController,
              getPlayableItemUsecase: widget.getPlayableItemUsecase,
              libraryController: widget.libraryController,
              getAlbumUsecase: widget.getAlbumUsecase,
              getArtistUsecase: widget.getArtistUsecase,
              getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
              getArtistTracksUsecase: widget.getArtistTracksUsecase,
              getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
            )
          : ArtistPage(
              getTrackUsecase: widget.getTrackUsecase,
              artist: widget.item.artist!,
              coreController: widget.coreController,
              playerController: widget.playerController,
              getPlaylistUsecase: widget.getPlaylistUsecase,
              downloaderController: widget.downloaderController,
              getPlayableItemUsecase: widget.getPlayableItemUsecase,
              libraryController: widget.libraryController,
              getAlbumUsecase: widget.getAlbumUsecase,
              getArtistUsecase: widget.getArtistUsecase,
              getArtistTracksUsecase: widget.getArtistTracksUsecase,
              getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
              getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
            ),
    );
  }
}

class _LibraryTileContent extends StatefulWidget {
  final String? imageUrl;
  final String title;
  final VoidCallback onTap;
  final Widget? customLeading;
  final PlayerController playerController;

  const _LibraryTileContent({
    this.imageUrl,
    required this.title,
    required this.onTap,
    this.customLeading,
    required this.playerController,
  });

  @override
  State<_LibraryTileContent> createState() => _LibraryTileContentState();
}

class _LibraryTileContentState extends State<_LibraryTileContent> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        highlightColor:
            context.themeData.colorScheme.primary.withValues(alpha: 0.1),
        splashColor:
            context.themeData.colorScheme.primary.withValues(alpha: 0.3),
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: context.themeData.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.themeData.colorScheme.outline
                    .withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? context.themeData.colorScheme.primary
                          .withValues(alpha: 0.25)
                      : context.themeData.colorScheme.primary
                          .withValues(alpha: 0.08),
                  blurRadius: _isHovered ? 16 : 8,
                  offset: Offset(0, _isHovered ? 5 : 2),
                  spreadRadius: _isHovered ? 1 : 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  AnimatedScale(
                    scale: _isHovered ? 1.04 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.customLeading ??
                          _TileLeading(imageUrl: widget.imageUrl),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfinityMarquee(
                      child: Text(
                        widget.title,
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
      ),
    );
  }
}

class _TileLeading extends StatelessWidget {
  final String? imageUrl;

  const _TileLeading({
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Builder(
        builder: (context) {
          if (imageUrl != null && imageUrl!.isNotEmpty) {
            return AppImage(
              imageUrl!,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            );
          }
          return Icon(
            LucideIcons.music,
            color: context.themeData.iconTheme.color?.withValues(alpha: 0.6),
            size: 24,
          );
        },
      ),
    );
  }
}

class _PlaylistIcon extends StatelessWidget {
  const _PlaylistIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
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
        color: context.themeData.iconTheme.color?.withValues(alpha: 0.6),
      ),
    );
  }
}
