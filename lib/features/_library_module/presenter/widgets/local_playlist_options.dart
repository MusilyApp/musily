import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/domain/entities/app_menu_entry.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_tonal_icon_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_menu.dart';
import 'package:musily/features/_library_module/domain/entities/local_library_playlist.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/local_playlist_static_tile.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';

class LocalPlaylistOptions extends StatelessWidget {
  final LocalLibraryPlaylist playlist;
  final CoreController coreController;
  final PlayerController playerController;
  final LibraryController libraryController;
  final bool tonal;
  final double? iconSize;

  const LocalPlaylistOptions({
    super.key,
    required this.playlist,
    required this.coreController,
    required this.playerController,
    required this.libraryController,
    this.tonal = false,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return AppMenu(
      coreController: coreController,
      modalHeader: LocalPlaylistStaticTile(playlist: playlist),
      toggler: (context, invoke) {
        if (tonal) {
          return LyTonalIconButton(
            onPressed: invoke,
            fixedSize: const Size(55, 55),
            icon: Icon(
              LucideIcons.ellipsis,
              size: iconSize ?? 20,
              color: context.themeData.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          );
        }
        return IconButton(
          onPressed: invoke,
          icon: Icon(
            LucideIcons.ellipsisVertical,
            size: iconSize ?? 20,
            color:
                context.themeData.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        );
      },
      entries: [
        AppMenuEntry(
          leading: Icon(
            LucideIcons.refreshCw,
            size: 20,
            color: context.themeData.buttonTheme.colorScheme?.primary,
          ),
          onTap: () async {
            await libraryController.methods.refreshLocalPlaylists();
          },
          title: Text(context.localization.refresh),
        ),
        AppMenuEntry(
          leading: Icon(
            LucideIcons.pencil,
            size: 20,
            color: context.themeData.buttonTheme.colorScheme?.primary,
          ),
          onTap: () => _handleRename(context),
          title: Text(context.localization.renameLocalFolder),
        ),
        AppMenuEntry(
          leading: Icon(
            LucideIcons.folderSync,
            size: 20,
            color: context.themeData.buttonTheme.colorScheme?.primary,
          ),
          onTap: () => _handleUpdateDirectory(context),
          title: Text(context.localization.updateDirectory),
        ),
        AppMenuEntry(
          leading: const Icon(
            LucideIcons.trash,
            size: 20,
            color: Colors.red,
          ),
          onTap: () => _handleRemove(context),
          title: Text(
            context.localization.removeLocalFolder,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Future<void> _handleRename(BuildContext context) async {
    final nameController = TextEditingController(text: playlist.name);
    final result = await LyNavigator.showLyCardDialog<bool>(
      context: context,
      title: Text(context.localization.renameLocalFolder),
      builder: (context) => TextField(
        controller: nameController,
        autofocus: true,
        decoration: InputDecoration(
          labelText: context.localization.playlistName,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: (context) => [
        LyFilledButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.localization.cancel),
        ),
        LyFilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(context.localization.save),
        ),
      ],
    );
    if (result == true && nameController.text.isNotEmpty) {
      await libraryController.methods.renameLocalPlaylistFolder(
        playlist.id,
        nameController.text,
      );
    }
    nameController.dispose();
  }

  Future<void> _handleUpdateDirectory(BuildContext context) async {
    final newPath = await LyNavigator.showLyCardDialog<String>(
      context: context,
      width: 300,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      barrierDismissible: false,
      builder: (dialogContext) => _UpdateDirectoryDialog(
        playlist: playlist,
        coreController: coreController,
      ),
    );
    if (newPath != null) {
      await libraryController.methods.updateLocalPlaylistDirectory(
        playlist.id,
        newPath,
      );
      await libraryController.methods.refreshLocalPlaylists();
    }
  }

  Future<void> _handleRemove(BuildContext context) async {
    final confirm = await LyNavigator.showLyCardDialog<bool>(
      context: context,
      width: 300,
      padding: EdgeInsets.zero,
      barrierDismissible: false,
      builder: (dialogContext) => _RemoveLocalPlaylistDialog(
        playlist: playlist,
      ),
    );
    if (confirm == true) {
      await libraryController.methods.removeLocalPlaylistFolder(playlist.id);
      await libraryController.methods.refreshLocalPlaylists();
      if (context.mounted) {
        LyNavigator.pop(context);
      }
    }
  }
}

class _UpdateDirectoryDialog extends StatefulWidget {
  final LocalLibraryPlaylist playlist;
  final CoreController coreController;

  const _UpdateDirectoryDialog({
    required this.playlist,
    required this.coreController,
  });

  @override
  State<_UpdateDirectoryDialog> createState() => _UpdateDirectoryDialogState();
}

class _UpdateDirectoryDialogState extends State<_UpdateDirectoryDialog> {
  String? _selectedPath;
  bool _picking = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.themeData;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  LucideIcons.folderSync,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localization.updateDirectory,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.localization.updateDirectoryDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: _picking ? null : _pickDirectory,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.folderOpenDot,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedPath ??
                        widget.playlist.directoryPath.replaceAll('\\', '/'),
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  LucideIcons.chevronRight,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: LyOutlinedButton(
                onPressed: _picking
                    ? null
                    : () {
                        LyNavigator.pop(context);
                      },
                child: Text(context.localization.cancel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LyFilledButton(
                onPressed: _selectedPath == null || _picking
                    ? null
                    : _confirmSelection,
                child: Text(context.localization.confirm),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDirectory() async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      if (Platform.isAndroid) {
        await widget.coreController.methods.requestStoragePermission();
      }
      final path = await FilePicker.platform.getDirectoryPath();
      if (path != null && mounted) {
        setState(() {
          _selectedPath = path;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _picking = false);
      }
    }
  }

  void _confirmSelection() {
    if (_selectedPath == null) return;
    LyNavigator.pop(context, _selectedPath);
  }
}

class _RemoveLocalPlaylistDialog extends StatelessWidget {
  final LocalLibraryPlaylist playlist;

  const _RemoveLocalPlaylistDialog({
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeData;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              LucideIcons.trash2,
              size: 36,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.localization.removeLocalFolder,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.localization.removeLocalFolderConfirmation(playlist.name),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: LyOutlinedButton(
                  onPressed: () => LyNavigator.pop(context, false),
                  child: Text(context.localization.cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LyFilledButton(
                  onPressed: () => LyNavigator.pop(context, true),
                  color: theme.colorScheme.error,
                  child: Text(
                    context.localization.remove,
                    style: TextStyle(
                      color: theme.colorScheme.onError,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
