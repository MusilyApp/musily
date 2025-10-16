import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/string.dart';
import 'package:musily/core/presenter/widgets/musily_logo.dart';

class AppImage extends StatelessWidget {
  final String uri;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  const AppImage(
    this.uri, {
    this.height,
    this.width,
    this.fit,
    this.color,
    this.colorBlendMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (uri.isUrl) {
          return CachedNetworkImage(
            imageUrl: uri,
            width: width,
            height: height,
            fit: fit,
            color: color,
            colorBlendMode: colorBlendMode,
          );
        }
        return Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(8),
          child: MusilyLogo(width: width, height: height),
        );
      },
    );
  }
}
