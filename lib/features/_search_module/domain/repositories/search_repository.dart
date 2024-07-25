abstract class SearchRepository {
  Future<List<String>> getSearchSuggestions(String query);
}
