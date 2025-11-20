import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class FavoriteButton extends StatefulWidget {
  final TrackEntity track;
  final LibraryController libraryController;
  final Color? color;

  const FavoriteButton({
    required this.libraryController,
    required this.track,
    this.color,
    super.key,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  Timer? _debounceTimer;

  void _onFavoritePressed() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      final data = widget.libraryController.data;

      if (!data.loadedFavoritesHash.contains(widget.track.hash)) {
        await widget.libraryController.methods.addTracksToPlaylist(
          UserService.favoritesId,
          [widget.track],
        );
      } else {
        await widget.libraryController.methods.removeTracksFromPlaylist(
          UserService.favoritesId,
          [widget.track.id],
        );
      }
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
        return IconButton(
          onPressed: data.itemsAddingToFavorites.contains(widget.track.hash)
              ? null
              : _onFavoritePressed,
          icon: data.itemsAddingToFavorites.contains(widget.track.hash)
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )
              : Icon(
                  data.loadedFavoritesHash.contains(widget.track.hash)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: data.loadedFavoritesHash.contains(widget.track.hash)
                      ? widget.color ??
                          context.themeData.buttonTheme.colorScheme?.primary
                      : null,
                ),
        );
      },
    );
  }
}
