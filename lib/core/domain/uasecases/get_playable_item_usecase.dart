import 'package:musily_player/musily_entities.dart';

abstract class GetPlayableItemUsecase {
  Future<MusilyTrack> exec(
    MusilyTrack track,
  );
}
