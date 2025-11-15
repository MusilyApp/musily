import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
        if (uri.startsWith('data:image')) {
          final bytes = _decodeDataUri(uri);
          if (bytes != null) {
            return Image.memory(
              bytes,
              width: width,
              height: height,
              fit: fit,
              color: color,
              colorBlendMode: colorBlendMode,
            );
          }
        }
        if (_isLocalFile(uri)) {
          final file = File(_normalizeLocalPath(uri));
          if (file.existsSync()) {
            return Image.file(
              file,
              width: width,
              height: height,
              fit: fit,
              color: color,
              colorBlendMode: colorBlendMode,
            );
          }
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

  Uint8List? _decodeDataUri(String value) {
    final commaIndex = value.indexOf(',');
    if (commaIndex == -1) {
      return null;
    }
    final base64Part = value.substring(commaIndex + 1);
    try {
      return base64Decode(base64Part);
    } catch (_) {
      return null;
    }
  }

  bool _isLocalFile(String value) {
    if (value.startsWith('file://')) {
      return true;
    }
    if (value.startsWith('/')) {
      return true;
    }
    if (Platform.isWindows && value.contains(':\\')) {
      return true;
    }
    return false;
  }

  String _normalizeLocalPath(String value) {
    if (value.startsWith('file://')) {
      return value.replaceFirst('file://', '');
    }
    return value;
  }
}
