import 'package:flutter/material.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_text_field.dart';
import 'package:musily/core/presenter/ui/utils/show_ly_dialog.dart';
import 'package:musily/core/utils/id_generator.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaylistCreator extends StatefulWidget {
  final LibraryController libraryController;
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
        trackCount: 0,
        tracks: [],
      );
      widget.libraryController.methods.addToLibrary<PlaylistEntity>(
        playlist,
      );
      Navigator.pop(widget.coreController.coreKey.currentContext!);
      playlistNameController.text = '';
      widget.onCreated?.call(playlist);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, () {
      showLyDialog(
        context: widget.coreController.coreKey.currentContext!,
        // height: 180,
        title: Text(AppLocalizations.of(context)!.createPlaylist),
        content: LyTextField(
          autofocus: true,
          controller: playlistNameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.requiredField;
            }
            return null;
          },
          hintText: AppLocalizations.of(context)!.playlistName,
          onSubmitted: (value) => submitNameTextField(context),
        ),
        actions: [
          LyFilledButton(
            onPressed: () {
              Navigator.pop(widget.coreController.coreKey.currentContext!);
              playlistNameController.text = '';
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          LyFilledButton(
            onPressed: () => submitNameTextField(context),
            child: Text(AppLocalizations.of(context)!.create),
          )
        ],
      );
    });
  }
}
