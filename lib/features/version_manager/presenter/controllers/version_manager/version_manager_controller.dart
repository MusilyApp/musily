import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/version_manager/data/datasources/version_datasource_impl.dart';
import 'package:musily/features/version_manager/domain/entities/release_entity.dart';
import 'package:musily/features/version_manager/presenter/controllers/version_manager/version_manager_data.dart';
import 'package:musily/features/version_manager/presenter/controllers/version_manager/version_manager_methods.dart';

class VersionManagerController
    extends BaseController<VersionManagerData, VersionManagerMethods> {
  final VersionDatasourceImpl _datasource = VersionDatasourceImpl();

  VersionManagerController() {
    _loadCurrentVersion();
    methods.loadReleases();
  }

  Future<void> _loadCurrentVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      updateData(data.copyWith(currentVersion: packageInfo.version));
    } catch (e) {
      updateData(data.copyWith(currentVersion: ''));
    }
  }

  String _currentLanguageCode = 'en';

  void setLanguageCode(String languageCode) {
    _currentLanguageCode = languageCode;
    if (data.selectedRelease != null) {
      _loadChangelog(data.selectedRelease!, languageCode);
    }
  }

  String _getCurrentLanguageCode() {
    return _currentLanguageCode;
  }

  @override
  VersionManagerData defineData() {
    return VersionManagerData();
  }

  @override
  VersionManagerMethods defineMethods() {
    return VersionManagerMethods(
      loadReleases: () async {
        updateData(data.copyWith(loadingReleases: true, error: null));
        try {
          final releases = await _datasource.getReleases();
          if (releases.isEmpty) {
            updateData(
              data.copyWith(
                loadingReleases: false,
                error: 'No releases found',
              ),
            );
            return;
          }

          // Select the latest release by default
          final latestRelease = releases.first;
          final languageCode = _getCurrentLanguageCode();

          updateData(
            data.copyWith(
              releases: releases,
              selectedRelease: latestRelease,
              loadingReleases: false,
            ),
          );

          // Load changelog for the selected release
          await _loadChangelog(latestRelease, languageCode);
        } catch (e) {
          updateData(
            data.copyWith(
              loadingReleases: false,
              error: 'Failed to load releases: $e',
            ),
          );
        }
      },
      selectRelease: (release) async {
        updateData(data.copyWith(selectedRelease: release));
        final languageCode = _getCurrentLanguageCode();
        await _loadChangelog(release, languageCode);
      },
      downloadRelease: (release) async {
        final asset = release.getAssetForPlatform(
          isAndroid: Platform.isAndroid,
          isWindows: Platform.isWindows,
          isLinux: Platform.isLinux,
          isMacOS: Platform.isMacOS,
        );
        if (asset == null) {
          return;
        }

        try {
          final uri = Uri.parse(asset.downloadUrl);
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          // Handle error
        }
      },
    );
  }

  Future<void> _loadChangelog(
      ReleaseEntity release, String languageCode) async {
    updateData(data.copyWith(loadingChangelog: true));
    try {
      final changelog = await _datasource.getChangelog(
        release.version,
        languageCode,
      );
      updateData(
        data.copyWith(
          changelog: changelog.isEmpty ? null : changelog,
          loadingChangelog: false,
        ),
      );
    } catch (e) {
      updateData(data.copyWith(loadingChangelog: false));
    }
  }
}
