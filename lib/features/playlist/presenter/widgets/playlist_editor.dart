import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_text_field.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/features/_library_module/data/dtos/update_playlist_dto.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class PlaylistEditor extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    void Function() showEditor,
  ) builder;
  final LibraryController libraryController;
  final PlaylistEntity playlistEntity;
  final void Function(String name)? onFinished;
  const PlaylistEditor({
    super.key,
    required this.builder,
    required this.libraryController,
    required this.playlistEntity,
    this.onFinished,
  });

  @override
  State<PlaylistEditor> createState() => _PlaylistEditorState();
}

class _PlaylistEditorState extends State<PlaylistEditor> {
  final TextEditingController playlistNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    playlistNameController.text = widget.playlistEntity.title;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      () {
        LyNavigator.showLyCardDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: dialogContext.themeData.colorScheme.secondary
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            LucideIcons.pencilLine,
                            size: 20,
                            color:
                                dialogContext.themeData.colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dialogContext.localization.editPlaylist,
                                style: dialogContext
                                    .themeData.textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dialogContext.localization.playlistEditSubtitle,
                                style: dialogContext
                                    .themeData.textTheme.bodySmall
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: dialogContext
                            .themeData.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: dialogContext
                              .themeData.colorScheme.outlineVariant
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dialogContext.localization.playlistDetailsTitle,
                            style: dialogContext.themeData.textTheme.labelSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: dialogContext
                                  .themeData.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          LyTextField(
                            controller: playlistNameController,
                            labelText: dialogContext.localization.name,
                            onSubmitted: (_) {
                              _submit(dialogContext);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return dialogContext.localization.requiredField;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: LyOutlinedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              playlistNameController.text =
                                  widget.playlistEntity.title;
                            },
                            child: Text(dialogContext.localization.cancel),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: LyFilledButton(
                            onPressed: () => _submit(dialogContext),
                            child: Text(dialogContext.localization.confirm),
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
      },
    );
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      widget.libraryController.methods.updatePlaylist(
        UpdatePlaylistDto(
          id: widget.playlistEntity.id,
          title: playlistNameController.text,
        ),
      );
      Navigator.pop(context);
      widget.onFinished?.call(playlistNameController.text);
    }
  }
}
