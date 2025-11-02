import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/presenter/widgets/track_tile_static.dart';

class QueueWidget extends StatefulWidget {
  final PlayerController playerController;
  final bool hideNowPlaying;
  final bool showSmartQueue;

  const QueueWidget({
    required this.playerController,
    super.key,
    this.hideNowPlaying = false,
    this.showSmartQueue = false,
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
          currentIndex = data.queue.indexWhere(
            (item) => item.id == data.currentPlayingItem!.id,
          );
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
              if (!widget.hideNowPlaying) ...[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          context.themeData.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: context.themeData.colorScheme.outline
                            .withValues(alpha: 0.15),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.themeData.colorScheme.primary
                              .withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TrackTileStatic(track: data.currentPlayingItem!),
                  ),
                ),
                // Queue Section Header
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 8,
                    bottom: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: context.themeData.colorScheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Queue',
                        style:
                            context.themeData.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else
                const SizedBox(height: 12),
            ],
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                radius: const Radius.circular(4),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    final scaffoldColor =
                        context.themeData.scaffoldBackgroundColor;
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        scaffoldColor,
                        scaffoldColor,
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.05, 0.95, 1],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: ReorderableListView.builder(
                    scrollController: _scrollController,
                    itemCount: queue.length,
                    onReorder: (oldIndex, newIndex) async {
                      newIndex += prevSongs.length;
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      widget.playerController.methods.reorderQueue(
                        newIndex,
                        oldIndex,
                      );
                    },
                    itemBuilder: (context, index) {
                      final track = queue[index];
                      final isSmartQueue =
                          data.tracksFromSmartQueue.contains(track.hash);

                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: isSmartQueue ? 12 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: isSmartQueue
                              ? context.themeData.colorScheme.primaryContainer
                                  .withValues(alpha: 0.4)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSmartQueue
                                ? context.themeData.colorScheme.primary
                                    .withValues(alpha: 0.3)
                                : Colors.transparent,
                            width: isSmartQueue ? 1.5 : 1,
                          ),
                        ),
                        key: Key(index.toString()),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              await widget.playerController.methods.queueJumpTo(
                                track.id,
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  // Track Artwork
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: track.lowResImg != null &&
                                              track.lowResImg!.isNotEmpty
                                          ? AppImage(
                                              track.lowResImg!,
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    context.themeData
                                                        .colorScheme.primary
                                                        .withValues(alpha: 0.6),
                                                    context.themeData
                                                        .colorScheme.primary
                                                        .withValues(alpha: 0.3),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                              ),
                                              child: Icon(
                                                LucideIcons.music,
                                                color: context.themeData
                                                    .colorScheme.onPrimary
                                                    .withValues(alpha: 0.7),
                                                size: 22,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Track Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InfinityMarquee(
                                          child: Text(
                                            track.title,
                                            style: context
                                                .themeData.textTheme.bodyMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              LucideIcons.micVocal,
                                              size: 12,
                                              color: context.themeData
                                                  .colorScheme.onSurfaceVariant
                                                  .withValues(alpha: 0.7),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: InfinityMarquee(
                                                child: Text(
                                                  track.artist.name,
                                                  style: context.themeData
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: context
                                                        .themeData
                                                        .colorScheme
                                                        .onSurfaceVariant
                                                        .withValues(alpha: 0.8),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Smart Queue Indicator
                                  if (isSmartQueue) ...[
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: context
                                            .themeData.colorScheme.primary
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        LucideIcons.sparkles,
                                        size: 16,
                                        color: context
                                            .themeData.colorScheme.primary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: context.display.isDesktop ? 8 : 4,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
