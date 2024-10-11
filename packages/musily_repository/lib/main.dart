import 'package:musily_repository/musily_repository.dart';

Future<void> main(List<String> args) async {
  final musilyRepository = MusilyRepository();
  await musilyRepository.initialize();

  final albums = musilyRepository.searchAlbums('Atlas');
  print(albums);
}
