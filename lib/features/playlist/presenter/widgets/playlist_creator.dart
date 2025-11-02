import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/string.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_text_field.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/ui/utils/ly_snackbar.dart';
import 'package:musily/features/_library_module/data/dtos/create_playlist_dto.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';

class PlaylistCreator extends StatefulWidget {
  final LibraryController libraryController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final CoreController coreController;
  final void Function(PlaylistEntity playlist)? onCreated;
  final Widget Function(
    BuildContext context,
    void Function() showCreator,
  ) builder;

  const PlaylistCreator(
    this.libraryController, {
    required this.builder,
    required this.coreController,
    required this.getPlaylistUsecase,
    this.onCreated,
    super.key,
  });

  @override
  State<PlaylistCreator> createState() => _PlaylistCreatorState();
}

class _PlaylistCreatorState extends State<PlaylistCreator> {
  final TextEditingController playlistNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  submitNameTextField(BuildContext context) async {
    final String textContent = playlistNameController.text;
    final RegExp playlistIdRegex = RegExp(r'([?&])list=([a-zA-Z0-9_-]+)');
    bool alreadyClosedDialog = false;
    late final PlaylistEntity playlist;

    if (_formKey.currentState!.validate()) {
      if (textContent.isUrl) {
        final match = playlistIdRegex.firstMatch(textContent);
        if (match != null) {
          final playlistId = match.group(2);
          if (playlistId != null) {
            if (!alreadyClosedDialog) {
              alreadyClosedDialog = true;
              Navigator.pop(widget.coreController.coreContext!);
            }
            LySnackbar.show('${context.localization.importingPlaylist}...');
            final retrievedPlaylist = await widget.getPlaylistUsecase.exec(
              playlistId,
            );
            if (retrievedPlaylist != null) {
              playlist = PlaylistEntity(
                id: retrievedPlaylist.id,
                title: retrievedPlaylist.title,
                trackCount: retrievedPlaylist.trackCount,
                tracks: retrievedPlaylist.tracks,
              );
            } else {
              LySnackbar.show(context.localization.playlistNotFound);
              return;
            }
          }
        }
      } else {
        playlist = PlaylistEntity(
          id: '',
          title: playlistNameController.text,
          trackCount: 0,
          tracks: [],
        );
      }

      if (!alreadyClosedDialog) {
        alreadyClosedDialog = true;
        Navigator.pop(widget.coreController.coreContext!);
      }

      widget.libraryController.methods.createPlaylist(
        CreatePlaylistDTO(
          title: playlist.title,
          id: playlist.id,
          tracks: playlist.tracks,
        ),
      );
      playlistNameController.text = '';
      widget.onCreated?.call(playlist);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, () {
      LyNavigator.showLyCardDialog(
        density: LyDensity.dense,
        context: widget.coreController.coreContext!,
        builder: (dialogContext) => Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: dialogContext.themeData.colorScheme.primary
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          LucideIcons.listPlus,
                          size: 20,
                          color: dialogContext.themeData.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dialogContext.localization.createPlaylist,
                              style: dialogContext
                                  .themeData.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dialogContext
                                  .localization.playlistCreatorSubtitle,
                              style: dialogContext.themeData.textTheme.bodySmall
                                  ?.copyWith(
                                color: dialogContext
                                    .themeData.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LyTextField(
                        autofocus: true,
                        controller: playlistNameController,
                        labelText: dialogContext.localization.playlistNameOrUrl,
                        hintText: dialogContext.localization.playlistNameOrUrl,
                        onSubmitted: (value) =>
                            submitNameTextField(dialogContext),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return dialogContext.localization.requiredField;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        dialogContext.localization.playlistCreatorPasteInfo,
                        style: dialogContext.themeData.textTheme.bodySmall
                            ?.copyWith(
                          color: dialogContext
                              .themeData.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Actions
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: LyOutlinedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            playlistNameController.text = '';
                          },
                          child: Text(dialogContext.localization.cancel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: LyFilledButton(
                          onPressed: () => submitNameTextField(dialogContext),
                          child: Text(dialogContext.localization.create),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
