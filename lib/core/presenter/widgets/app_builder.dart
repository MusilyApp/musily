import 'dart:async';

import 'package:flutter/material.dart';

class AppBuilder<D, E> extends StatefulWidget {
  final List<Stream<dynamic>> streams;
  final dynamic initialData;
  final Widget Function(BuildContext context, D? data) builder;
  final void Function(BuildContext context, E data)? listener;

  const AppBuilder({
    super.key,
    required this.streams,
    required this.builder,
    this.initialData,
    this.listener,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AppBuilderState<D, E> createState() => _AppBuilderState<D, E>();
}

class _AppBuilderState<D, E> extends State<AppBuilder<D, E>> {
  D? _data;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    for (final Stream stream in widget.streams) {
      final subscription = stream.listen((output) {
        if (output is D) {
          setState(() {
            _data = output;
          });
        }
        if (output is E) {
          widget.listener?.call(context, output);
        }
      });
      _subscriptions.add(subscription);
      if (_data == null && widget.initialData != null) {
        _data = widget.initialData;
      }
    }
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _data);
  }
}
