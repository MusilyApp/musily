import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';

class LyTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool fullWidth;
  final LyDensity density;
  final bool autocorrect;
  final BorderRadius? borderRadius;
  final int? maxLength;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final void Function()? onFocus;
  final void Function()? onFocusOut;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool autofocus;
  final void Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const LyTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.fullWidth = false,
    this.density = LyDensity.normal,
    this.autocorrect = true,
    this.maxLength,
    this.borderRadius,
    this.labelStyle,
    this.hintStyle,
    this.textStyle,
    this.decoration,
    this.contentPadding,
    this.margin,
    this.onFocus,
    this.onFocusOut,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<LyTextField> createState() => _LyTextFieldState();
}

class _LyTextFieldState extends State<LyTextField> {
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
      child: TextFormField(
        controller: widget.controller,
        focusNode: focusNode,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        autocorrect: widget.autocorrect,
        maxLength: widget.maxLength,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          labelStyle: widget.labelStyle ??
              TextStyle(
                color: hasFocus
                    ? context.themeData.colorScheme.primary
                    : context.themeData.colorScheme.onSurface,
              ),
          hintStyle: widget.hintStyle ??
              TextStyle(
                color: context.themeData.colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
          contentPadding: widget.contentPadding ??
              EdgeInsets.symmetric(
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
              ? context.themeData.colorScheme.onPrimary.withValues(alpha: 0.1)
              : context.themeData.colorScheme.surface,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        ),
        style: widget.textStyle ??
            TextStyle(
              color: context.themeData.colorScheme.onSurface,
            ),
        onChanged: widget.onChanged,
        validator: widget.validator,
        autofocus: widget.autofocus,
        onFieldSubmitted: widget.onSubmitted,
        minLines: 1,
        maxLines: 1,
      ),
    );
  }
}
