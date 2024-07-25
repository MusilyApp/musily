import 'package:musily/features/_search_module/domain/datasources/search_datasource.dart';
import 'package:musily/features/_search_module/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDatasource searchDatasource;

  SearchRepositoryImpl({
    required this.searchDatasource,
  });

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    final suggestions = await searchDatasource.getSearchSuggestions(query);
    return suggestions;
  }
}
