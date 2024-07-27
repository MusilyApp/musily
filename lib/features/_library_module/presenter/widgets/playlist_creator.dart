import 'package:flutter/material.dart';
import 'package:musily/core/utils/id_generator.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';

class PlaylistCreator extends StatefulWidget {
  final LibraryController libraryController;
  final void Function(PlaylistEntity playlist)? onCreated;
  final Widget Function(
    BuildContext context,
    void Function() showCreator,
  ) builder;

  const PlaylistCreator(
    this.libraryController, {
    required this.builder,
    this.onCreated,
    super.key,
  });

  @override
  State<PlaylistCreator> createState() => _PlaylistCreatorState();
}

class _PlaylistCreatorState extends State<PlaylistCreator> {
  final TextEditingController playlistNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  submitNameTextField(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final playlist = PlaylistEntity(
        id: idGenerator(),
        title: playlistNameController.text,
        tracks: [],
      );
      widget.libraryController.methods.addToLibrary<PlaylistEntity>(
        playlist,
      );
      Navigator.pop(context);
      playlistNameController.text = '';
      widget.onCreated?.call(playlist);
    }
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
              title: const Text('Criar playlist'),
              content: TextFormField(
                autofocus: true,
                controller: playlistNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira um nome';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome da playlist',
                ),
                onFieldSubmitted: (value) => submitNameTextField(context),
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    playlistNameController.text = '';
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => submitNameTextField(context),
                  child: const Text('Criar'),
                )
              ],
            ),
          );
        },
      );
    });
  }
}
