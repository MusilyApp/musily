import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';

abstract class GetTimedLyricsUsecase {
  Future<TimedLyricsRes?> exec(String id);
}
