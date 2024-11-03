import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class FavoriteIcon extends StatelessWidget {
  final double size;
  final double? iconSize;
  const FavoriteIcon({
    super.key,
    this.size = 50,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.transparent,
            context.themeData.buttonTheme.colorScheme?.primary ?? Colors.white,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.favorite_rounded,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}
