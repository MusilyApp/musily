import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';
import 'package:musily/features/wrapped/data/services/wrapped_share_service.dart';
import 'package:musily/features/wrapped/presenter/widgets/share_wrapped_button.dart';
import 'package:screenshot/screenshot.dart';

class WrappedPageContext {
  final int currentIndex;
  final int totalPages;
  final bool isFirstPage;
  final bool isLastPage;
  final WrappedEntity wrapped;
  final WrappedTheme theme;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool showShareButton;

  const WrappedPageContext({
    required this.currentIndex,
    required this.totalPages,
    required this.isFirstPage,
    required this.isLastPage,
    required this.wrapped,
    required this.theme,
    required this.onNext,
    required this.onPrevious,
    this.showShareButton = true,
  });
}

typedef WrappedPageBuilder = Widget Function(
    BuildContext context, WrappedPageContext pageContext);

class WrappedPageView extends StatefulWidget {
  final WrappedEntity wrapped;
  final WrappedTheme theme;
  final List<WrappedPageBuilder> pageBuilders;
  final void Function(int index)? onPageChanged;
  final void Function(int index)? onShare;
  final VoidCallback? onComplete;

  const WrappedPageView({
    super.key,
    required this.wrapped,
    required this.theme,
    required this.pageBuilders,
    this.onPageChanged,
    this.onShare,
    this.onComplete,
  });

  @override
  State<WrappedPageView> createState() => _WrappedPageViewState();
}

class _WrappedPageViewState extends State<WrappedPageView> {
  late PageController _pageController;
  final FocusNode _focusNode = FocusNode();
  final Map<int, ScreenshotController> _screenshotControllers = {};
  int _currentPage = 0;

  int get _totalPages => widget.pageBuilders.length;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
    _pageController = PageController();
    _initializeScreenshotControllers();
  }

  void _initializeScreenshotControllers() {
    for (int i = 0; i < _totalPages; i++) {
      _screenshotControllers[i] = ScreenshotController();
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _handlePageChange(int index) {
    setState(() {
      _currentPage = index;
    });
    widget.onPageChanged?.call(index);

    if (index == _totalPages - 1) {
      widget.onComplete?.call();
    }
  }

  void _handleShare() {
    final screenshotController = _screenshotControllers[_currentPage];
    if (screenshotController != null) {
      WrappedShareService.captureAndShare(
        controller: screenshotController,
        context: context,
        fileName: 'musily_wrapped_page_${_currentPage + 1}',
      );
    }
    widget.onShare?.call(_currentPage);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.pageDown:
        _nextPage();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.pageUp:
        _previousPage();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        Navigator.of(context).pop();
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  bool _shouldShowShareButton(int index) {
    return index != 0 && index != _totalPages - 1;
  }

  WrappedPageContext _createPageContext(int index) {
    return WrappedPageContext(
      currentIndex: index,
      totalPages: _totalPages,
      isFirstPage: index == 0,
      isLastPage: index == _totalPages - 1,
      wrapped: widget.wrapped,
      theme: widget.theme,
      onNext: _nextPage,
      onPrevious: _previousPage,
      showShareButton: _shouldShowShareButton(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.theme.effectivePalette;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: palette.background,
        body: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          onPageChanged: _handlePageChange,
          itemCount: _totalPages,
          itemBuilder: (context, index) => _WrappedPage(
            screenshotController: _screenshotControllers[index]!,
            pageBuilder: widget.pageBuilders[index],
            pageContext: _createPageContext(index),
            showShareButton: _shouldShowShareButton(index),
            onShare: _handleShare,
            palette: palette,
          ),
        ),
      ),
    );
  }
}

class _WrappedPage extends StatelessWidget {
  final ScreenshotController screenshotController;
  final WrappedPageBuilder pageBuilder;
  final WrappedPageContext pageContext;
  final bool showShareButton;
  final VoidCallback onShare;
  final WrappedPalette palette;

  const _WrappedPage({
    required this.screenshotController,
    required this.pageBuilder,
    required this.pageContext,
    required this.showShareButton,
    required this.onShare,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Screenshot(
          controller: screenshotController,
          child: pageBuilder(context, pageContext),
        ),
        if (showShareButton)
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + 24,
            child: Center(
              child: _AnimatedShareButton(
                onTap: onShare,
                palette: palette,
              ),
            ),
          ),
      ],
    );
  }
}

class _AnimatedShareButton extends StatefulWidget {
  final VoidCallback onTap;
  final WrappedPalette palette;

  const _AnimatedShareButton({
    required this.onTap,
    required this.palette,
  });

  @override
  State<_AnimatedShareButton> createState() => _AnimatedShareButtonState();
}

class _AnimatedShareButtonState extends State<_AnimatedShareButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _startAnimationDelayed();
  }

  void _startAnimationDelayed() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: ShareWrappedButton(
        onTap: widget.onTap,
        palette: widget.palette,
      ),
    );
  }
}
