abstract class SearchDatasource {
  Future<List<String>> getSearchSuggestions(String query);
}
