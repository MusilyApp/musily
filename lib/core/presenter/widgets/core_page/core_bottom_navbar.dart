import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/player/presenter/widgets/mini_player_widget.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class CoreBottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final CoreController coreController;
  final GetArtistUsecase getArtistUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetTrackUsecase getTrackUsecase;

  const CoreBottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.playerController,
    required this.downloaderController,
    required this.libraryController,
    required this.getAlbumUsecase,
    required this.getPlayableItemUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getArtistTracksUsecase,
    required this.coreController,
    required this.getArtistUsecase,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniPlayerWidget(
            getTrackUsecase: getTrackUsecase,
            playerController: playerController,
            downloaderController: downloaderController,
            libraryController: libraryController,
            getAlbumUsecase: getAlbumUsecase,
            getPlayableItemUsecase: getPlayableItemUsecase,
            getArtistAlbumsUsecase: getArtistAlbumsUsecase,
            getArtistSinglesUsecase: getArtistSinglesUsecase,
            getArtistTracksUsecase: getArtistTracksUsecase,
            coreController: coreController,
            getArtistUsecase: getArtistUsecase,
            getPlaylistUsecase: getPlaylistUsecase,
          ),
          Container(
            height: 70,
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: context.themeData.colorScheme.surface,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NavItem(
                      icon: LucideIcons.house,
                      isSelected: selectedIndex == 0,
                      onTap: () => onItemSelected(0),
                    ),
                    _NavItem(
                      icon: LucideIcons.search,
                      isSelected: selectedIndex == 1,
                      onTap: () => onItemSelected(1),
                    ),
                    _NavItem(
                      icon: LucideIcons.library,
                      isSelected: selectedIndex == 2,
                      onTap: () => onItemSelected(2),
                    ),
                    _NavItem(
                      icon: LucideIcons.download,
                      isSelected: selectedIndex == 3,
                      onTap: () => onItemSelected(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? context.themeData.colorScheme.primary.withValues(alpha: 0.2)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isSelected
              ? context.themeData.colorScheme.primary
              : context.themeData.colorScheme.onSurface.withValues(alpha: 0.6),
          size: 24,
        ),
      ),
    );
  }
}
