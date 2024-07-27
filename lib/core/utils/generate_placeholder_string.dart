import 'dart:math';

String generatePlaceholderString({int maxLength = 20}) {
  final random = Random();
  final titleLength = max(
    10,
    random.nextInt(maxLength),
  );
  final titleList = List.filled(
    titleLength,
    '0',
  );
  return titleList.join('');
}
