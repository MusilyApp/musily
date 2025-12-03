import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:share_plus/share_plus.dart';

class CoreMethods {
  final Future<void> Function(Uri uri) handleDeepLink;
  final Future<void> Function(AlbumEntity album) shareAlbum;
  final Future<void> Function(ArtistEntity artist) shareArtist;
  final Future<void> Function(TrackEntity track) shareSong;
  final Future<void> Function() requestStoragePermission;
  final Future<void> Function() restoreLibraryBackup;
  final Future<void> Function() pickBackupfile;
  final Future<void> Function(TrackEntity track) saveTrackToDownload;
  final Future<void> Function() loadWindowProperties;
  final void Function(bool showDragDialog, List<XFile> files)
      updateDragAndDropFiles;

  CoreMethods({
    required this.handleDeepLink,
    required this.shareAlbum,
    required this.shareArtist,
    required this.shareSong,
    required this.requestStoragePermission,
    required this.restoreLibraryBackup,
    required this.pickBackupfile,
    required this.saveTrackToDownload,
    required this.loadWindowProperties,
    required this.updateDragAndDropFiles,
  });
}
