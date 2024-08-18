import 'package:flutter/material.dart';
import 'package:musily/core/presenter/routers/sized_router.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/playlist_creator.dart';
import 'package:musily/features/_library_module/presenter/widgets/playlist_tile_thumb.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            builder: (context) => PlaylistAdderWidget(
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

class PlaylistAdderWidget extends StatelessWidget {
  final List<TrackEntity> tracks;
  final Future<List<TrackEntity>> Function()? asyncTracks;
  final LibraryController libraryController;
  final void Function()? onAdded;
  const PlaylistAdderWidget({
    super.key,
    required this.libraryController,
    this.tracks = const [],
    this.asyncTracks,
    this.onAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addToPlaylist),
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
                            AppLocalizations.of(context)!.noPlaylists,
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
                            onTap: () async {
                              Navigator.pop(context);
                              late final List<TrackEntity> tracksToAdd;
                              if (tracks.isEmpty) {
                                tracksToAdd = await asyncTracks?.call() ?? [];
                              } else {
                                tracksToAdd = tracks;
                              }
                              libraryController.methods.addToPlaylist(
                                tracksToAdd,
                                item.id,
                              );
                              onAdded?.call();
                            },
                            leading: PlaylistTileThumb(
                              playlist: item.value,
                              size: 30,
                            ),
                            title: Text(
                              item.value.id == 'favorites'
                                  ? AppLocalizations.of(context)!.favorites
                                  : item.value.title,
                            ),
                            subtitle: Text(
                              '${AppLocalizations.of(context)!.playlist} · ${item.value.trackCount} ${AppLocalizations.of(context)!.songs}',
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
