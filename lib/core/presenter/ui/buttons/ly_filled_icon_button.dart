import 'package:flutter/material.dart';
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
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: MaterialButton(
        elevation: widget.elevation,
        focusNode: focusNode,
        onPressed: widget.onPressed,
        shape: CircleBorder(
          side: hasFocus
              ? BorderSide(
                  width: 2,
                  color: Theme.of(context).colorScheme.primary,
                )
              : const BorderSide(
                  color: Colors.transparent,
                ),
        ),
        color: hasFocus
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.primary,
        minWidth: widget.fixedSize?.width ?? 56.0,
        height: widget.fixedSize?.height ?? 56.0,
        child: Center(
          child: Builder(
            builder: (context) {
              if (widget.icon != null) {
                if (widget.icon is Icon) {
                  final Icon originalIcon = widget.icon as Icon;
                  return Icon(
                    originalIcon.icon,
                    size: widget.iconSize ?? originalIcon.size ?? 24.0,
                    color: hasFocus
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onPrimary,
                  );
                }
                return widget.icon!;
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
