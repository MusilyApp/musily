import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/playlist_tile_thumb.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';
import 'package:musily/features/playlist/domain/entities/playlist_entity.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/pages/playlist_page.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_options.dart';

class PlaylistTile extends StatelessWidget {
  final PlaylistEntity playlist;
  final PlayerController playerController;
  final CoreController coreController;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  final void Function()? customClickAction;
  const PlaylistTile({
    required this.playlist,
    required this.libraryController,
    required this.playerController,
    required this.coreController,
    required this.getAlbumUsecase,
    this.customClickAction,
    super.key,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getPlaylistUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (customClickAction != null) {
          customClickAction!.call();
          return;
        }
        coreController.methods.pushWidget(
          PlaylistPage(
            coreController: coreController,
            playlist: playlist,
            playerController: playerController,
            downloaderController: downloaderController,
            getPlayableItemUsecase: getPlayableItemUsecase,
            libraryController: libraryController,
            getAlbumUsecase: getAlbumUsecase,
            getPlaylistUsecase: getPlaylistUsecase,
            getArtistAlbumsUsecase: getArtistAlbumsUsecase,
            getArtistSinglesUsecase: getArtistSinglesUsecase,
            getArtistTracksUsecase: getArtistTracksUsecase,
            getArtistUsecase: getArtistUsecase,
          ),
        );
      },
      leading: PlaylistTileThumb(
        urls: playlist.tracks
            .map((track) => track.lowResImg?.replaceAll('w60-h60', 'w40-h40'))
            .whereType<String>()
            .toSet()
            .toList()
          ..shuffle(
            Random(),
          ),
      ),
      title: Text(
        playlist.title,
      ),
      subtitle: Text(
        'Playlist · ${playlist.tracks.length} músicas',
      ),
      trailing: PlaylistOptionsBuilder(
        playlistEntity: playlist,
        coreController: coreController,
        playerController: playerController,
        getAlbumUsecase: getAlbumUsecase,
        downloaderController: downloaderController,
        getPlayableItemUsecase: getPlayableItemUsecase,
        libraryController: libraryController,
        getPlaylistUsecase: getPlaylistUsecase,
        builder: (context, showOptions) => IconButton(
          onPressed: showOptions,
          icon: const Icon(
            Icons.more_vert_rounded,
          ),
        ),
      ),
    );
  }
}
