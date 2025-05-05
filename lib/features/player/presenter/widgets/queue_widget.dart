import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
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
  Widget build(BuildContext context) {
    return widget.playerController.builder(
      builder: (context, data) {
        return Column(
          children: [
            if (data.currentPlayingItem != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.localization.playingNow,
                      style: context.themeData.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      iconSize: 20,
                      onPressed: data.loadingSmartQueue
                          ? null
                          : () {
                              widget.playerController.methods
                                  .toggleSmartQueue();
                            },
                      icon: data.loadingSmartQueue
                          ? LoadingAnimationWidget.threeRotatingDots(
                              color: IconTheme.of(context).color ??
                                  context.themeData.primaryColor,
                              size: 20,
                            )
                          : Icon(
                              !data.autoSmartQueue
                                  ? CupertinoIcons.wand_rays_inverse
                                  : CupertinoIcons.wand_stars,
                              color: !data.autoSmartQueue
                                  ? IconTheme.of(context).color
                                  : context.themeData.colorScheme.primary,
                            ),
                    ),
                  ],
                ),
              ),
              TrackTileStatic(
                track: data.currentPlayingItem!,
              ),
              const Divider(),
            ],
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                child: ReorderableListView.builder(
                  scrollController: _scrollController,
                  itemCount: data.queue.length,
                  onReorder: (oldIndex, newIndex) async {
                    await widget.playerController.methods
                        .reorderQueue(newIndex, oldIndex);
                  },
                  itemBuilder: (context, index) {
                    final playing =
                        data.queue[index].id == data.currentPlayingItem?.id;
                    return Container(
                      color: data.tracksFromSmartQueue
                              .contains(data.queue[index].hash)
                          ? context.themeData.colorScheme.primary
                              .withValues(alpha: .2)
                          : Colors.transparent,
                      margin: EdgeInsets.zero,
                      key: Key(index.toString()),
                      child: LyListTile(
                        onTap: () async {
                          await widget.playerController.methods
                              .queueJumpTo(index);
                        },
                        title: InfinityMarquee(
                          child: Text(
                            data.queue[index].title,
                            style: playing
                                ? TextStyle(
                                    color: context.themeData.buttonTheme
                                        .colorScheme?.primary,
                                    fontWeight: FontWeight.bold,
                                  )
                                : null,
                          ),
                        ),
                        subtitle: InfinityMarquee(
                          child: Text(
                            data.queue[index].artist.name,
                            style: playing
                                ? TextStyle(
                                    color: context.themeData.buttonTheme
                                        .colorScheme?.primary,
                                  )
                                : null,
                          ),
                        ),
                        leading: playing && data.isPlaying
                            ? SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13.5,
                                  ),
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                    color: context.themeData.buttonTheme
                                            .colorScheme?.primary ??
                                        Colors.white,
                                    size: 21,
                                  ),
                                ),
                              )
                            : Card(
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
                                    if (data.queue[index].lowResImg != null &&
                                        data.queue[index].lowResImg!
                                            .isNotEmpty) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          width: 40,
                                          child: AppImage(
                                            data.queue[index].lowResImg!,
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
                                .contains(data.queue[index].hash)
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
