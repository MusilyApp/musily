class ReleaseEntity {
  final String tagName;
  final String name;
  final String? body;
  final DateTime publishedAt;
  final List<ReleaseAsset> assets;
  final bool isPrerelease;

  const ReleaseEntity({
    required this.tagName,
    required this.name,
    this.body,
    required this.publishedAt,
    required this.assets,
    this.isPrerelease = false,
  });

  factory ReleaseEntity.fromMap(Map<String, dynamic> map) {
    final assetsList = (map['assets'] as List<dynamic>?)
            ?.map((e) => ReleaseAsset.fromMap(e as Map<String, dynamic>))
            .toList() ??
        [];

    return ReleaseEntity(
      tagName: map['tag_name']?.toString() ?? '',
      name: map['name']?.toString() ?? map['tag_name']?.toString() ?? '',
      body: map['body']?.toString(),
      publishedAt: map['published_at'] != null
          ? DateTime.parse(map['published_at'])
          : DateTime.now(),
      assets: assetsList,
      isPrerelease: map['prerelease'] ?? false,
    );
  }

  String get version => tagName.replaceFirst('v', '');

  ReleaseAsset? getAssetForPlatform({
    bool isAndroid = false,
    bool isWindows = false,
    bool isLinux = false,
    bool isMacOS = false,
  }) {
    if (assets.isEmpty) return null;

    if (isAndroid) {
      for (final asset in assets) {
        final name = asset.name.toLowerCase();
        if (name.endsWith('.apk')) {
          return asset;
        }
      }
    }

    if (isWindows) {
      for (final asset in assets) {
        final name = asset.name.toLowerCase();
        if (name.endsWith('.exe') || name.contains('windows')) {
          return asset;
        }
      }
    }

    if (isLinux) {
      for (final asset in assets) {
        final name = asset.name.toLowerCase();
        if (name.endsWith('.tar.gz') ||
            name.contains('linux') ||
            name.contains('linux-installer')) {
          return asset;
        }
      }
    }

    if (isMacOS) {
      for (final asset in assets) {
        final name = asset.name.toLowerCase();
        if (name.endsWith('.dmg') ||
            name.endsWith('.app') ||
            name.contains('macos') ||
            name.contains('mac')) {
          return asset;
        }
      }
    }

    return assets.first;
  }
}

class ReleaseAsset {
  final String name;
  final String downloadUrl;
  final int size;
  final String contentType;

  const ReleaseAsset({
    required this.name,
    required this.downloadUrl,
    required this.size,
    required this.contentType,
  });

  factory ReleaseAsset.fromMap(Map<String, dynamic> map) {
    return ReleaseAsset(
      name: map['name']?.toString() ?? '',
      downloadUrl: map['browser_download_url']?.toString() ?? '',
      size: map['size'] ?? 0,
      contentType: map['content_type']?.toString() ?? '',
    );
  }
}
