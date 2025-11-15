import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/core/presenter/widgets/section_header.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/pages/local_library_manager_page.dart';
import 'package:musily/features/_library_module/presenter/widgets/library_backup.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class LibrarySettingsPage extends StatelessWidget {
  final DownloaderController downloaderController;
  final LibraryController libraryController;
  final CoreController coreController;
  final PlayerController playerController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetTrackUsecase getTrackUsecase;

  const LibrarySettingsPage({
    super.key,
    required this.downloaderController,
    required this.libraryController,
    required this.coreController,
    required this.playerController,
    required this.getPlayableItemUsecase,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return libraryController.builder(
      builder: (context, libraryData) {
        return downloaderController.builder(
          builder: (context, downloaderData) {
            final completedDownloads = downloaderData.totalCompletedCount;
            final hasLibrary = libraryData.items.isNotEmpty;
            final hasDownloads = completedDownloads > 0;

            return LyPage(
              contextKey: 'LibrarySettingsPage',
              child: Scaffold(
                appBar: MusilyAppBar(
                  title:
                      Text(context.localization.libraryManagementSectionTitle),
                ),
                body: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    SectionHeader(
                      title: context.localization.localLibraryTitle,
                      icon: LucideIcons.folderOpenDot,
                      subtitle: context.localization.localLibraryDescription,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _LibraryActionTile(
                        title: context.localization.manageLocalFolders,
                        description:
                            context.localization.manageLocalFoldersDescription,
                        icon: LucideIcons.folderCog,
                        color: context.themeData.colorScheme.tertiary,
                        enabled: true,
                        onTap: () {
                          LyNavigator.push(
                            context,
                            LocalLibraryManagerPage(
                              libraryController: libraryController,
                              coreController: coreController,
                              playerController: playerController,
                              downloaderController: downloaderController,
                              getPlayableItemUsecase: getPlayableItemUsecase,
                              getAlbumUsecase: getAlbumUsecase,
                              getArtistUsecase: getArtistUsecase,
                              getArtistTracksUsecase: getArtistTracksUsecase,
                              getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                              getArtistSinglesUsecase: getArtistSinglesUsecase,
                              getPlaylistUsecase: getPlaylistUsecase,
                              getTrackUsecase: getTrackUsecase,
                            ),
                          );
                        },
                      ),
                    ),
                    SectionHeader(
                      title: context.localization.backup,
                      icon: LucideIcons.databaseBackup,
                      subtitle: context.localization.backupLibraryDescription,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _LibraryActionTile(
                        title: context.localization.backup,
                        description:
                            context.localization.backupLibraryDescription,
                        icon: LucideIcons.databaseBackup,
                        color: context.themeData.colorScheme.primary,
                        enabled: (hasLibrary || hasDownloads) &&
                            !libraryData.backupInProgress,
                        onTap: () async {
                          LyNavigator.showLyCardDialog(
                            padding: EdgeInsets.zero,
                            context: context,
                            builder: (context) => Center(
                              child: LibraryBackup(
                                hasLibrary: hasLibrary,
                                hasDownloads: hasDownloads,
                                onBackup: (options) async {
                                  if (Platform.isAndroid || Platform.isIOS) {
                                    await coreController.methods
                                        .requestStoragePermission();
                                  }
                                  await libraryController.methods
                                      .backupLibrary(options);
                                  if (context.mounted) {
                                    LyNavigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _LibraryActionTile(
                        title: context.localization.restore,
                        description:
                            context.localization.restoreLibraryDescription,
                        icon: LucideIcons.hardDrive,
                        color: context.themeData.colorScheme.secondary,
                        enabled: !libraryData.backupInProgress,
                        onTap: () async {
                          final file =
                              await libraryController.methods.pickBackupFile();
                          if (file != null) {
                            await libraryController.methods
                                .restoreLibrary(file);
                          }
                        },
                      ),
                    ),
                    PlayerSizedBox(playerController: playerController)
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _LibraryActionTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _LibraryActionTile({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabledColor =
        context.themeData.colorScheme.onSurface.withValues(alpha: 0.3);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: context.themeData.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.35),
              border: Border.all(
                color: context.themeData.colorScheme.outline
                    .withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: enabled ? color : disabledColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            context.themeData.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: context.themeData.textTheme.bodySmall?.copyWith(
                          color: context.themeData.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 20,
                  color: enabled
                      ? context.themeData.colorScheme.onSurface
                          .withValues(alpha: 0.5)
                      : disabledColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
