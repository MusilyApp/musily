import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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

class _QueueWidgetState extends State<QueueWidget>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<Offset> _slideOutAnimation;
  late Animation<Offset> _slideInAnimation;
  TrackEntity? _previousTrack;
  TrackEntity? _currentTrack;
  bool _isInitialized = false;
  bool _isGoingBack = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideOutAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideInAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Clean up animation state after completion
        setState(() {
          _previousTrack = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkForTrackChange(TrackEntity? newTrack, List<TrackEntity> queue) {
    if (!_isInitialized && newTrack != null) {
      // First time initialization - just set current track without animation
      _currentTrack = newTrack;
      _isInitialized = true;
      return;
    }

    if (_currentTrack?.id != newTrack?.id && newTrack != null) {
      // Store the previous track
      if (_currentTrack != null) {
        _previousTrack = _currentTrack;
      }

      // Determine if we're going back to a previous track
      if (_previousTrack != null && queue.isNotEmpty) {
        final currentIndex = queue.indexWhere((item) => item.id == newTrack.id);
        final prevIndex =
            queue.indexWhere((item) => item.id == _previousTrack!.id);

        // If previous index is greater than current, we're going backward
        _isGoingBack = prevIndex > currentIndex;
      }

      _currentTrack = newTrack;

      if (_previousTrack != null) {
        _animationController.reset();
        _animationController.forward();
      }

      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildNowPlayingHeader(
      BuildContext context, bool loadingSmartQueue, bool autoSmartQueue) {
    return Padding(
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
          Builder(
            builder: (context) {
              return IconButton(
                iconSize: 20,
                onPressed: loadingSmartQueue
                    ? null
                    : () {
                        widget.playerController.methods.toggleSmartQueue();
                      },
                icon: loadingSmartQueue
                    ? LoadingAnimationWidget.threeRotatingDots(
                        color: IconTheme.of(context).color ??
                            context.themeData.primaryColor,
                        size: 20,
                      )
                    : Icon(
                        !autoSmartQueue
                            ? CupertinoIcons.wand_rays_inverse
                            : CupertinoIcons.wand_stars,
                        color: !autoSmartQueue
                            ? IconTheme.of(context).color
                            : context.themeData.colorScheme.primary,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTrackWithAnimation(TrackEntity track) {
    if (_previousTrack == null || !_isInitialized) {
      // No animation needed for first render or when no previous track
      return TrackTileStatic(track: track);
    }

    return ClipRect(
      child: SizedBox(
        height: 72, // Adjust this height to match your TrackTileStatic height
        child: Stack(
          children: [
            SlideTransition(
              position: _isGoingBack
                  ? Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(0, 1),
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeInOut,
                    ))
                  : _slideOutAnimation,
              child: TrackTileStatic(
                track: _previousTrack!,
              ),
            ),
            SlideTransition(
              position: _isGoingBack
                  ? Tween<Offset>(
                      begin: const Offset(0, -1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeInOut,
                    ))
                  : _slideInAnimation,
              child: TrackTileStatic(
                track: track,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.playerController.builder(
      builder: (context, data) {
        int currentIndex = 0;

        if (data.currentPlayingItem != null) {
          currentIndex = data.queue
              .indexWhere((item) => item.id == data.currentPlayingItem!.id);

          // Check if track changed to trigger animation
          _checkForTrackChange(data.currentPlayingItem, data.queue);
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
              _buildNowPlayingHeader(
                  context, data.loadingSmartQueue, data.autoSmartQueue),
              _buildCurrentTrackWithAnimation(data.currentPlayingItem!),
              const Divider(),
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
