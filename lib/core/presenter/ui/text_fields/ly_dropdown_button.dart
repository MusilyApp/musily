import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';

class LyDropdownButton<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final Widget? hint;
  final void Function(T?)? onChanged;
  final void Function()? onFocus;
  final void Function()? onFocusOut;
  final FocusNode? focusNode;
  final bool fullWidth;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final LyDensity density;
  final bool enabled;
  final String? labelText;

  const LyDropdownButton({
    super.key,
    required this.items,
    this.value,
    this.hint,
    this.onChanged,
    this.onFocus,
    this.onFocusOut,
    this.focusNode,
    this.fullWidth = false,
    this.borderRadius,
    this.margin,
    this.density = LyDensity.normal,
    this.enabled = true,
    this.labelText,
  });

  @override
  State<LyDropdownButton<T>> createState() => _LyDropdownButtonState<T>();
}

class _LyDropdownButtonState<T> extends State<LyDropdownButton<T>> {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null)
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                bottom: 8,
              ),
              child: Text(
                widget.labelText!,
                style: context.themeData.textTheme.bodySmall?.copyWith(
                  color: hasFocus
                      ? context.themeData.colorScheme.primary
                      : context.themeData.colorScheme.onSurface
                          .withValues(alpha: 0.9),
                ),
              ),
            ),
          DropdownButtonFormField<T>(
            focusNode: focusNode,
            value: widget.value,
            onChanged: widget.enabled ? widget.onChanged : null,
            hint: widget.hint,
            items: widget.items,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.density == LyDensity.dense ? 4 : 12,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(60),
                borderSide: BorderSide(
                  color: hasFocus
                      ? context.themeData.colorScheme.primary
                      : context.themeData.colorScheme.onSurface
                          .withValues(alpha: 0.4),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(60),
                borderSide: BorderSide(
                  color: context.themeData.colorScheme.onSurface
                      .withValues(alpha: 0.4),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(60),
                borderSide: BorderSide(
                  color: context.themeData.colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: hasFocus
                  ? context.themeData.colorScheme.onPrimary
                      .withValues(alpha: 0.1)
                  : context.themeData.colorScheme.surface,
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: hasFocus
                  ? context.themeData.colorScheme.primary
                  : context.themeData.colorScheme.onSurface
                      .withValues(alpha: 0.6),
            ),
            dropdownColor: context.themeData.colorScheme.surface,
            style: TextStyle(
              color: hasFocus
                  ? context.themeData.colorScheme.primary
                  : context.themeData.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
