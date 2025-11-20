import 'package:flutter/material.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/core/presenter/widgets/musily_logo.dart';
import 'package:musily/core/presenter/widgets/screen_handler.dart';
import 'package:musily/core/presenter/widgets/user_avatar.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_sections_module/presenter/controllers/sections/sections_controller.dart';
import 'package:musily/features/_sections_module/presenter/pages/m_sections_page.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/auth/presenter/controllers/auth_controller/auth_controller.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class SectionsPage extends StatelessWidget {
  final SectionsController sectionsController;
  final CoreController coreController;
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final SettingsController settingsController;
  final AuthController authController;
  final GetTrackUsecase getTrackUsecase;

  const SectionsPage({
    required this.sectionsController,
    required this.coreController,
    required this.playerController,
    required this.getAlbumUsecase,
    required this.getPlaylistUsecase,
    super.key,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
    required this.settingsController,
    required this.authController,
    required this.getTrackUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'SectionsPage',
      child: Scaffold(
        appBar: MusilyAppBar(
          centerTitle: false,
          autoImplyLeading: false,
          backgroundColor: context.themeData.scaffoldBackgroundColor,
          title: const Row(
            children: [
              MusilyLogo(
                width: 40,
              ),
              SizedBox(
                width: 12,
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: MusilyTitle(),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                top: 4,
                right: 12,
              ),
              child: UserAvatar(
                coreController: coreController,
                settingsController: settingsController,
                authController: authController,
              ),
            ),
          ],
        ),
        body: ScreenHandler(
          mobile: MSectionsPage(
            sectionsController: sectionsController,
            libraryController: libraryController,
            playerController: playerController,
            getAlbumUsecase: getAlbumUsecase,
            getPlaylistUsecase: getPlaylistUsecase,
            getArtistUsecase: getArtistUsecase,
            coreController: coreController,
            downloaderController: downloaderController,
            getPlayableItemUsecase: getPlayableItemUsecase,
            getArtistAlbumsUsecase: getArtistAlbumsUsecase,
            getArtistTracksUsecase: getArtistTracksUsecase,
            getArtistSinglesUsecase: getArtistSinglesUsecase,
            getTrackUsecase: getTrackUsecase,
          ),
          // TODO implement other screens
        ),
      ),
    );
  }
}
