import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StoryPageView extends StatefulWidget {
  final List<Widget> pages;
  final Duration duration;
  final VoidCallback? onComplete;
  final Color indicatorColor;
  final Color indicatorBackgroundColor;
  final bool autoSkip;

  const StoryPageView({
    super.key,
    required this.pages,
    this.duration = const Duration(seconds: 5),
    this.onComplete,
    this.indicatorColor = Colors.white,
    this.indicatorBackgroundColor = Colors.white24,
    this.autoSkip = false,
  });

  @override
  State<StoryPageView> createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;
  Timer? _timer;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(vsync: this);
    if (widget.autoSkip) {
      _startTimer();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (!widget.autoSkip) return;

    _timer?.cancel();
    _animationController.reset();
    _animationController.duration = widget.duration;
    _animationController.forward();

    _timer = Timer(widget.duration, () {
      if (_currentPage < widget.pages.length - 1) {
        _nextPage();
      } else {
        widget.onComplete?.call();
      }
    });
  }

  void _nextPage() {
    if (_currentPage < widget.pages.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startTimer();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startTimer();
    }
  }

  void _pauseTimer() {
    if (!widget.autoSkip) return;
    _timer?.cancel();
    _animationController.stop();
  }

  void _resumeTimer() {
    if (!widget.autoSkip) return;
    final remaining = widget.duration * (1 - _animationController.value);
    _timer?.cancel();
    _animationController.duration = remaining;
    _animationController.forward();

    _timer = Timer(remaining, () {
      if (_currentPage < widget.pages.length - 1) {
        _nextPage();
      } else {
        widget.onComplete?.call();
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _previousPage();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _nextPage();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            GestureDetector(
              onTapDown: (_) => _pauseTimer(),
              onTapUp: (_) => _resumeTimer(),
              onTapCancel: _resumeTimer,
              onLongPress: _pauseTimer,
              onLongPressEnd: (_) => _resumeTimer,
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  if (_currentPage < widget.pages.length - 1) {
                    _nextPage();
                  }
                } else if (details.primaryVelocity! > 0) {
                  if (_currentPage > 0) {
                    _previousPage();
                  }
                }
              },
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.pages.length,
                itemBuilder: (context, index) {
                  return widget.pages[index];
                },
              ),
            ),
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _previousPage,
                      behavior: HitTestBehavior.translucent,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _nextPage,
                      behavior: HitTestBehavior.translucent,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: List.generate(
                      widget.pages.length,
                      (index) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: _StoryProgressIndicator(
                            isActive: index == _currentPage,
                            isCompleted: index < _currentPage,
                            animation: index == _currentPage
                                ? _animationController
                                : null,
                            color: widget.indicatorColor,
                            backgroundColor: widget.indicatorBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryProgressIndicator extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;
  final Animation<double>? animation;
  final Color color;
  final Color backgroundColor;

  const _StoryProgressIndicator({
    required this.isActive,
    required this.isCompleted,
    this.animation,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: AnimatedBuilder(
        animation: animation ?? const AlwaysStoppedAnimation(0),
        builder: (context, child) {
          double progress = 0.0;
          if (isCompleted) {
            progress = 1.0;
          } else if (isActive && animation != null) {
            progress = animation!.value;
          }

          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        },
      ),
    );
  }
}
