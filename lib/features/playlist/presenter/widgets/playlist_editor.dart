import 'package:flutter/material.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
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
          title: Text(context.localization.editPlaylist),
          actions: (context) => [
            LyFilledButton(
              onPressed: () {
                Navigator.pop(context);
                playlistNameController.text = widget.playlistEntity.title;
              },
              child: const Text('Cancelar'),
            ),
            LyFilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.libraryController.methods.updatePlaylist(
                    UpdatePlaylistDto(
                      id: widget.playlistEntity.id,
                      title: playlistNameController.text,
                    ),
                  );
                  Navigator.pop(context);
                  widget.onFinished?.call(
                    playlistNameController.text,
                  );
                }
              },
              child: Text(context.localization.confirm),
            ),
          ],
          builder: (context) => Form(
            key: _formKey,
            child: LyTextField(
              controller: playlistNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.localization.requiredField;
                }
                return null;
              },
            ),
          ),
        );
      },
    );
  }
}
