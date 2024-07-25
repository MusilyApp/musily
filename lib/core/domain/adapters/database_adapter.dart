abstract class DatabaseModelAdapter {
  Future<void> put(Map<String, dynamic> value);
  Future<List<Map<String, dynamic>>> getAll();
  Future<List<Map<String, dynamic>>> getOffsetLimit(int offset, int limit);
  Future<Map<String, dynamic>?> findById(String id);
  Future<void> findByIdAndDelete(String id);
}
