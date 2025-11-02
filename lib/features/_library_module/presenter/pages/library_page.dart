import 'package:flutter/material.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/screen_handler.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/pages/m_library_page.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';

class LibraryPage extends StatefulWidget {
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final CoreController coreController;
  final LibraryController libraryController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final DownloaderController downloaderController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetTrackUsecase getTrackUsecase;

  const LibraryPage({
    required this.playerController,
    required this.getAlbumUsecase,
    required this.coreController,
    required this.libraryController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    super.key,
    required this.getPlaylistUsecase,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'LibraryPage',
      ignoreFromStack: context.display.isDesktop,
      // TODO implement other layouts
      child: ScreenHandler(
        mobile: MLibraryPage(
          playerController: widget.playerController,
          getAlbumUsecase: widget.getAlbumUsecase,
          coreController: widget.coreController,
          libraryController: widget.libraryController,
          downloaderController: widget.downloaderController,
          getPlayableItemUsecase: widget.getPlayableItemUsecase,
          getPlaylistUsecase: widget.getPlaylistUsecase,
          getArtistUsecase: widget.getArtistUsecase,
          getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
          getArtistTracksUsecase: widget.getArtistTracksUsecase,
          getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
          getTrackUsecase: widget.getTrackUsecase,
        ),
      ),
    );
  }
}
