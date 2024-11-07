import 'dart:async';
import 'package:flutter/material.dart';
import 'package:musily/features/_library_module/data/dtos/create_playlist_dto.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';

class LibraryToggler extends StatefulWidget {
  final LibraryItemEntity item;
  final LibraryController libraryController;
  final Widget Function(
    BuildContext context,
    Future<void> Function() addToLibrary,
  ) notInLibraryWidget;
  final Widget Function(
    BuildContext context,
    Future<void> Function() removeFromLibrary,
  ) inLibraryWidget;

  const LibraryToggler({
    required this.libraryController,
    required this.notInLibraryWidget,
    required this.item,
    required this.inLibraryWidget,
    super.key,
  });

  @override
  State<LibraryToggler> createState() => _LibraryTogglerState();
}

class _LibraryTogglerState extends State<LibraryToggler> {
  Timer? _debounceTimer;

  Future<void> _debounceAction(Future<void> Function() action) async {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      await action();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.libraryController.builder(
      builder: (context, data) {
        if (data.items.any((element) => element.id == widget.item.id)) {
          return widget.inLibraryWidget(
            context,
            () => _debounceAction(() async {
              if (widget.item.playlist != null) {
                await widget.libraryController.methods
                    .removePlaylistFromLibrary(
                  widget.item.id,
                );
              }
              if (widget.item.album != null) {
                await widget.libraryController.methods.removeAlbumFromLibrary(
                  widget.item.id,
                );
              }
              if (widget.item.artist != null) {
                await widget.libraryController.methods.removeArtistFromLibrary(
                  widget.item.id,
                );
              }
            }),
          );
        }
        return widget.notInLibraryWidget(
          context,
          () => _debounceAction(() async {
            if (widget.item.playlist != null) {
              await widget.libraryController.methods.createPlaylist(
                CreatePlaylistDTO(
                  title: widget.item.playlist!.title,
                ),
              );
            }
            if (widget.item.album != null) {
              await widget.libraryController.methods.addAlbumToLibrary(
                widget.item.album!,
              );
            }
            if (widget.item.artist != null) {
              await widget.libraryController.methods.addArtistToLibrary(
                widget.item.artist!,
              );
            }
          }),
        );
      },
    );
  }
}
