import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/album/presenter/controllers/album/album_data.dart';
import 'package:musily/features/album/presenter/controllers/album/album_methods.dart';

class AlbumController extends BaseController<AlbumData, AlbumMethods> {
  @override
  AlbumData defineData() {
    return AlbumData();
  }

  @override
  AlbumMethods defineMethods() {
    return AlbumMethods();
  }
}
