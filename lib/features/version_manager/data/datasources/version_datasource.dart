import 'package:musily/features/version_manager/domain/entities/release_entity.dart';

abstract class VersionDatasource {
  Future<List<ReleaseEntity>> getReleases();
  Future<String> getChangelog(String version, String languageCode);
}
