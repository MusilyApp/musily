class MusilyError implements Exception {
  final int code;
  final String id;

  MusilyError({
    required this.code,
    required this.id,
  });

  @override
  String toString() => 'AppError(code: $code, id: $id)';
}
