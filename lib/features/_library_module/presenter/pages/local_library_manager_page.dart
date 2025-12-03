import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_text_field.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/ui/utils/ly_snackbar.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/features/_library_module/domain/entities/local_library_playlist.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/pages/local_library_playlist_page.dart';
import 'package:musily/features/_library_module/presenter/widgets/local_playlist_tile.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class LocalLibraryManagerPage extends StatefulWidget {
  final LibraryController libraryController;
  final CoreController coreController;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetTrackUsecase getTrackUsecase;

  final String? initialFolderPath;

  const LocalLibraryManagerPage({
    super.key,
    required this.libraryController,
    required this.coreController,
    required this.playerController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
    this.initialFolderPath,
  });

  @override
  State<LocalLibraryManagerPage> createState() =>
      _LocalLibraryManagerPageState();
}

class _LocalLibraryManagerPageState extends State<LocalLibraryManagerPage> {
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'LocalLibraryManagerPage',
      child: Scaffold(
        appBar: MusilyAppBar(
          title: Text(context.localization.localLibraryTitle),
          actions: [
            IconButton(
              onPressed: _openAddPage,
              icon: const Icon(LucideIcons.plus),
              tooltip: context.localization.addLocalFolder,
            ),
          ],
        ),
        body: widget.libraryController.builder(
          builder: (context, libraryData) {
            final playlists = libraryData.localPlaylists;
            if (_isRefreshing) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 80),
              children: [
                if (playlists.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _EmptyState(
                      message: context.localization.emptyLocalLibrary,
                      description:
                          context.localization.emptyLocalLibraryDescription,
                    ),
                  )
                else
                  ...playlists.map(
                    (playlist) => LocalPlaylistTile(
                      playlist: playlist,
                      libraryController: widget.libraryController,
                      playerController: widget.playerController,
                      coreController: widget.coreController,
                      customClickAction: () => _openPlaylist(playlist),
                    ),
                  ),
                PlayerSizedBox(playerController: widget.playerController),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openAddPage() async {
    final result = await LyNavigator.push<bool>(
      context.showingPageContext,
      LocalPlaylistAdderPage(
        libraryController: widget.libraryController,
        coreController: widget.coreController,
        initialFolderPath: widget.initialFolderPath,
      ),
    );

    if (result == true) {
      setState(() {
        _isRefreshing = true;
      });
      await widget.libraryController.methods.refreshLocalPlaylists();
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _openPlaylist(LocalLibraryPlaylist playlist) async {
    LyNavigator.push(
      context.showingPageContext,
      LocalLibraryPlaylistPage(
        playlistId: playlist.id,
        libraryController: widget.libraryController,
        playerController: widget.playerController,
        coreController: widget.coreController,
        downloaderController: widget.downloaderController,
        getPlayableItemUsecase: widget.getPlayableItemUsecase,
        getAlbumUsecase: widget.getAlbumUsecase,
        getArtistUsecase: widget.getArtistUsecase,
        getArtistTracksUsecase: widget.getArtistTracksUsecase,
        getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
        getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
        getPlaylistUsecase: widget.getPlaylistUsecase,
        getTrackUsecase: widget.getTrackUsecase,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final String description;

  const _EmptyState({
    required this.message,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        Icon(
          LucideIcons.folderOpen,
          size: 48,
          color: context.themeData.colorScheme.primary.withValues(alpha: 0.6),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: context.themeData.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: context.themeData.textTheme.bodyMedium?.copyWith(
            color:
                context.themeData.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}

class LocalPlaylistAdderPage extends StatefulWidget {
  final LibraryController libraryController;
  final CoreController coreController;

  final String? initialFolderPath;

  const LocalPlaylistAdderPage({
    super.key,
    required this.libraryController,
    required this.coreController,
    this.initialFolderPath,
  });

  @override
  State<LocalPlaylistAdderPage> createState() => _LocalPlaylistAdderPageState();
}

class _LocalPlaylistAdderPageState extends State<LocalPlaylistAdderPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedPath;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialFolderPath != null) {
      _selectedPath = widget.initialFolderPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _selectedPath != null &&
        _nameController.text.trim().isNotEmpty &&
        !_saving;

    return LyPage(
      contextKey: 'LocalPlaylistAdderPage',
      child: Scaffold(
        appBar: MusilyAppBar(
          title: Text(context.localization.addLocalFolder),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.themeData.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: context.themeData.colorScheme.outline
                      .withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.themeData.colorScheme.primary
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      LucideIcons.folderPlus,
                      color: context.themeData.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.localization.addLocalFolder,
                          style: context.themeData.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.localization.manageLocalFoldersDescription,
                          style:
                              context.themeData.textTheme.bodyMedium?.copyWith(
                            color: context.themeData.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            LyTextField(
              controller: _nameController,
              labelText: context.localization.playlistName,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _saving ? null : _chooseDirectory,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: context.themeData.colorScheme.outline
                          .withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.folderOpenDot,
                        color: context.themeData.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedPath ?? context.localization.chooseDirectory,
                          style:
                              context.themeData.textTheme.bodyMedium?.copyWith(
                            color: _selectedPath == null
                                ? context.themeData.colorScheme.onSurface
                                    .withValues(alpha: 0.6)
                                : context.themeData.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        LucideIcons.chevronRight,
                        color: context.themeData.colorScheme.onSurface
                            .withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: LyOutlinedButton(
                    onPressed: _saving ? null : () => LyNavigator.pop(context),
                    child: Text(context.localization.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LyFilledButton(
                    onPressed: canSubmit ? _submit : null,
                    loading: _saving,
                    child: Text(context.localization.confirm),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _chooseDirectory() async {
    if (Platform.isAndroid) {
      await widget.coreController.methods.requestStoragePermission();
    }
    final path = await FilePicker.platform.getDirectoryPath();
    if (path != null && mounted) {
      setState(() {
        _selectedPath = path;
      });
    }
  }

  Future<void> _submit() async {
    final trimmedName = _nameController.text.trim();
    if (_selectedPath == null) {
      LySnackbar.showError(context.localization.chooseDirectory);
      return;
    }
    if (trimmedName.isEmpty) {
      LySnackbar.showError(context.localization.playlistName);
      return;
    }
    setState(() {
      _saving = true;
    });
    try {
      await widget.libraryController.methods.addLocalPlaylistFolder(
        trimmedName,
        _selectedPath!,
      );
      await widget.libraryController.methods.refreshLocalPlaylists();
      if (!mounted) return;
      LySnackbar.showSuccess(context.localization.playlistCreated);
      LyNavigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
      });
      LySnackbar.showError(context.localization.invalidDirectory);
    }
  }
}
