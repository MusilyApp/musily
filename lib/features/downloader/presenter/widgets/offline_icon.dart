import 'package:flutter/material.dart';

class OfflineIcon extends StatelessWidget {
  final double size;
  final double? iconSize;
  const OfflineIcon({
    super.key,
    this.size = 50,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.transparent,
            Colors.grey,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.cloud_done_rounded,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}
