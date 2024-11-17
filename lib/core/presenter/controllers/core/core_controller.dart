import 'package:flutter/material.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_data.dart';
import 'package:musily/core/presenter/controllers/core/core_methods.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/presenter/pages/playlist_page.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:share_plus/share_plus.dart';

class CoreController extends BaseController<CoreData, CoreMethods> {
  final GlobalKey coreKey = GlobalKey();
  final GlobalKey coreShowingKey = GlobalKey();

  final PlayerController playerController;
  final DownloaderController downloaderController;
  final LibraryController libraryController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetTrackUsecase getTrackUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  CoreController({
    required this.playerController,
    required this.downloaderController,
    required this.libraryController,
    required this.getPlayableItemUsecase,
    required this.getTrackUsecase,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  });

  BuildContext? get coreContext => coreKey.currentContext;
  BuildContext? get coreShowingContext => coreShowingKey.currentContext;

  @override
  CoreData defineData() {
    return CoreData(
      isShowingDialog: false,
      isPlayerExpanded: false,
      hadlingDeepLink: false,
    );
  }

  @override
  CoreMethods defineMethods() {
    return CoreMethods(
      // TODO Share abstraction
      shareArtist: (artist) async {
        await Share.share('''
${coreContext!.localization.comeCheckTEMPLATEOnMusily.replaceAll(
          'TEMPLATE',
          '"${artist.name}"',
        )}

https://musily.app/artist/${artist.id}/
''');
      },
      shareSong: (track) async {
        await Share.share('''
${coreContext!.localization.comeCheckTEMPLATEOnMusily.replaceAll(
          'TEMPLATE',
          '"${track.title}"',
        )}

https://musily.app/song/${track.id}/
''');
      },
      shareAlbum: (album) async {
        await Share.share('''
${coreContext!.localization.comeCheckTEMPLATEOnMusily.replaceAll(
          'TEMPLATE',
          '"${album.title}"',
        )}

https://musily.app/album/${album.id}/
''');
      },
      handleDeepLink: (uri) async {
        updateData(
          data.copyWith(
            hadlingDeepLink: true,
          ),
        );

        final contextManager = ContextManager();
        final pagesKeys = [
          'LibraryPage',
          'SectionsPage',
          'SearchPage',
          'DownloaderPage',
        ];

        final context = contextManager.contextStack
            .where((e) => pagesKeys.contains(e.key))
            .firstOrNull
            ?.context;

        if (context == null) {
          return;
        }

        final uriSegments = uri.pathSegments;

        if (uriSegments.isNotEmpty) {
          final type = uriSegments.elementAtOrNull(0);
          final id = uriSegments.elementAtOrNull(1);
          final origin = uriSegments.elementAtOrNull(2);

          switch (type) {
            case 'artist':
              if (id != null) {
                LyNavigator.push(
                  context,
                  AsyncArtistPage(
                    artistId: id,
                    coreController: this,
                    playerController: playerController,
                    downloaderController: downloaderController,
                    getPlayableItemUsecase: getPlayableItemUsecase,
                    libraryController: libraryController,
                    getAlbumUsecase: getAlbumUsecase,
                    getArtistUsecase: getArtistUsecase,
                    getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                    getArtistTracksUsecase: getArtistTracksUsecase,
                    getArtistSinglesUsecase: getArtistSinglesUsecase,
                  ),
                );
              }
              break;
            case 'album':
              if (id != null) {
                LyNavigator.push(
                  context,
                  AsyncAlbumPage(
                    albumId: id,
                    coreController: this,
                    playerController: playerController,
                    downloaderController: downloaderController,
                    getPlayableItemUsecase: getPlayableItemUsecase,
                    libraryController: libraryController,
                    getAlbumUsecase: getAlbumUsecase,
                    getArtistUsecase: getArtistUsecase,
                    getArtistTracksUsecase: getArtistTracksUsecase,
                    getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                    getArtistSinglesUsecase: getArtistSinglesUsecase,
                  ),
                );
              }
              break;
            case 'playlist':
              if (id != null) {
                LyNavigator.push(
                  context,
                  AsyncPlaylistPage(
                    playlistId: id,
                    coreController: this,
                    playerController: playerController,
                    downloaderController: downloaderController,
                    getPlayableItemUsecase: getPlayableItemUsecase,
                    libraryController: libraryController,
                    getAlbumUsecase: getAlbumUsecase,
                    getArtistUsecase: getArtistUsecase,
                    getArtistTracksUsecase: getArtistTracksUsecase,
                    getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                    getArtistSinglesUsecase: getArtistSinglesUsecase,
                    origin: origin == 'library'
                        ? ContentOrigin.library
                        : ContentOrigin.dataFetch,
                  ),
                );
              }
              break;
            case 'song':
              if (id != null) {
                final song = await getTrackUsecase.exec(id);
                if (song != null) {
                  playerController.methods.addToQueue([song]);
                }
              }
              break;
            default:
              break;
          }
        }
        updateData(
          data.copyWith(
            hadlingDeepLink: false,
          ),
        );
      },
    );
  }
}
