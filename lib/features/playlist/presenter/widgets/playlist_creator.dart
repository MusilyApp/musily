import 'package:flutter/material.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/string.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
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
    late final PlaylistEntity playlist;

    if (_formKey.currentState!.validate()) {
      if (textContent.isUrl) {
        final match = playlistIdRegex.firstMatch(textContent);
        if (match != null) {
          final playlistId = match.group(2);
          if (playlistId != null) {
            Navigator.pop(widget.coreController.coreContext!);
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

      Navigator.pop(widget.coreController.coreContext!);
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
        context: widget.coreController.coreContext!,
        title: Text(context.localization.createPlaylist),
        builder: (context) => Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: LyTextField(
              autofocus: true,
              controller: playlistNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.localization.requiredField;
                }
                return null;
              },
              hintText: context.localization.playlistNameOrUrl,
              onSubmitted: (value) => submitNameTextField(context),
            ),
          ),
        ),
        actions: (context) => [
          LyFilledButton(
            onPressed: () {
              Navigator.pop(widget.coreController.coreContext!);
              playlistNameController.text = '';
            },
            child: Text(context.localization.cancel),
          ),
          LyFilledButton(
            onPressed: () =>
                submitNameTextField(widget.coreController.coreContext!),
            child: Text(context.localization.create),
          )
        ],
      );
    });
  }
}
