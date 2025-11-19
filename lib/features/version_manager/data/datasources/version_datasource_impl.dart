import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:musily/features/version_manager/domain/datasources/version_datasource.dart';
import 'package:musily/features/version_manager/domain/entities/release_entity.dart';

class VersionDatasourceImpl implements VersionDatasource {
  static const String _repoOwner = 'MusilyApp';
  static const String _repoName = 'musily';
  static const String _apiBaseUrl =
      'https://api.github.com/repos/$_repoOwner/$_repoName';
  static const String _rawBaseUrl =
      'https://raw.githubusercontent.com/$_repoOwner/$_repoName/main';

  @override
  Future<List<ReleaseEntity>> getReleases() async {
    try {
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/releases'),
      );

      if (response.statusCode != 200) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => ReleaseEntity.fromMap(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<String> getChangelog(String version, String languageCode) async {
    try {
      // Try localized changelog first
      if (languageCode != 'en') {
        final localizedPath = 'changelog/$languageCode.md';
        final localizedChangelog =
            await _fetchChangelogFile(localizedPath, version);
        if (localizedChangelog.isNotEmpty) {
          return localizedChangelog;
        }
      }

      // Fallback to main CHANGELOG.md (English)
      final changelog = await _fetchChangelogFile('CHANGELOG.md', version);
      return changelog;
    } catch (e) {
      return '';
    }
  }

  Future<String> _fetchChangelogFile(
    String filePath,
    String version,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$_rawBaseUrl/$filePath'),
      );

      if (response.statusCode != 200) {
        return '';
      }

      final content = response.body;
      final lines = LineSplitter.split(content).toList();
      final changelogBuffer = StringBuffer();
      bool inTargetSection = false;

      // Remove 'v' prefix if present
      final cleanVersion = version.replaceFirst(RegExp(r'^v'), '');

      // Try multiple regex patterns to match different formats:
      // - ## 4.0.4 (most common - exact match)
      // - ## v4.0.4
      // - ## [4.0.4] or ## [v4.0.4]
      // - ## 4.0.4 - Title
      final versionPatterns = [
        // Exact match: ## 4.0.4 (one or more spaces after ##)
        RegExp(r'^##\s+' + RegExp.escape(cleanVersion) + r'\s*$',
            caseSensitive: false),
        // With v: ## v4.0.4
        RegExp(r'^##\s+v' + RegExp.escape(cleanVersion) + r'\s*$',
            caseSensitive: false),
        // With brackets: ## [4.0.4] or ## [v4.0.4]
        RegExp(r'^##\s+\[v?' + RegExp.escape(cleanVersion) + r'\]\s*$',
            caseSensitive: false),
        // With title: ## 4.0.4 - Title
        RegExp(r'^##\s+' + RegExp.escape(cleanVersion) + r'\s*-\s*',
            caseSensitive: false),
        // More flexible: ## followed by version (with optional v and brackets) - catch-all
        RegExp(r'^##\s+(\[)?v?' + RegExp.escape(cleanVersion) + r'(\])?\s*',
            caseSensitive: false),
      ];

      final anyHeaderRegex = RegExp(r'^##\s+');

      for (final line in lines) {
        final trimmedLine = line.trim();

        // Check if this line matches any version pattern
        if (!inTargetSection) {
          for (final pattern in versionPatterns) {
            if (pattern.hasMatch(trimmedLine)) {
              inTargetSection = true;
              break;
            }
          }
          if (inTargetSection) {
            continue;
          }
        }

        if (inTargetSection) {
          // Stop if we hit another header (including duplicate version headers)
          if (anyHeaderRegex.hasMatch(trimmedLine)) {
            // Stop on any header: either a different version or a duplicate of the same version
            break;
          }
          changelogBuffer.writeln(line);
        }
      }

      return changelogBuffer.toString().trim();
    } catch (e) {
      return '';
    }
  }
}
