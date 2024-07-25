class SectionEntity<T> {
  final String id;
  String title;
  List<T> content;

  SectionEntity({
    required this.id,
    required this.title,
    required this.content,
  });
}
