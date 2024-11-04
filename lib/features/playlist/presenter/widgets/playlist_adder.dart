import 'package:flutter/material.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/sized_router.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_creator.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_tile_thumb.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class PlaylistAdder extends StatefulWidget {
  final LibraryController libraryController;
  final CoreController coreController;
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
    required this.coreController,
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
              coreController: widget.coreController,
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
  final CoreController coreController;
  final void Function()? onAdded;
  const PlaylistAdderWidget({
    super.key,
    required this.libraryController,
    this.tracks = const [],
    this.asyncTracks,
    this.onAdded,
    required this.coreController,
  });

  @override
  Widget build(BuildContext context) {
    return LyPage(
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.localization.addToPlaylist),
        ),
        floatingActionButton: PlaylistCreator(
          libraryController,
          coreController: coreController,
          builder: (context, showCreator) => FloatingActionButton(
            onPressed: showCreator,
            child: const Icon(
              Icons.add,
            ),
          ),
        ),
        body: libraryController.builder(
          builder: (context, data) {
            final playlist =
                data.items.where((e) => e.playlist != null).toList();

            if (playlist.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.playlist_add,
                      size: 40,
                      color: context.themeData.iconTheme.color?.withOpacity(.7),
                    ),
                    Text(
                      context.localization.noPlaylists,
                      style: TextStyle(
                        color:
                            context.themeData.iconTheme.color?.withOpacity(.7),
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
                    (item) => LyListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        late final List<TrackEntity> tracksToAdd;
                        if (tracks.isEmpty) {
                          tracksToAdd = await asyncTracks?.call() ?? [];
                        } else {
                          tracksToAdd = tracks;
                        }
                        libraryController.methods.addTracksToPlaylist(
                          item.id,
                          tracksToAdd,
                        );
                        onAdded?.call();
                      },
                      leading: PlaylistTileThumb(
                        playlist: item.playlist!,
                        size: 30,
                      ),
                      title: Text(
                        item.playlist!.id == UserService.favoritesId
                            ? context.localization.favorites
                            : item.playlist!.title,
                      ),
                      subtitle: Text(
                        '${context.localization.playlist} · ${item.playlist!.trackCount} ${context.localization.songs}',
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
