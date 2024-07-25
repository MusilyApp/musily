import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/playlist/presenter/controllers/playlist/playlist_data.dart';
import 'package:musily/features/playlist/presenter/controllers/playlist/playlist_methods.dart';

class PlaylistController extends BaseController<PlaylistData, PlaylistMethods> {
  @override
  PlaylistData defineData() {
    return PlaylistData();
  }

  @override
  PlaylistMethods defineMethods() {
    return PlaylistMethods();
  }
}
