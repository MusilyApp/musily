// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class UpdaterService {
  static final UpdaterService _instance = UpdaterService._internal();
  factory UpdaterService() {
    return _instance;
  }
  UpdaterService._internal();
  static UpdaterService get instance => _instance;

  bool hasUpdate = false;
  String? latestVersion;
  String? downloadUrl;
  String releaseNotes = '';

  static const _repoOwner = 'MusilyApp';
  static const _repoName = 'musily';
  static const _apiUrl =
      'https://api.github.com/repos/$_repoOwner/$_repoName/releases/latest';
  static const _changelogUrl =
      'https://raw.githubusercontent.com/$_repoOwner/$_repoName/main/CHANGELOG.md';

  static Future<void> checkForUpdates() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode != 200) return;

      final json = jsonDecode(response.body);
      _instance.latestVersion =
          json['tag_name']?.toString().replaceFirst('v', '');
      final assets = (json['assets'] as List).cast<Map<String, dynamic>>();

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      _instance.hasUpdate = _instance._isNewerVersion(
        _instance.latestVersion!,
        currentVersion,
      );

      if (!_instance.hasUpdate) return;

      final asset = assets.firstWhere(
        (asset) {
          final name = asset['name']?.toString().toLowerCase() ?? '';
          if (Platform.isAndroid) return name.endsWith('.apk');
          if (Platform.isWindows) return name.contains('windows');
          if (Platform.isLinux) return name.contains('linux-installer');
          return false;
        },
        orElse: () => {},
      );

      _instance.downloadUrl = asset['browser_download_url']?.toString();
      await _instance._fetchReleaseNotes();
    } catch (e) {
      debugPrint('UpdaterService error: $e');
    }
  }

  Future<void> _fetchReleaseNotes() async {
    try {
      final changelogResponse = await http.get(Uri.parse(_changelogUrl));
      if (changelogResponse.statusCode != 200) return;

      final changelogContent = changelogResponse.body;
      final lines = LineSplitter.split(changelogContent).toList();
      final changelogBuffer = StringBuffer();
      bool inTargetSection = false;

      final versionHeaderRegex = RegExp(
        r'^##\s*(\[)?' + RegExp.escape(latestVersion!) + r'(\])?\s*$',
        caseSensitive: false,
      );
      final anyHeaderRegex = RegExp(r'^##\s+');

      for (final line in lines) {
        if (versionHeaderRegex.hasMatch(line.trim())) {
          inTargetSection = true;
          continue;
        }

        if (inTargetSection) {
          if (anyHeaderRegex.hasMatch(line.trim())) break;
          changelogBuffer.writeln(line);
        }
      }

      final description = changelogBuffer.toString().trim();
      if (description.isEmpty) {
        print('Warning: Release notes not found for version $latestVersion.');
        return;
      }

      releaseNotes = description;
    } catch (e) {
      print('Failed to fetch release notes: $e');
    }
  }

  bool _isNewerVersion(String latest, String current) {
    final latestParts =
        latest.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final currentParts =
        current.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length) return true;
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }

    return latestParts.length > currentParts.length;
  }
}
