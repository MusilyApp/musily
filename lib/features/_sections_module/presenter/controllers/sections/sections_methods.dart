class SectionsMethods {
  final Future<void> Function() getSections;
  final Future<void> Function() generateRecommendations;

  SectionsMethods({
    required this.getSections,
    required this.generateRecommendations,
  });
}
