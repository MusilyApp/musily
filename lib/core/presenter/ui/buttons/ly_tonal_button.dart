import 'package:flutter/material.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';

class LyTonalButton extends StatefulWidget {
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
  final Color? disabledColor; // Nova propriedade

  const LyTonalButton({
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
    this.disabledColor, // Inicializa a nova propriedade
  });

  @override
  State<LyTonalButton> createState() => _LyTonalButtonState();
}

class _LyTonalButtonState extends State<LyTonalButton> {
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
        focusElevation: 0,
        focusNode: focusNode,
        onPressed: widget.onPressed,
        shape: widget.shape ??
            RoundedRectangleBorder(
              side: hasFocus
                  ? BorderSide(
                      width: 2,
                      strokeAlign: 1,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : const BorderSide(
                      color: Colors.transparent,
                    ),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            ),
        color: widget.onPressed == null // Verifica se está desabilitado
            ? (widget.disabledColor ??
                Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.38)) // Cor desativada padrão
            : (hasFocus
                ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
                : Theme.of(context).colorScheme.surfaceContainerHighest),
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
          child: Builder(
            builder: (context) {
              if (widget.child is Text &&
                  (widget.child as Text).style == null) {
                final Text originalText = widget.child as Text;
                return Text(
                  originalText.data ?? '',
                  style: TextStyle(
                    color: hasFocus
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
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
