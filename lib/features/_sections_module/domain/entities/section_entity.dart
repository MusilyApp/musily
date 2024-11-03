class HomeSectionEntity<T> {
  final String id;
  String title;
  List<T> content;

  HomeSectionEntity({
    required this.id,
    required this.title,
    required this.content,
  });
}
