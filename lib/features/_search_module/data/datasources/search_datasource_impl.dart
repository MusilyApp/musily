import 'package:musily/features/_search_module/domain/datasources/search_datasource.dart';
import 'package:musily_repository/musily_repository.dart';

class SearchDatasourceImpl implements SearchDatasource {
  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      final musilyRepository = MusilyRepository();
      final suggestions = await musilyRepository.getSearchSuggestions(query);
      return suggestions;
    } catch (e) {
      return [];
    }
  }
}
