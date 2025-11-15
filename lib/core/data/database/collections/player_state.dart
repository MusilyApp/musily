import 'package:isar/isar.dart';

part 'player_state.g.dart';

@collection
class PlayerState {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String stateKey;

  late String repeatMode;
  late bool shuffleEnabled;

  // Current track info
  String? currentTrackId;
  String? currentTrackHash;

  // Serialized track data (lightweight JSON)
  String? currentTrackJson;

  late int lastUpdated;

  PlayerState();
}

@collection
class QueueTrack {
  Id id = Isar.autoIncrement;

  @Index()
  late String queueType; // 'normal' or 'shuffled'

  late int orderIndex;
  late String trackId;
  late String hash;
  late String title;
  late String artistId;
  late String artistName;
  late String albumId;
  late String albumTitle;
  String? highResImg;
  String? lowResImg;
  String? source;
  String? url;
  late bool fromSmartQueue;
  late int durationMs;
  late int positionMs;
  late bool isLocal;

  QueueTrack();
}
