import 'package:musily/features/_search_module/domain/datasources/search_datasource.dart';
import 'package:musily_repository/musily_repository.dart' as repo;

class SearchDatasourceImpl implements SearchDatasource {
  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      final suggestions = await repo.getSearchSuggestions(query);
      return suggestions;
    } catch (e) {
      return [];
    }
  }
}
