import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musily/core/utils/string_is_url.dart';

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
        if (uri.isEmpty) {
          return SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: Icon(
                Icons.image_rounded,
              ),
            ),
          );
        }
        if (stringIsUrl(uri)) {
          return Image.network(
            uri,
            width: width,
            height: height,
            fit: fit,
            color: color,
            colorBlendMode: colorBlendMode,
          );
        }
        return Image.file(
          File(uri),
          width: width,
          height: height,
          fit: fit,
          color: color,
          colorBlendMode: colorBlendMode,
        );
      },
    );
  }
}
