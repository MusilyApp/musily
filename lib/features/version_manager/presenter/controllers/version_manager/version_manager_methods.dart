import 'package:musily/features/version_manager/domain/entities/release_entity.dart';

class VersionManagerMethods {
  final Future<void> Function() loadReleases;
  final Future<void> Function(ReleaseEntity release) selectRelease;
  final Future<void> Function(ReleaseEntity release) downloadRelease;

  VersionManagerMethods({
    required this.loadReleases,
    required this.selectRelease,
    required this.downloadRelease,
  });
}
