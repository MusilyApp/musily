class WrappedMethods {
  Future<void> Function({int? year}) loadOrGenerateWrapped;
  Future<void> Function({int? year}) regenerateWrapped;

  WrappedMethods({
    required this.loadOrGenerateWrapped,
    required this.regenerateWrapped,
  });
}
