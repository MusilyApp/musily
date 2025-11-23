import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';

class LyOutlinedButton extends StatefulWidget {
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
  final Widget? icon;

  const LyOutlinedButton({
    super.key,
    this.child,
    this.icon,
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
  });

  @override
  State<LyOutlinedButton> createState() => _LyOutlinedButtonState();
}

class _LyOutlinedButtonState extends State<LyOutlinedButton> {
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
    final bool isDisabled = widget.onPressed == null;

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: MaterialButton(
        elevation: widget.elevation,
        focusNode: focusNode,
        padding: EdgeInsets.zero,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        visualDensity: VisualDensity.compact,
        onPressed: isDisabled ? null : widget.onPressed,
        shape: widget.shape ??
            RoundedRectangleBorder(
              side: BorderSide(
                width: hasFocus ? 1.5 : 1,
                color: hasFocus
                    ? context.themeData.colorScheme.primary
                    : context.themeData.colorScheme.outline
                        .withValues(alpha: 0.3),
              ),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
            ),
        color: Colors.transparent,
        minWidth: widget.fullWidth ? double.maxFinite : null,
        child: Padding(
          padding: widget.contentPadding ??
              EdgeInsets.all(() {
                switch (widget.density) {
                  case LyDensity.normal:
                    return 8.0;
                  case LyDensity.comfortable:
                    return 12.0;
                  case LyDensity.dense:
                    return 0.0;
                }
              }()),
          child: _ButtonContent(
            icon: widget.icon,
            child: widget.child,
            isDisabled: isDisabled,
            hasFocus: hasFocus,
          ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final Widget? icon;
  final Widget? child;
  final bool isDisabled;
  final bool hasFocus;

  const _ButtonContent({
    this.icon,
    this.child,
    required this.isDisabled,
    required this.hasFocus,
  });

  Color? _getDefaultColor(BuildContext context) {
    if (isDisabled) {
      return context.themeData.colorScheme.onSurface.withValues(alpha: 0.38);
    }
    return hasFocus
        ? context.themeData.colorScheme.primary
        : context.themeData.colorScheme.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final defaultColor = _getDefaultColor(context);

        Widget? iconWidget;
        if (icon != null) {
          if (icon is Icon) {
            final originalIcon = icon as Icon;
            if (originalIcon.color == null && defaultColor != null) {
              iconWidget = Icon(
                originalIcon.icon,
                size: originalIcon.size,
                color: defaultColor,
                semanticLabel: originalIcon.semanticLabel,
                textDirection: originalIcon.textDirection,
              );
            } else {
              iconWidget = originalIcon;
            }
          } else if (defaultColor != null) {
            iconWidget = IconTheme(
              data: IconThemeData(color: defaultColor),
              child: icon!,
            );
          } else {
            iconWidget = icon;
          }
        }

        Widget? textWidget;
        if (child is Text && (child as Text).style == null) {
          final Text originalText = child as Text;
          textWidget = Text(
            originalText.data ?? '',
            style: TextStyle(color: defaultColor),
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
        } else if (child != null) {
          textWidget = child;
        }

        if (iconWidget != null && textWidget != null) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(width: 8),
              textWidget,
            ],
          );
        }

        return iconWidget ?? textWidget ?? const SizedBox.shrink();
      },
    );
  }
}
