import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:musily/core/data/repositories/musily_repository_impl.dart';
import 'package:musily/core/data/services/library_backup_service.dart';
import 'package:musily/core/data/services/window_service.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_data.dart';
import 'package:musily/core/presenter/controllers/core/core_methods.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_snackbar.dart';
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
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/pages/playlist_page.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
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
  final GetPlaylistUsecase getPlaylistUsecase;

  late final BackupService backupService;
  StreamSubscription<InternetStatus>? _connectionSubscription;
  final InternetConnection _connectionChecker = InternetConnection();

  final List<Future<dynamic> Function()> networkListeners = [];

  CoreController({
    required this.playerController,
    required this.downloaderController,
    required this.libraryController,
    required this.getPlayableItemUsecase,
    required this.getTrackUsecase,
    required this.getPlaylistUsecase,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  }) {
    backupService = BackupService(
      downloaderController: downloaderController,
      libraryController: libraryController,
    );
    _initConnectionListener();
    ReceiveSharingIntent.instance.getMediaStream().listen((data) {
      updateData(
        this.data.copyWith(
              backupFileDir: data.firstOrNull?.path ?? '',
            ),
      );
      if (this.data.backupFileDir.endsWith('.lybak')) {
        methods.restoreLibraryBackup();
      }
    });
  }

  BuildContext? get coreContext => coreKey.currentContext;
  BuildContext? get coreShowingContext => coreShowingKey.currentContext;

  bool get showDesktopProperties =>
      Platform.isLinux || Platform.isWindows || Platform.isMacOS;
  bool get showWindowBorder => showDesktopProperties && !data.isMaximized;

  @override
  CoreData defineData() {
    return CoreData(
      isShowingDialog: false,
      isPlayerExpanded: false,
      hadlingDeepLink: false,
      backupInProgress: false,
      showDropFiles: false,
      backupFileDir: '',
      isMaximized: false,
      windowTitle: 'Musily',
      offlineMode: false,
    );
  }

  void _initConnectionListener() {
    _connectionChecker.hasInternetAccess.then((hasConnection) {
      updateData(data.copyWith(offlineMode: !hasConnection));
    });

    _connectionSubscription =
        _connectionChecker.onStatusChange.listen((status) {
      final isOffline = status == InternetStatus.disconnected;
      updateData(data.copyWith(offlineMode: isOffline));
      if (!isOffline) {
        MusilyRepositoryImpl().initialize().then((value) async {
          libraryController.methods.getLibraryItems();
          libraryController.methods.loadFavorites();
          for (final listener in networkListeners) {
            await listener();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    super.dispose();
  }

  @override
  CoreMethods defineMethods() {
    return CoreMethods(
      updateDragAndDropFiles: (showDragDialog, files) {
        updateData(data.copyWith(
          showDropFiles: showDragDialog,
        ));
        if (files.isNotEmpty) {
          WindowService.focus();
          if (files.length > 1) {
            LySnackbar.showError(
              coreContext!.localization.onlyOneItemAtATime,
            );
            return;
          }
          final backupFile =
              files.firstWhereOrNull((e) => e.path.endsWith('.lybak'));
          if (backupFile != null) {
            updateData(data.copyWith(
              backupFileDir: backupFile.path,
            ));
            methods.restoreLibraryBackup();
          }

          final folder =
              files.firstWhereOrNull((e) => Directory(e.path).existsSync());
          if (folder != null) {
            LyNavigator.push(
              coreContext!.showingPageContext,
              LocalPlaylistAdderPage(
                libraryController: libraryController,
                coreController: this,
                initialFolderPath: folder.path,
              ),
            );
          }
        }
      },
      loadWindowProperties: () async {
        data.isMaximized = WindowService().isMaximized;
        data.windowTitle = WindowService().currentTitle;
        updateData(data);
      },
      pickBackupfile: () async {
        final backupFile = await backupService.pickBackupFile();
        if (backupFile != null) {
          updateData(data.copyWith(
            backupFileDir: backupFile.path,
          ));
          await methods.restoreLibraryBackup();
        }
      },
      saveTrackToDownload: (track) async {
        try {
          if (Platform.isAndroid || Platform.isIOS) {
            await methods.requestStoragePermission();
          }

          await backupService.saveTrackToDownloads(track);

          LySnackbar.showSuccess(
              coreContext!.localization.musicSavedToDownloads);
        } catch (e) {
          LySnackbar.showError(':P');
        }
      },
      restoreLibraryBackup: () async {
        LyNavigator.showLyCardDialog(
          context: coreContext!,
          actions: (context) => [
            LyFilledButton(
              onPressed: () {
                LyNavigator.pop(context);
              },
              child: Text(context.localization.cancel),
            ),
            LyFilledButton(
              onPressed: () async {
                LyNavigator.pop(context);
                updateData(data.copyWith(
                  backupInProgress: true,
                ));
                final backupFile = File(data.backupFileDir);
                await backupService.restoreLibraryBackup(backupFile);
                await libraryController.methods.getLibraryItems();
                updateData(data.copyWith(
                  backupInProgress: false,
                ));
                LySnackbar.showSuccess(
                  coreContext!.localization.backupRestoredSuccessfully,
                );
              },
              child: Text(context.localization.restore),
            ),
          ],
          builder: (context) => const SizedBox.shrink(),
          title: Text(coreContext!.localization.doYouWantToRestoreThisBackup),
        );
      },
      requestStoragePermission: () async {
        List<Permission> permissions = [
          Permission.storage,
        ];

        // On Android 11+ (API 30+), request MANAGE_EXTERNAL_STORAGE for full directory access
        if (Platform.isAndroid) {
          try {
            final androidInfo = await DeviceInfoPlugin().androidInfo;
            if (androidInfo.version.sdkInt >= 30) {
              // Request manage external storage permission for Android 11+
              permissions.add(Permission.manageExternalStorage);
            }
          } catch (e) {
            // If we can't determine SDK version, just request storage
          }
        }

        await permissions.request();
        MediaStore.appFolder = 'Musily';
      },
      // TODO Share abstraction
      shareArtist: (artist) async {
        await Share.share('''
${coreContext!.localization.comeCheckTEMPLATEOnMusily.replaceAll(
          'TEMPLATE',
          '"${artist.name}"',
        )}

https://musily.app/artist/${artist.id}
''');
      },
      shareSong: (track) async {
        late final String url;
        if (track.album.id.isEmpty) {
          url = 'https://musily.app/song/${track.id}';
        } else {
          url = 'https://musily.app/album/${track.album.id}/${track.id}';
        }
        await Share.share('''
${coreContext!.localization.comeCheckTEMPLATEOnMusily.replaceAll(
          'TEMPLATE',
          '"${track.title}"',
        )}

$url
''');
      },
      shareAlbum: (album) async {
        await Share.share('''
${coreContext!.localization.comeCheckTEMPLATEOnMusily.replaceAll(
          'TEMPLATE',
          '"${album.title}"',
        )}

https://musily.app/album/${album.id}
''');
      },
      handleDeepLink: (uri) async {
        try {
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
            final extra = uriSegments.elementAtOrNull(2);

            switch (type) {
              case 'artist':
                if (id != null) {
                  LyNavigator.push(
                    context,
                    AsyncArtistPage(
                      artistId: id,
                      getPlaylistUsecase: getPlaylistUsecase,
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
                      getTrackUsecase: getTrackUsecase,
                    ),
                  );
                }
                break;
              case 'album':
                if (id != null) {
                  if (extra != null) {
                    final fetchedAlbum = await getAlbumUsecase.exec(id);
                    if (fetchedAlbum != null) {
                      final track = fetchedAlbum.tracks
                          .where(
                            (e) => e.id == extra,
                          )
                          .firstOrNull;
                      if (track != null) {
                        playerController.methods.addToQueue([track]);
                      }
                    }
                    return;
                  }
                  LyNavigator.push(
                    context,
                    AsyncAlbumPage(
                      albumId: id,
                      getTrackUsecase: getTrackUsecase,
                      coreController: this,
                      playerController: playerController,
                      downloaderController: downloaderController,
                      getPlayableItemUsecase: getPlayableItemUsecase,
                      getPlaylistUsecase: getPlaylistUsecase,
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
                      getTrackUsecase: getTrackUsecase,
                      playlistId: id,
                      coreController: this,
                      playerController: playerController,
                      downloaderController: downloaderController,
                      getPlayableItemUsecase: getPlayableItemUsecase,
                      libraryController: libraryController,
                      getAlbumUsecase: getAlbumUsecase,
                      getArtistUsecase: getArtistUsecase,
                      getArtistTracksUsecase: getArtistTracksUsecase,
                      getPlaylistUsecase: getPlaylistUsecase,
                      getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                      getArtistSinglesUsecase: getArtistSinglesUsecase,
                      origin: extra == 'library'
                          ? ContentOrigin.library
                          : ContentOrigin.dataFetch,
                    ),
                  );
                }
                break;
              default:
                break;
            }
          }
        } catch (e) {
          catchError(e);
        } finally {
          updateData(
            data.copyWith(
              hadlingDeepLink: false,
            ),
          );
        }
      },
    );
  }
}
