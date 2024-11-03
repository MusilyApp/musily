import 'dart:convert';

import 'package:crypto/crypto.dart';

String generateTrackHash({
  required String title,
  required String artist,
  String? albumTitle,
}) {
  final bytes = utf8.encode(
    '$title.$artist${albumTitle != null ? '.$albumTitle' : ''}',
  );
  final digest = md5.convert(bytes);
  return digest.toString();
}
