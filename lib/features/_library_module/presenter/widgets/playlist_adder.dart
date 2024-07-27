import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musily/core/presenter/routers/eighty_router.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/playlist_creator.dart';
import 'package:musily/features/_library_module/presenter/widgets/playlist_tile_thumb.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_icon.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class PlaylistAdder extends StatefulWidget {
  final LibraryController libraryController;
  final Widget Function(
    BuildContext context,
    Function() showAdder,
  ) builder;
  final Future<List<TrackEntity>> Function()? asyncTracks;
  final List<TrackEntity> tracks;
  final void Function()? onAdded;
  const PlaylistAdder(
    this.libraryController, {
    required this.builder,
    this.tracks = const [],
    this.asyncTracks,
    this.onAdded,
    super.key,
  });

  @override
  State<PlaylistAdder> createState() => _PlaylistAdderState();
}

class _PlaylistAdderState extends State<PlaylistAdder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      () {
        Navigator.push(
          context,
          SizedRouter(
            builder: (context) => _PlaylistAdderWidget(
              onAdded: widget.onAdded,
              libraryController: widget.libraryController,
              tracks: widget.tracks,
              asyncTracks: widget.asyncTracks,
            ),
          ),
        );
      },
    );
  }
}

class _PlaylistAdderWidget extends StatelessWidget {
  final List<TrackEntity> tracks;
  final Future<List<TrackEntity>> Function()? asyncTracks;
  final LibraryController libraryController;
  final void Function()? onAdded;
  const _PlaylistAdderWidget({
    required this.libraryController,
    this.tracks = const [],
    this.asyncTracks,
    this.onAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar à playlist'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: PlaylistCreator(
        libraryController,
        builder: (context, showCreator) => FloatingActionButton(
          onPressed: showCreator,
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
      body: libraryController.builder(builder: (context, data) {
        final playlist =
            data.items.whereType<LibraryItemEntity<PlaylistEntity>>().toList();
        bool trackIsAlreadyInPlaylist(List<TrackEntity> tracks) {
          if (this.tracks.length == 1) {
            return tracks
                .where(
                  (element) => element.hash == this.tracks.first.hash,
                )
                .isNotEmpty;
          }
          return false;
        }

        return Column(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  if (playlist.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.playlist_add,
                            size: 40,
                            color: Theme.of(context)
                                .iconTheme
                                .color
                                ?.withOpacity(.7),
                          ),
                          Text(
                            'Você não tem playlists.',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .iconTheme
                                  .color
                                  ?.withOpacity(.7),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView(
                    children: playlist
                        .map(
                          (item) => ListTile(
                            onTap: trackIsAlreadyInPlaylist(item.value.tracks)
                                ? null
                                : () async {
                                    Navigator.pop(context);
                                    late final List<TrackEntity> tracksToAdd;
                                    if (tracks.isEmpty) {
                                      tracksToAdd =
                                          await asyncTracks?.call() ?? [];
                                    } else {
                                      tracksToAdd = tracks;
                                    }
                                    libraryController.methods.addToPlaylist(
                                      tracksToAdd,
                                      item.id,
                                    );
                                    onAdded?.call();
                                  },
                            leading: item.value.id == 'favorites'
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: const FavoriteIcon(
                                      iconSize: 30,
                                    ),
                                  )
                                : PlaylistTileThumb(
                                    urls: item.value.tracks
                                        .map((track) => track.lowResImg
                                            ?.replaceAll('w60-h60', 'w40-h40'))
                                        .whereType<String>()
                                        .toSet()
                                        .toList()
                                      ..shuffle(
                                        Random(),
                                      ),
                                  ),
                            title: Text(
                              item.value.id == 'favorites'
                                  ? 'Favoritos'
                                  : item.value.title,
                              style: TextStyle(
                                color:
                                    trackIsAlreadyInPlaylist(item.value.tracks)
                                        ? Theme.of(context).disabledColor
                                        : null,
                              ),
                            ),
                            subtitle: Text(
                              'Playlist · ${item.value.tracks.length} músicas',
                              style: TextStyle(
                                color:
                                    trackIsAlreadyInPlaylist(item.value.tracks)
                                        ? Theme.of(context).disabledColor
                                        : null,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
