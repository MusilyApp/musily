import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class TrackLyrics extends StatefulWidget {
  final Duration totalDuration;
  final Duration currentPosition;
  final String lyrics;
  final bool synced;

  const TrackLyrics({
    super.key,
    required this.totalDuration,
    required this.currentPosition,
    required this.lyrics,
    required this.synced,
  });

  @override
  State<TrackLyrics> createState() => _TrackLyricsState();
}

class _TrackLyricsState extends State<TrackLyrics> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(covariant TrackLyrics oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.synced) {
      _updateScrollPosition();
    }
  }

  void _updateScrollPosition() {
    if (!widget.synced ||
        widget.totalDuration.inMilliseconds == 0 ||
        widget.currentPosition.inMilliseconds == 0) {
      return;
    }

    try {
      double scrollPercentage = widget.currentPosition.inMilliseconds /
          widget.totalDuration.inMilliseconds;
      double targetScrollOffset =
          (_scrollController?.position.maxScrollExtent ?? 0) * scrollPercentage;

      _scrollController?.animateTo(
        targetScrollOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      //
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 180),
                  Text(
                    widget.lyrics,
                    textAlign: TextAlign.center,
                    style: context.themeData.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.themeData.iconTheme.color?.withOpacity(.7),
                    ),
                  ),
                  const SizedBox(height: 180),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 30,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.themeData.colorScheme.inversePrimary,
                context.themeData.colorScheme.inversePrimary.withOpacity(.003),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.themeData.colorScheme.inversePrimary
                      .withOpacity(.003),
                  context.themeData.colorScheme.inversePrimary,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
