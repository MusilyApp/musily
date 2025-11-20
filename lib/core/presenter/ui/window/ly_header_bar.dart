import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/color_scheme.dart';
import 'package:musily/core/presenter/ui/window/ly_window_command_button.dart';
import 'package:window_manager/window_manager.dart';

class LyHeaderBar extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget>? leading;
  final Widget? middle;
  final List<Widget>? trailing;
  final PreferredSizeWidget? bottom;
  final double height;
  final double middleSpacing;
  final EdgeInsetsGeometry padding;
  final bool showLeading;
  final bool showTrailing;
  final bool showMaximizeButton;
  final bool showMinimizeButton;
  final bool showCloseButton;
  final bool showWindowControlsButtons;
  final Function? onWindowResize;
  const LyHeaderBar({
    super.key,
    this.leading,
    this.middle,
    this.trailing = const [],
    this.bottom,
    this.height = 44,
    this.middleSpacing = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.showLeading = true,
    this.showTrailing = true,
    this.showMaximizeButton = true,
    this.showMinimizeButton = true,
    this.showCloseButton = true,
    this.showWindowControlsButtons = true,
    this.onWindowResize,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  State<LyHeaderBar> createState() => _LyHeaderBarState();
}

class _LyHeaderBarState extends State<LyHeaderBar> with WindowListener {
  bool isFocused = true;
  bool isMaximized = false;
  @override
  void initState() {
    windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowFocus() {
    setState(() {
      isFocused = true;
    });
  }

  @override
  void onWindowBlur() {
    setState(() {
      isFocused = false;
    });
  }

  @override
  void onWindowMaximize() {
    setState(() {
      isMaximized = true;
    });
  }

  @override
  void onWindowUnmaximize() {
    setState(() {
      isMaximized = false;
    });
  }

  @override
  Future<void> onWindowResize() async {
    if (widget.onWindowResize != null) {
      widget.onWindowResize!(await windowManager.getSize());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? leading;
    leading = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (ModalRoute.of(context)!.canPop) const BackButton(),
        if (widget.leading != null)
          for (var item in widget.leading!) item,
      ],
    );

    Widget? trailing;
    if (!widget.showWindowControlsButtons) {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.leading != null)
            for (var item in widget.trailing!) item,
        ],
      );
    } else {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.leading != null)
            for (var item in widget.trailing!) item,
          if (widget.showMinimizeButton)
            LyWindowCommandButton(
              onPressed: windowManager.minimize,
              icon: Icons.remove,
              isFocused: isFocused,
            ),
          const SizedBox(width: 14),
          if (widget.showMaximizeButton)
            LyWindowCommandButton(
              onPressed: () async {
                isMaximized
                    ? await windowManager.unmaximize()
                    : await windowManager.maximize();
              },
              icon: Icons.crop_square_sharp,
              isFocused: isFocused,
            ),
          const SizedBox(width: 14),
          if (widget.showCloseButton)
            LyWindowCommandButton(
              onPressed: windowManager.close,
              icon: Icons.close_rounded,
              isFocused: isFocused,
            ),
        ],
      );
    }

    return GestureDetector(
      onSecondaryTap: () {
        windowManager.popUpWindowMenu();
      },
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: widget.height),
                child: Container(
                  decoration: BoxDecoration(
                    color: isFocused
                        ? context.themeData.scaffoldBackgroundColor
                        : context.themeData.colorScheme.onScaffold,
                    border: Border(
                      bottom: BorderSide(
                        color: context.themeData.iconTheme.color
                                ?.withValues(alpha: 0.1) ??
                            Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onDoubleTap: () async {
                      isMaximized
                          ? await windowManager.unmaximize()
                          : await windowManager.maximize();
                    },
                    onPanStart: (_) => onPanStart(),
                    child: Padding(
                      padding: widget.padding,
                      child: NavigationToolbar(
                        middleSpacing: widget.middleSpacing,
                        leading: leading,
                        middle: widget.middle,
                        trailing: trailing,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            widget.bottom ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  void onPanStart() async => await windowManager.startDragging();
  void onDoubleTap() async => isMaximized
      ? await windowManager.unmaximize()
      : await windowManager.maximize();
}
