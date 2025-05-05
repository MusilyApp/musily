import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';

class LyListTile extends StatefulWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final void Function()? onTap;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final bool selected;
  final FocusNode? focusNode;
  final LyDensity density;
  final double? minTileHeight;
  final bool paddingOnFocus;

  const LyListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.borderRadius,
    this.contentPadding,
    this.enabled = true,
    this.selected = false,
    this.focusNode,
    this.density = LyDensity.normal,
    this.minTileHeight,
    this.paddingOnFocus = true,
  });

  @override
  State<LyListTile> createState() => _LyListTileState();
}

class _LyListTileState extends State<LyListTile> {
  late final FocusNode focusNode;
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      setState(() {
        hasFocus = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.themeData.colorScheme;

    return Padding(
      padding: widget.paddingOnFocus
          ? EdgeInsets.all(hasFocus ? 4 : 0)
          : EdgeInsets.zero,
      child: InkWell(
        focusNode: focusNode,
        onTap: widget.enabled ? widget.onTap : null,
        borderRadius: widget.borderRadius ??
            (hasFocus ? BorderRadius.circular(8) : BorderRadius.zero),
        focusColor: colorScheme.primary.withValues(alpha: 0.1),
        highlightColor: colorScheme.primary.withValues(alpha: 0.3),
        splashColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: widget.contentPadding ??
              EdgeInsets.symmetric(
                vertical: widget.density == LyDensity.dense ? 8 : 10.5,
                horizontal: 16,
              ),
          constraints: BoxConstraints(
            minHeight: widget.minTileHeight ?? 0, // Aplicando minTileHeight
          ),
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ??
                (hasFocus ? BorderRadius.circular(8) : BorderRadius.zero),
            color: widget.selected
                ? colorScheme.primary.withValues(alpha: 0.15)
                : Colors.transparent,
            border: Border.all(
              color: hasFocus ? colorScheme.primary : Colors.transparent,
              width: hasFocus ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              if (widget.leading != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: widget.leading,
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.title != null) widget.title!,
                    if (widget.subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: widget.subtitle,
                      ),
                  ],
                ),
              ),
              if (widget.trailing != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: widget.trailing,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
