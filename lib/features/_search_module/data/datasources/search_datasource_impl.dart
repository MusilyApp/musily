import 'package:musily/core/domain/datasources/base_datasource.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/features/_search_module/domain/datasources/search_datasource.dart';

class SearchDatasourceImpl extends BaseDatasource implements SearchDatasource {
  late final MusilyRepository _musilyRepository;

  SearchDatasourceImpl({required MusilyRepository musilyRepository}) {
    _musilyRepository = musilyRepository;
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    return exec<List<String>>(() async {
      final suggestions = await _musilyRepository.getSearchSuggestions(query);
      return suggestions;
    });
  }
}
