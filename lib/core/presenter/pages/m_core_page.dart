import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/core_page/core_bottom_navbar.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class MCorePage extends StatefulWidget {
  const MCorePage({
    super.key,
    required this.playerController,
    required this.downloaderController,
    required this.libraryController,
    required this.getAlbumUsecase,
    required this.getPlayableItemUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getArtistTracksUsecase,
    required this.coreController,
    required this.getArtistUsecase,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  final PlayerController playerController;
  final DownloaderController downloaderController;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final CoreController coreController;
  final GetArtistUsecase getArtistUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetTrackUsecase getTrackUsecase;

  @override
  State<MCorePage> createState() => _MCorePageState();
}

class _MCorePageState extends State<MCorePage> {
  int _selected = 0;
  final routes = [
    NavigatorPages.sectionsPage,
    NavigatorPages.searchPage,
    NavigatorPages.libraryPage,
    NavigatorPages.downloaderPage,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CoreBottomNavbar(
        getTrackUsecase: widget.getTrackUsecase,
        playerController: widget.playerController,
        downloaderController: widget.downloaderController,
        libraryController: widget.libraryController,
        getAlbumUsecase: widget.getAlbumUsecase,
        getPlayableItemUsecase: widget.getPlayableItemUsecase,
        getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
        getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
        getArtistTracksUsecase: widget.getArtistTracksUsecase,
        coreController: widget.coreController,
        getArtistUsecase: widget.getArtistUsecase,
        getPlaylistUsecase: widget.getPlaylistUsecase,
        selectedIndex: _selected,
        onItemSelected: (index) {
          setState(() {
            _selected = index;
          });
          LyNavigator.navigateTo(routes[index]);
        },
      ),
      body: const RouterOutlet(),
    );
  }
}
