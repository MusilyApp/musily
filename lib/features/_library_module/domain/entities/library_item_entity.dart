class LibraryItemEntity<T> {
  final String id;
  DateTime lastTimePlayed;
  final T value;

  LibraryItemEntity({
    required this.id,
    required this.lastTimePlayed,
    required this.value,
  });
}
