abstract class BaseMapper<T> {
  Map<String, dynamic> toMap(T item);
  T fromMap(Map<String, dynamic> map);
}
