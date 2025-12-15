import 'dart:math';
import 'package:flutter/material.dart';

class FaultyListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final int seed;

  const FaultyListView({
    super.key,
    required this.children,
    required this.seed,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final rng = Random(seed);

    return ListView.separated(
      physics: physics ?? const BouncingScrollPhysics(),
      padding: padding,
      itemCount: children.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final xOffset = (rng.nextDouble() - 0.5) * 20;
        final rotation = (rng.nextDouble() - 0.5) * 0.05;

        return Transform.translate(
          offset: Offset(xOffset, 0),
          child: Transform.rotate(
            angle: rotation,
            child: children[index],
          ),
        );
      },
    );
  }
}
