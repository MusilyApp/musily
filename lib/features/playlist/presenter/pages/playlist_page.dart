import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/data/repositories/musily_repository_impl.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/screen_handler.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/core/domain/enums/content_origin.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/pages/m_playlist_page.dart';
import 'package:musily/features/track/domain/usecases/get_track_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class PlaylistPage extends StatefulWidget {
  final PlaylistEntity playlist;
  final CoreController coreController;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final LibraryController libraryController;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetTrackUsecase getTrackUsecase;
  final bool isAsync;

  const PlaylistPage({
    required this.playlist,
    required this.coreController,
    required this.playerController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    super.key,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    this.isAsync = false,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'PlaylistPage_${widget.playlist.id}',
      ignoreFromStack: widget.isAsync,
      child: widget.playerController.builder(
        builder: (context, data) {
          return ScreenHandler(
            mobile: MPlaylistPage(
              playlist: widget.playlist,
              coreController: widget.coreController,
              playerController: widget.playerController,
              downloaderController: widget.downloaderController,
              getPlayableItemUsecase: widget.getPlayableItemUsecase,
              libraryController: widget.libraryController,
              getAlbumUsecase: widget.getAlbumUsecase,
              getArtistUsecase: widget.getArtistUsecase,
              getArtistTracksUsecase: widget.getArtistTracksUsecase,
              getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
              getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
              getPlaylistUsecase: widget.getPlaylistUsecase,
              getTrackUsecase: widget.getTrackUsecase,
            ),
          );
        },
      ),
    );
  }
}

class AsyncPlaylistPage extends StatefulWidget {
  final CoreController coreController;
  final PlayerController playerController;
  final String playlistId;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetTrackUsecase getTrackUsecase;
  final ContentOrigin origin;

  const AsyncPlaylistPage({
    super.key,
    required this.playlistId,
    required this.coreController,
    required this.playerController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.origin,
    required this.getPlaylistUsecase,
    required this.getTrackUsecase,
  });

  @override
  State<AsyncPlaylistPage> createState() => _AsyncPlaylistPageState();
}

class _AsyncPlaylistPageState extends State<AsyncPlaylistPage> {
  bool loadingPlaylist = true;
  PlaylistEntity? playlist;

  loadPlaylist() async {
    setState(() {
      loadingPlaylist = true;
    });
    if (widget.origin == ContentOrigin.library) {
      await widget.libraryController.methods.getLibraryItem(widget.playlistId);
      playlist = widget.libraryController.data.items
          .where((e) => e.id == widget.playlistId)
          .firstOrNull
          ?.playlist;
    } else {
      playlist = await MusilyRepositoryImpl().getPlaylist(widget.playlistId);
    }
    setState(() {
      loadingPlaylist = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'AsyncPlaylistPage_${widget.playlistId}',
      child: Scaffold(
        appBar: playlist == null ? AppBar() : null,
        body: widget.libraryController.builder(
          builder: (context, data) {
            if (loadingPlaylist || data.loading) {
              return Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: context.themeData.colorScheme.primary,
                  size: 50,
                ),
              );
            }
            if (playlist == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.info,
                      size: 50,
                      color: context.themeData.iconTheme.color?.withValues(
                        alpha: .7,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(context.localization.playlistNotFound),
                  ],
                ),
              );
            }
            return PlaylistPage(
              playlist: playlist!,
              getTrackUsecase: widget.getTrackUsecase,
              getPlaylistUsecase: widget.getPlaylistUsecase,
              isAsync: true,
              coreController: widget.coreController,
              playerController: widget.playerController,
              downloaderController: widget.downloaderController,
              getPlayableItemUsecase: widget.getPlayableItemUsecase,
              libraryController: widget.libraryController,
              getAlbumUsecase: widget.getAlbumUsecase,
              getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
              getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
              getArtistTracksUsecase: widget.getArtistTracksUsecase,
              getArtistUsecase: widget.getArtistUsecase,
            );
          },
        ),
      ),
    );
  }
}
