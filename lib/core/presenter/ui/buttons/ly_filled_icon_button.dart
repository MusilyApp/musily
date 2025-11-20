import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';

class LyFilledIconButton extends StatefulWidget {
  final double? iconSize;
  final Size? fixedSize;
  final EdgeInsetsGeometry? margin;
  final LyDensity density;
  final double elevation;
  final FocusNode? focusNode;
  final void Function()? onFocus;
  final void Function()? onFocusOut;
  final void Function()? onPressed;
  final Widget? icon;
  final Widget? label;

  const LyFilledIconButton({
    super.key,
    this.icon,
    this.label,
    this.onPressed,
    this.onFocus,
    this.onFocusOut,
    this.density = LyDensity.normal,
    this.elevation = 0,
    this.focusNode,
    this.margin,
    this.iconSize,
    this.fixedSize,
  });

  @override
  State<LyFilledIconButton> createState() => _LyFilledIconButtonState();
}

class _LyFilledIconButtonState extends State<LyFilledIconButton> {
  late final FocusNode focusNode;
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      setState(() => hasFocus = focusNode.hasFocus);
      if (focusNode.hasFocus) {
        widget.onFocus?.call();
      } else {
        widget.onFocusOut?.call();
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeData;
    final colorScheme = theme.colorScheme;

    final bool enabled = widget.onPressed != null;
    final Color backgroundColor =
        hasFocus ? colorScheme.onPrimary : colorScheme.primary;
    final Color iconColor = !enabled
        ? theme.disabledColor
        : hasFocus
            ? colorScheme.primary
            : colorScheme.onPrimary;

    final Widget? iconWidget = widget.icon != null
        ? (widget.icon is Icon
            ? Icon(
                (widget.icon as Icon).icon,
                size: widget.iconSize ?? (widget.icon as Icon).size ?? 24.0,
                color: iconColor,
              )
            : widget.icon)
        : null;

    final Widget? labelWidget = widget.label;

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: MaterialButton(
        elevation: widget.elevation,
        focusNode: focusNode,
        onPressed: widget.onPressed,
        disabledColor: theme.disabledColor,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: hasFocus
              ? BorderSide(width: 1.5, color: colorScheme.onPrimary)
              : BorderSide.none,
        ),
        color: backgroundColor,
        minWidth:
            widget.fixedSize?.width ?? (labelWidget != null ? 80.0 : 56.0),
        height: widget.fixedSize?.height ?? 56.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconWidget != null) iconWidget,
            if (iconWidget != null && labelWidget != null)
              const SizedBox(width: 8),
            if (labelWidget != null)
              DefaultTextStyle(
                style: theme.textTheme.labelLarge!.copyWith(
                  color: iconColor,
                  fontWeight: FontWeight.w500,
                ),
                child: labelWidget,
              ),
          ],
        ),
      ),
    );
  }
}
