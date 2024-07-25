class SearchDataEntity<T> {
  List<T> items;
  int page;
  int limit;

  SearchDataEntity({
    required this.items,
    required this.page,
    required this.limit,
  });
}
