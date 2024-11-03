class LegacyLibraryItemEntity<T> {
  final String id;
  DateTime lastTimePlayed;
  final T value;

  LegacyLibraryItemEntity({
    required this.id,
    required this.lastTimePlayed,
    required this.value,
  });
}
