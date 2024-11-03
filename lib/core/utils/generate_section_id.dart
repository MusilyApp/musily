import 'dart:convert';

import 'package:crypto/crypto.dart';

String generateSectionId(String title) {
  final bytes = utf8.encode(
    title,
  );
  final digest = md5.convert(bytes);
  return digest.toString();
}
