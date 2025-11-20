import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Map<String, int>> _processImageColors(String imageUrl) async {
  ui.Image? originalImage;
  ui.Image? resizedImage;
  bool isResized = false;

  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load image: ${response.statusCode}');
    }

    final Uint8List imageBytes = response.bodyBytes;

    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    originalImage = frame.image;

    final originalWidth = originalImage.width;
    final originalHeight = originalImage.height;

    resizedImage = await _resizeImage(originalImage, 100);

    isResized = resizedImage.width != originalWidth ||
        resizedImage.height != originalHeight;

    final dominantColor = await _extractDominantColor(resizedImage);

    final luminance = dominantColor.computeLuminance();
    final textColor = luminance > 0.5 ? Colors.black : Colors.white;

    if (isResized) {
      resizedImage.dispose();
    }
    originalImage.dispose();

    return {
      'backgroundColor': dominantColor.value,
      'textColor': textColor.value,
    };
  } catch (e) {
    log('Error processing image colors: $e');
    if (resizedImage != null && resizedImage != originalImage) {
      resizedImage.dispose();
    }
    originalImage?.dispose();
    return {
      'backgroundColor': const Color(0xFFD8B4FA).value,
      'textColor': Colors.black.value,
    };
  }
}

Future<ui.Image> _resizeImage(ui.Image image, int maxSize) async {
  final int width = image.width;
  final int height = image.height;

  if (width <= 0 || height <= 0) {
    return image;
  }

  if (width <= maxSize && height <= maxSize) {
    return image;
  }

  // Avoid division by zero
  if (height == 0) {
    return image;
  }

  final double aspectRatio = width / height;
  int newWidth = maxSize;
  int newHeight = maxSize;

  if (width > height) {
    newHeight = (maxSize / aspectRatio).round();
  } else {
    newWidth = (maxSize * aspectRatio).round();
  }

  if (newWidth <= 0 || newHeight <= 0) {
    return image;
  }

  const int maxDimension = 1000;
  if (newWidth > maxDimension) {
    newHeight = ((newHeight * maxDimension) / newWidth).round();
    newWidth = maxDimension;
  }
  if (newHeight > maxDimension) {
    newWidth = ((newWidth * maxDimension) / newHeight).round();
    newHeight = maxDimension;
  }

  if (newWidth <= 0 || newHeight <= 0) {
    return image;
  }

  final srcRect = Rect.fromLTRB(0, 0, width.toDouble(), height.toDouble());
  final dstRect =
      Rect.fromLTRB(0, 0, newWidth.toDouble(), newHeight.toDouble());

  if (srcRect.width <= 0 ||
      srcRect.height <= 0 ||
      dstRect.width <= 0 ||
      dstRect.height <= 0) {
    return image;
  }

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  canvas.drawImageRect(
    image,
    srcRect,
    dstRect,
    Paint(),
  );

  final picture = recorder.endRecording();
  final resizedImage = await picture.toImage(newWidth, newHeight);
  picture.dispose();

  return resizedImage;
}

Future<Color> _extractDominantColor(ui.Image image) async {
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  if (byteData == null) {
    return const Color(0xFFD8B4FA);
  }

  final Uint8List pixels = byteData.buffer.asUint8List();
  int r = 0, g = 0, b = 0;
  int pixelCount = 0;

  for (int i = 0; i < pixels.length; i += 16) {
    if (i + 2 < pixels.length) {
      r += pixels[i];
      g += pixels[i + 1];
      b += pixels[i + 2];
      pixelCount++;
    }
  }

  if (pixelCount == 0) {
    return const Color(0xFFD8B4FA);
  }

  final avgR = (r / pixelCount).round();
  final avgG = (g / pixelCount).round();
  final avgB = (b / pixelCount).round();

  return Color.fromARGB(255, avgR, avgG, avgB);
}

Future<List<Map<String, int>>> processMultipleImageColors(
  List<String> imageUrls,
) async {
  if (imageUrls.isEmpty) {
    return [];
  }

  final results = <Map<String, int>>[];

  for (final imageUrl in imageUrls) {
    if (imageUrl.isEmpty) {
      results.add({
        'backgroundColor': const Color(0xFFD8B4FA).value,
        'textColor': Colors.black.value,
      });
      continue;
    }

    try {
      final colors = await _processImageColors(imageUrl);
      results.add(colors);
    } catch (e) {
      log('Error processing image colors: $e');
      results.add({
        'backgroundColor': const Color(0xFFD8B4FA).value,
        'textColor': Colors.black.value,
      });
    }
  }

  return results;
}
