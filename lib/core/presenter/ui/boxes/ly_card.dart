import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';

class LyCard extends StatefulWidget {
  final Widget? header;
  final EdgeInsetsGeometry headerPadding;
  final Widget? content;
  final Widget? footer;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final LyDensity density;
  final double elevation;
  final FocusNode? focusNode;
  final BorderRadius? borderRadius;
  final ShapeBorder? shape;
  final void Function()? onFocus;
  final void Function()? onFocusOut;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? onInitState;
  final void Function()? onDispose;
  final double? width;
  final double? height;
  final Duration transitionDuration;
  final Widget Function(Widget, Animation<double>)? transitionBuilder;

  const LyCard({
    super.key,
    this.header,
    this.content,
    this.footer,
    this.margin,
    this.padding,
    this.density = LyDensity.normal,
    this.headerPadding = const EdgeInsets.all(12),
    this.elevation = 1.0,
    this.focusNode,
    this.borderRadius,
    this.shape,
    this.onFocus,
    this.onFocusOut,
    this.onTap,
    this.onLongPress,
    this.onInitState,
    this.onDispose,
    this.width,
    this.height,
    this.transitionDuration = const Duration(milliseconds: 200),
    this.transitionBuilder,
  });

  @override
  State<LyCard> createState() => _LyCardState();
}

class _LyCardState extends State<LyCard> {
  FocusNode? focusNode;
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      focusNode = widget.focusNode;
      focusNode!.addListener(_handleFocusChange);
    }
    widget.onInitState?.call();
  }

  @override
  void dispose() {
    focusNode?.removeListener(_handleFocusChange);
    focusNode?.dispose();
    widget.onDispose?.call();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      hasFocus = focusNode?.hasFocus ?? false;
    });
    if (hasFocus) {
      widget.onFocus?.call();
    } else {
      widget.onFocusOut?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.transitionDuration,
      transitionBuilder: widget.transitionBuilder ?? _defaultTransitionBuilder,
      child: Padding(
        key: ValueKey(hasFocus),
        padding: widget.margin ?? EdgeInsets.zero,
        child: Material(
          elevation: widget.elevation,
          color: hasFocus
              ? context.themeData.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.1)
              : context.themeData.colorScheme.surface,
          shape: widget.shape ??
              RoundedRectangleBorder(
                side: hasFocus
                    ? BorderSide(
                        color: context.themeData.colorScheme.primary,
                        width: 2.0,
                      )
                    : BorderSide(
                        color: context.themeData.colorScheme.primary
                            .withValues(alpha: .1),
                        width: 2.0,
                      ),
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              ),
          child: InkWell(
            focusNode: focusNode,
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            child: Container(
              width: widget.width,
              height: widget.height,
              padding: widget.padding ??
                  EdgeInsets.all(
                    () {
                      switch (widget.density) {
                        case LyDensity.normal:
                          return 16.0;
                        case LyDensity.comfortable:
                          return 24.0;
                        case LyDensity.dense:
                          return 8.0;
                      }
                    }(),
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.header != null)
                    Padding(
                      padding: widget.headerPadding,
                      child: _buildHeader(context, widget.header!),
                    ),
                  if (widget.content != null) ...[
                    if (widget.header != null) const SizedBox(height: 8.0),
                    widget.content!,
                  ],
                  if (widget.footer != null) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                        right: 12,
                      ),
                      child: widget.footer!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Widget header) {
    if (header is Text) {
      return Text(
        header.data ?? '',
        style: context.themeData.textTheme.headlineSmall?.copyWith(
          color: hasFocus
              ? context.themeData.colorScheme.primary
              : context.themeData.colorScheme.onSurface,
        ),
      );
    }
    return header;
  }

  Widget _defaultTransitionBuilder(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
