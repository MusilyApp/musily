import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/presenter/widgets/track_tile_static.dart';

class QueueWidget extends StatefulWidget {
  final PlayerController playerController;
  const QueueWidget({
    required this.playerController,
    super.key,
  });

  @override
  State<QueueWidget> createState() => _QueueWidgetState();
}

class _QueueWidgetState extends State<QueueWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.playerController.builder(
      builder: (context, data) {
        int currentIndex = 0;

        if (data.currentPlayingItem != null) {
          currentIndex = data.queue
              .indexWhere((item) => item.id == data.currentPlayingItem!.id);
        }

        final List<TrackEntity> nextSongs = [];
        final List<TrackEntity> prevSongs = [];

        try {
          if (currentIndex < data.queue.length - 1) {
            nextSongs.addAll(data.queue.sublist(currentIndex + 1));
          }

          if (currentIndex > 0) {
            prevSongs.addAll(data.queue.sublist(0, currentIndex));
          }
        } catch (e) {
          debugPrint('Error while splitting queue: $e');
        }

        final queue = [...nextSongs, ...prevSongs];

        return Column(
          children: [
            if (data.currentPlayingItem != null) ...[
              TrackTileStatic(track: data.currentPlayingItem!),
              // TODO: Localize String
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 12,
                  bottom: 12,
                ),
                child: Row(
                  children: [
                    Text(
                      'Queue',
                      textAlign: TextAlign.start,
                      style: context.themeData.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                child: ReorderableListView.builder(
                  scrollController: _scrollController,
                  itemCount: queue.length,
                  onReorder: (oldIndex, newIndex) async {
                    newIndex += prevSongs.length;
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    widget.playerController.methods
                        .reorderQueue(newIndex, oldIndex);
                  },
                  itemBuilder: (context, index) {
                    final track = queue[index];
                    return Container(
                      color: data.tracksFromSmartQueue.contains(track.hash)
                          ? context.themeData.colorScheme.primary
                              .withValues(alpha: .2)
                          : Colors.transparent,
                      margin: EdgeInsets.zero,
                      key: Key(index.toString()),
                      child: LyListTile(
                        onTap: () async {
                          final actualIndex = data.queue.indexWhere(
                            (item) => item.id == track.id,
                          );
                          await widget.playerController.methods
                              .queueJumpTo(actualIndex);
                        },
                        title: InfinityMarquee(
                          child: Text(
                            track.title,
                          ),
                        ),
                        subtitle: InfinityMarquee(
                          child: Text(
                            track.artist.name,
                          ),
                        ),
                        leading: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              width: 1,
                              color: context.themeData.colorScheme.outline
                                  .withValues(alpha: .2),
                            ),
                          ),
                          child: Builder(
                            builder: (context) {
                              if (track.lowResImg != null &&
                                  track.lowResImg!.isNotEmpty) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 40,
                                    child: AppImage(
                                      track.lowResImg!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }
                              return SizedBox(
                                height: 40,
                                width: 40,
                                child: Icon(
                                  Icons.music_note,
                                  color: context.themeData.iconTheme.color
                                      ?.withValues(alpha: .7),
                                ),
                              );
                            },
                          ),
                        ),
                        trailing: data.tracksFromSmartQueue
                                .contains(queue[index].hash)
                            ? Padding(
                                padding: EdgeInsets.only(
                                  right: context.display.isDesktop ? 24 : 0,
                                ),
                                child: Icon(
                                  CupertinoIcons.wand_stars,
                                  color: context.themeData.colorScheme.primary,
                                ),
                              )
                            : null,
                        key: Key('$index'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
