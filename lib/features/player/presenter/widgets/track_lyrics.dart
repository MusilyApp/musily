import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
  bool _showParsedWarning = true;

  bool get _showUnsyncedWarning {
    final timedLyrics = widget.timedLyrics;
    if (timedLyrics == null) return false;
    if (_timedLyricsHaveValidTiming) return false;
    return _convertedLyrics == null;
  }

  bool get _showParsedTimingWarning {
    return _wasConvertedFromBracketTiming && _showParsedWarning;
  }

  bool get _wasConvertedFromBracketTiming {
    final timedLyrics = widget.timedLyrics;
    if (timedLyrics == null) return false;
    if (_hasValidTiming(timedLyrics)) return false;
    return _convertedLyrics != null;
  }

  TimedLyricsRes? get _effectiveTimedLyrics {
    final timedLyrics = widget.timedLyrics;
    if (timedLyrics == null) return null;
    if (_hasValidTiming(timedLyrics)) {
      return timedLyrics;
    }
    return _convertedLyrics ?? timedLyrics;
  }

  bool get _hasTimedLyricsData {
    final timedLyrics = _effectiveTimedLyrics;
    if (timedLyrics == null) return false;
    return timedLyrics.timedLyricsData
        .any((data) => (data.lyricLine?.trim().isNotEmpty ?? false));
  }

  bool get _timedLyricsHaveValidTiming {
    final timedLyrics = _effectiveTimedLyrics;
    if (timedLyrics == null || !_hasTimedLyricsData) return false;
    return timedLyrics.timedLyricsData.any((data) {
      final range = data.cueRange;
      if (range == null) return false;
      final start = range.startTimeMilliseconds;
      final end = range.endTimeMilliseconds;
      return start > 0 || end > start;
    });
  }

  String? get _timedLyricsAsPlainText {
    final timedLyrics = _effectiveTimedLyrics;
    if (timedLyrics == null || !_hasTimedLyricsData) return null;
    final buffer = StringBuffer();
    for (final data in timedLyrics.timedLyricsData) {
      final line = data.lyricLine?.trim();
      if (line == null || line.isEmpty) continue;
      if (buffer.isNotEmpty) {
        buffer.writeln();
      }
      buffer.write(line);
    }
    return buffer.isEmpty ? null : buffer.toString();
  }

  bool _hasValidTiming(TimedLyricsRes lyrics) {
    return lyrics.timedLyricsData.any((data) {
      final range = data.cueRange;
      if (range == null) return false;
      final start = range.startTimeMilliseconds;
      final end = range.endTimeMilliseconds;
      return start > 0 || end > start;
    });
  }

  TimedLyricsRes? _convertBracketTimings(TimedLyricsRes lyrics) {
    final regex = RegExp(
      r"^\[(\d{2}):(\d{2})(?:[\.:](\d{1,3}))?\s*-\s*(\d{2}):(\d{2})(?:[\.:](\d{1,3}))?\]\s*(.*)$",
    );

    final convertedData = <TimedLyricsData>[];
    var hasMatches = false;

    for (int index = 0; index < lyrics.timedLyricsData.length; index++) {
      final data = lyrics.timedLyricsData[index];
      final rawLine = data.lyricLine?.trim();

      if (rawLine == null || rawLine.isEmpty) {
        convertedData.add(data);
        continue;
      }

      final match = regex.firstMatch(rawLine);
      if (match == null) {
        convertedData.add(data);
        continue;
      }

      hasMatches = true;

      final startMs = _parseTimeToMilliseconds(
        match.group(1)!,
        match.group(2)!,
        match.group(3),
      );
      final endMs = _parseTimeToMilliseconds(
        match.group(4)!,
        match.group(5)!,
        match.group(6),
      );
      final cleanedLine = match.group(7)?.trim();

      convertedData.add(
        TimedLyricsData(
          lyricLine: cleanedLine,
          cueRange: CueRange(
            startTimeMilliseconds: startMs,
            endTimeMilliseconds: endMs,
            metadata: CueRangeMetadata(id: 'converted_$index'),
          ),
        ),
      );
    }

    if (!hasMatches) {
      return null;
    }

    return TimedLyricsRes(
      timedLyricsData: convertedData,
      sourceMessage: lyrics.sourceMessage,
    );
  }

  TimedLyricsRes? get _convertedLyrics {
    final timedLyrics = widget.timedLyrics;
    if (timedLyrics == null) return null;
    if (_hasValidTiming(timedLyrics)) return null;
    final converted = _convertBracketTimings(timedLyrics);
    if (converted == null || !_hasValidTiming(converted)) {
      return null;
    }
    return converted;
  }

  int _parseTimeToMilliseconds(String minutes, String seconds, String? millis) {
    final mins = int.tryParse(minutes) ?? 0;
    final secs = int.tryParse(seconds) ?? 0;
    final fraction = millis == null || millis.isEmpty
        ? 0
        : int.tryParse(millis.padRight(3, '0').substring(0, 3)) ?? 0;
    return (mins * 60 * 1000) + (secs * 1000) + fraction;
  }

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

    if (_timedLyricsHaveValidTiming) {
      _updateActiveLine();
      if (_activeLineIndex != null) {
        _scrollToActiveLine();
      }
    } else {
      _lineKeys.clear();
      _activeLineIndex = null;
      if (widget.lyrics != null || _timedLyricsAsPlainText != null) {
        _scrollBasedOnPosition(force: !_timedLyricsHaveValidTiming);
      }
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
    if (!_timedLyricsHaveValidTiming) return;

    final timedLyrics = _effectiveTimedLyrics!;
    final currentTimeMs = widget.currentPosition.inMilliseconds;
    int? newActiveLineIndex;

    for (int i = 0; i < timedLyrics.timedLyricsData.length; i++) {
      final lineData = timedLyrics.timedLyricsData[i];
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
    if (!_timedLyricsHaveValidTiming ||
        !widget.synced ||
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

  void _scrollBasedOnPosition({bool force = false}) {
    if ((!widget.synced && !force) ||
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showParsedTimingWarning)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.themeData.colorScheme.primary
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.themeData.colorScheme.primary
                      .withValues(alpha: 0.18),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.themeData.colorScheme.primary
                          .withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      LucideIcons.sparkles,
                      size: 18,
                      color: context.themeData.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.localization.lyricsParsedSync,
                          style:
                              context.themeData.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.localization.lyricsParsedSyncDescription,
                          style:
                              context.themeData.textTheme.bodySmall?.copyWith(
                            color: context.themeData.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showParsedWarning = false;
                      });
                    },
                    icon: Icon(
                      LucideIcons.x,
                      size: 16,
                      color: context.themeData.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 16,
                  ),
                ],
              ),
            ),
          ),
        if (_showUnsyncedWarning)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.themeData.colorScheme.secondary
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.themeData.colorScheme.secondary
                      .withValues(alpha: 0.18),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.themeData.colorScheme.secondary
                          .withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      LucideIcons.info,
                      size: 18,
                      color: context.themeData.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.localization.lyricsNotSynced,
                          style:
                              context.themeData.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.localization.lyricsNotSyncedDescription,
                          style:
                              context.themeData.textTheme.bodySmall?.copyWith(
                            color: context.themeData.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        Expanded(
          child: ShaderMask(
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
                    child: _timedLyricsHaveValidTiming
                        ? _TimedLyricsContent(
                            lyrics: _effectiveTimedLyrics!,
                            activeLineIndex: _activeLineIndex,
                            lineKeys: _lineKeys,
                            viewportHeight: _viewportHeight,
                            onLineTap: _handleLineTap,
                          )
                        : _PlainLyricsContent(
                            lyricsText:
                                widget.lyrics ?? _timedLyricsAsPlainText,
                            viewportHeight: _viewportHeight,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimedLyricsContent extends StatelessWidget {
  final TimedLyricsRes lyrics;
  final int? activeLineIndex;
  final Map<int, GlobalKey> lineKeys;
  final double viewportHeight;
  final void Function(TimedLyricsData) onLineTap;

  const _TimedLyricsContent({
    required this.lyrics,
    required this.activeLineIndex,
    required this.lineKeys,
    required this.viewportHeight,
    required this.onLineTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final children = <Widget>[SizedBox(height: viewportHeight / 2)];

    lyrics.timedLyricsData.asMap().forEach((index, data) {
      final line = data.lyricLine;
      if (line == null || line.trim().isEmpty) {
        return;
      }

      lineKeys.putIfAbsent(index, () => GlobalKey());
      final isActive = activeLineIndex == index;

      children.add(
        Material(
          color: Colors.transparent,
          child: Container(
            key: lineKeys[index],
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () => onLineTap(data),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    color: isActive
                        ? theme.iconTheme.color
                        : theme.iconTheme.color?.withValues(alpha: 0.5),
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                  child: Text(line),
                ),
              ),
            ),
          ),
        ),
      );
    });

    children.add(SizedBox(height: viewportHeight / 2));

    return Column(children: children);
  }
}

class _PlainLyricsContent extends StatelessWidget {
  final String? lyricsText;
  final double viewportHeight;

  const _PlainLyricsContent({
    required this.lyricsText,
    required this.viewportHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayText = lyricsText?.trim().isNotEmpty == true
        ? lyricsText!.trim()
        : 'No lyrics available';

    return Column(
      children: [
        SizedBox(height: viewportHeight / 2),
        Text(
          displayText,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.iconTheme.color?.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: viewportHeight / 2),
      ],
    );
  }
}
