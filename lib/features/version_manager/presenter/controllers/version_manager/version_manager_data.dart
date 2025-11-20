import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/version_manager/domain/entities/release_entity.dart';

class VersionManagerData implements BaseControllerData {
  List<ReleaseEntity> releases;
  ReleaseEntity? selectedRelease;
  String currentVersion;
  String? changelog;
  bool loadingReleases;
  bool loadingChangelog;
  String? error;

  VersionManagerData({
    this.releases = const [],
    this.selectedRelease,
    this.currentVersion = '',
    this.changelog,
    this.loadingReleases = false,
    this.loadingChangelog = false,
    this.error,
  });

  @override
  VersionManagerData copyWith({
    List<ReleaseEntity>? releases,
    ReleaseEntity? selectedRelease,
    String? currentVersion,
    String? changelog,
    bool? loadingReleases,
    bool? loadingChangelog,
    String? error,
  }) {
    return VersionManagerData(
      releases: releases ?? this.releases,
      selectedRelease: selectedRelease ?? this.selectedRelease,
      currentVersion: currentVersion ?? this.currentVersion,
      changelog: changelog ?? this.changelog,
      loadingReleases: loadingReleases ?? this.loadingReleases,
      loadingChangelog: loadingChangelog ?? this.loadingChangelog,
      error: error ?? this.error,
    );
  }

  bool get isSelectedVersionNewer {
    if (selectedRelease == null) return false;
    return _compareVersions(selectedRelease!.version, currentVersion) > 0;
  }

  bool get isSelectedVersionOlder {
    if (selectedRelease == null) return false;
    return _compareVersions(selectedRelease!.version, currentVersion) < 0;
  }

  bool get isSelectedVersionCurrent {
    if (selectedRelease == null) return false;
    return selectedRelease!.version == currentVersion;
  }

  int _compareVersions(String version1, String version2) {
    final parts1 =
        version1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final parts2 =
        version2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final maxLength =
        parts1.length > parts2.length ? parts1.length : parts2.length;

    for (int i = 0; i < maxLength; i++) {
      final part1 = i < parts1.length ? parts1[i] : 0;
      final part2 = i < parts2.length ? parts2[i] : 0;

      if (part1 > part2) return 1;
      if (part1 < part2) return -1;
    }

    return 0;
  }
}
