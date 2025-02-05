import 'package:musily/core/domain/datasources/base_datasource.dart';
import 'package:musily/core/domain/repositories/musily_repository.dart';
import 'package:musily/features/_search_module/domain/datasources/search_datasource.dart';
import 'dart:async';
import 'dart:developer';

class SearchDatasourceImpl extends BaseDatasource implements SearchDatasource {
  late final MusilyRepository _musilyRepository;
  final Map<String, List<String>> _suggestionsCache = {};

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

  Future<List<String>> getCachedSearchSuggestions(String query) async {
    if (_suggestionsCache.containsKey(query)) {
      return _suggestionsCache[query]!;
    } else {
      final suggestions = await getSearchSuggestions(query);
      _suggestionsCache[query] = suggestions;
      return suggestions;
    }
  }

  void clearCache() {
    _suggestionsCache.clear();
  }

  Future<List<String>> measureSearchExecutionTime(String query) async {
    final start = DateTime.now();
    final suggestions = await getSearchSuggestions(query);
    final end = DateTime.now();
    final elapsed = end.difference(start).inMilliseconds;
    log("Search execution time for query '$query': $elapsed ms");
    return suggestions;
  }

  Future<List<String>> getAdvancedSearchSuggestions(String query, {bool useCache = true}) async {
    if (useCache) {
      return await getCachedSearchSuggestions(query);
    } else {
      return await getSearchSuggestions(query);
    }
  }

  Future<void> logSearchQuery(String query) async {
    final suggestions = await getSearchSuggestions(query);
    log("Query '$query' returned ${suggestions.length} suggestions.");
  }

  Future<List<String>> getRemoteSearchSuggestions(String query) async {
    try {
      final suggestions = await getSearchSuggestions(query);
      return suggestions;
    } catch (e) {
      log("Error fetching local search suggestions: $e. Using fallback.");
      return ['Fallback Suggestion 1', 'Fallback Suggestion 2'];
    }
  }
}
