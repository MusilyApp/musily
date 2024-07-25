import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class FavoriteButton extends StatefulWidget {
  final TrackEntity track;
  final LibraryController libraryController;
  const FavoriteButton({
    required this.libraryController,
    required this.track,
    super.key,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return widget.libraryController.builder(
      builder: (context, data) {
        return IconButton(
          onPressed: data.addingToFavorites
              ? null
              : () async {
                  await widget.libraryController.methods.toggleFavorite(
                    widget.track,
                  );
                },
          icon: data.addingToFavorites
              ? LoadingAnimationWidget.threeArchedCircle(
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                )
              : Icon(
                  data.loadedFavoritesHash.contains(widget.track.hash)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: data.loadedFavoritesHash.contains(widget.track.hash)
                      ? Theme.of(context).buttonTheme.colorScheme?.primary
                      : null,
                ),
        );
      },
    );
  }
}
