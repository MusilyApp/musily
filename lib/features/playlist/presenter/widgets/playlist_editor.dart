import 'package:flutter/material.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return widget.builder(context, () {
      showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              title: Text(AppLocalizations.of(context)!.editPlaylist),
              content: TextFormField(
                controller: playlistNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.requiredField;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.playlistName,
                ),
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    playlistNameController.text = widget.playlistEntity.title;
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.libraryController.methods.updatePlaylistName(
                        widget.playlistEntity.id,
                        playlistNameController.text,
                      );
                      Navigator.pop(context);
                      widget.onFinished?.call(playlistNameController.text);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.confirm),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
