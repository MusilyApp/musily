import 'package:flutter/material.dart';

class LyDisposable extends StatefulWidget {
  final Widget? child;
  final Function()? onInitState;
  final Function()? onDispose;
  const LyDisposable({
    super.key,
    this.child,
    this.onDispose,
    this.onInitState,
  });

  @override
  State<LyDisposable> createState() => _LyDisposableState();
}

class _LyDisposableState extends State<LyDisposable> {
  @override
  void initState() {
    super.initState();
    widget.onInitState?.call();
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDispose?.call();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox.shrink();
  }
}
