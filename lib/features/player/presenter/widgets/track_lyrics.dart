import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class TrackLyrics extends StatefulWidget {
  final Duration totalDuration;
  final Duration currentPosition;
  final String? lyrics;
  final TimedLyricsRes? timedLyrics;
  final bool synced;
  final Function(Duration)? onTimeSelected;

  const TrackLyrics({
    super.key,
    required this.totalDuration,
    required this.currentPosition,
    this.lyrics,
    this.timedLyrics,
    required this.synced,
    this.onTimeSelected,
  });

  @override
  State<TrackLyrics> createState() => _TrackLyricsState();
}

class _TrackLyricsState extends State<TrackLyrics> {
  ScrollController? _scrollController;
  int? _activeLineIndex;
  double _viewportHeight = 0;
  final Map<int, GlobalKey> _lineKeys = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _viewportHeight = 400;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateViewportSize();
      }
    });
  }

  @override
  void didUpdateWidget(covariant TrackLyrics oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.timedLyrics != null) {
      _updateActiveLine();
      if (_activeLineIndex != null) {
        _scrollToActiveLine();
      }
    } else if (widget.lyrics != null) {
      _scrollBasedOnPosition();
    }
  }

  void _updateViewportSize() {
    if (_scrollController?.hasClients == true && mounted) {
      final newViewportDimension =
          _scrollController!.position.viewportDimension;
      if (_viewportHeight != newViewportDimension) {
        setState(() {
          _viewportHeight = newViewportDimension;
        });
      }
    }
  }

  void _updateActiveLine() {
    if (widget.timedLyrics == null) return;

    final currentTimeMs = widget.currentPosition.inMilliseconds;
    int? newActiveLineIndex;

    for (int i = 0; i < widget.timedLyrics!.timedLyricsData.length; i++) {
      final lineData = widget.timedLyrics!.timedLyricsData[i];
      if (lineData.cueRange != null) {
        if (currentTimeMs >= lineData.cueRange!.startTimeMilliseconds &&
            currentTimeMs <= lineData.cueRange!.endTimeMilliseconds) {
          newActiveLineIndex = i;
          break;
        }
      }
    }

    if (_activeLineIndex != newActiveLineIndex) {
      setState(() {
        _activeLineIndex = newActiveLineIndex;
      });
    }
  }

  void _scrollToActiveLine() {
    if (!widget.synced ||
        _activeLineIndex == null ||
        _scrollController?.hasClients != true) {
      return;
    }

    try {
      final activeKey = _lineKeys[_activeLineIndex];
      if (activeKey == null || activeKey.currentContext == null) return;

      final RenderBox renderBox =
          activeKey.currentContext!.findRenderObject() as RenderBox;

      final position = renderBox.localToGlobal(Offset.zero);

      final size = renderBox.size;

      final scrollPosition = _scrollController!.position;
      final currentOffset = scrollPosition.pixels;

      final widgetPositionInScroll =
          position.dy - scrollPosition.viewportDimension / 2 + size.height / 2;

      final targetOffset = currentOffset + widgetPositionInScroll - 65;

      final clampedOffset =
          targetOffset.clamp(0.0, scrollPosition.maxScrollExtent);

      _scrollController?.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
      );
    } catch (e) {
      debugPrint('Error in _scrollToActiveLine: $e');
    }
  }

  void _scrollBasedOnPosition() {
    if (!widget.synced ||
        widget.totalDuration.inMilliseconds == 0 ||
        _scrollController?.hasClients != true) {
      return;
    }

    try {
      double scrollPercentage = widget.currentPosition.inMilliseconds /
          widget.totalDuration.inMilliseconds;
      double targetScrollOffset =
          (_scrollController?.position.maxScrollExtent ?? 0) * scrollPercentage;

      _scrollController?.animateTo(
        targetScrollOffset.clamp(
            0.0, _scrollController!.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      // Do nothing
    }
  }

  void _handleLineTap(TimedLyricsData lineData) {
    final bool canProcessTapBasics =
        lineData.cueRange != null && widget.onTimeSelected != null;

    if (!canProcessTapBasics) {
      return;
    }

    bool isCurrentlyScrolling = true;
    if (_scrollController != null && _scrollController!.hasClients) {
      isCurrentlyScrolling =
          _scrollController!.position.isScrollingNotifier.value;
    }

    if (isCurrentlyScrolling) {
      return;
    }

    final duration =
        Duration(milliseconds: lineData.cueRange!.startTimeMilliseconds);
    widget.onTimeSelected!(duration);
  }

  List<Widget> _buildTimedLyricsWidgets() {
    if (widget.timedLyrics == null ||
        widget.timedLyrics!.timedLyricsData.isEmpty) {
      return [
        SizedBox(height: _viewportHeight / 2),
        const Center(
          child: Text('No lyrics available'),
        ),
        SizedBox(height: _viewportHeight / 2),
      ];
    }

    for (int i = 0; i < widget.timedLyrics!.timedLyricsData.length; i++) {
      if (widget.timedLyrics!.timedLyricsData[i].lyricLine?.isNotEmpty ==
          true) {
        if (!_lineKeys.containsKey(i)) {
          _lineKeys[i] = GlobalKey();
        }
      }
    }

    final List<Widget> widgets = [SizedBox(height: _viewportHeight / 2)];

    for (int i = 0; i < widget.timedLyrics!.timedLyricsData.length; i++) {
      final lineData = widget.timedLyrics!.timedLyricsData[i];

      if (lineData.lyricLine?.isNotEmpty == true) {
        final isActive = _activeLineIndex == i;

        widgets.add(
          Container(
            key: _lineKeys[i],
            child: InkWell(
              onTap: () => _handleLineTap(lineData),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: context.themeData.textTheme.bodyLarge!.copyWith(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    color: isActive
                        ? context.themeData.iconTheme.color
                        : context.themeData.iconTheme.color
                            ?.withValues(alpha: 0.5),
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                  child: Text(lineData.lyricLine!),
                ),
              ),
            ),
          ),
        );
      }
    }

    widgets.add(SizedBox(height: _viewportHeight / 2));
    return widgets;
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _lineKeys.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateViewportSize();
      }
    });

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.white,
            Colors.white,
            Colors.transparent,
          ],
          stops: [0.0, 0.05, 0.95, 1],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 1),
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: widget.timedLyrics != null
                    ? _buildTimedLyricsWidgets()
                    : [
                        SizedBox(height: _viewportHeight / 2),
                        Text(
                          widget.lyrics ?? 'No lyrics available',
                          textAlign: TextAlign.center,
                          style:
                              context.themeData.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.themeData.iconTheme.color
                                ?.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: _viewportHeight / 2),
                      ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
