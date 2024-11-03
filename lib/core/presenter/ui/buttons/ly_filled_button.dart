import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';

class LyFilledButton extends StatefulWidget {
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final LyDensity density;
  final double elevation;
  final bool fullWidth;
  final FocusNode? focusNode;
  final void Function()? onFocus;
  final void Function()? onFocusOut;
  final void Function()? onPressed;
  final ShapeBorder? shape;
  final Widget? child;
  final bool loading;
  final Color? color;

  const LyFilledButton({
    super.key,
    this.child,
    this.onPressed,
    this.onFocus,
    this.onFocusOut,
    this.density = LyDensity.normal,
    this.elevation = 0,
    this.focusNode,
    this.contentPadding,
    this.margin,
    this.fullWidth = false,
    this.borderRadius,
    this.shape,
    this.loading = false,
    this.color,
  });

  @override
  State<LyFilledButton> createState() => _LyFilledButtonState();
}

class _LyFilledButtonState extends State<LyFilledButton> {
  late final FocusNode focusNode;
  bool hasFocus = false;

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      setState(() {
        hasFocus = focusNode.hasFocus;
      });
      if (focusNode.hasFocus) {
        widget.onFocus?.call();
      } else {
        widget.onFocusOut?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.loading;

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: MaterialButton(
        elevation: widget.elevation,
        focusNode: focusNode,
        onPressed: isDisabled ? null : widget.onPressed,
        shape: widget.shape ??
            RoundedRectangleBorder(
              side: hasFocus && !isDisabled
                  ? BorderSide(
                      width: 2,
                      strokeAlign: 1,
                      color: context.themeData.colorScheme.primary,
                    )
                  : const BorderSide(
                      color: Colors.transparent,
                    ),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            ),
        disabledColor: context.themeData.disabledColor,
        color: widget.color ??
            (hasFocus
                ? context.themeData.colorScheme.onPrimary
                : context.themeData.colorScheme.primary),
        minWidth: widget.fullWidth ? double.maxFinite : null,
        child: Padding(
          padding: widget.contentPadding ??
              EdgeInsets.all(
                () {
                  switch (widget.density) {
                    case LyDensity.normal:
                      return 8.0;
                    case LyDensity.comfortable:
                      return 12.0;
                    case LyDensity.dense:
                      return 0.0;
                  }
                }(),
              ),
          child: widget.loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.themeData.colorScheme.onPrimary,
                    ),
                  ),
                )
              : Builder(
                  builder: (context) {
                    if (widget.child is Text &&
                        (widget.child as Text).style == null) {
                      final Text originalText = widget.child as Text;
                      return Text(
                        originalText.data ?? '',
                        style: TextStyle(
                          color: isDisabled
                              ? context.themeData.colorScheme.onSurface
                                  .withOpacity(0.38)
                              : widget.color == null
                                  ? (hasFocus
                                      ? context.themeData.colorScheme.primary
                                      : context.themeData.colorScheme.onPrimary)
                                  : null,
                        ),
                        strutStyle: originalText.strutStyle,
                        textAlign: originalText.textAlign,
                        textDirection: originalText.textDirection,
                        locale: originalText.locale,
                        softWrap: originalText.softWrap,
                        overflow: originalText.overflow,
                        textScaler: originalText.textScaler,
                        maxLines: originalText.maxLines,
                        semanticsLabel: originalText.semanticsLabel,
                        textWidthBasis: originalText.textWidthBasis,
                        textHeightBehavior: originalText.textHeightBehavior,
                        selectionColor: originalText.selectionColor,
                      );
                    }
                    return widget.child ?? const SizedBox.shrink();
                  },
                ),
        ),
      ),
    );
  }
}
