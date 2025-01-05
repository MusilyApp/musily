import 'package:flutter/material.dart';
import 'package:musily/core/domain/entities/app_menu_entry.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/widgets/download_button.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/presenter/widgets/track_options.dart';

enum TrackTileOptions {
  addToPlaylist,
  addToQueue,
  seeAlbum,
  seeArtist,
  share,
  download,
}

class TrackTile extends StatefulWidget {
  final TrackEntity track;
  final CoreController coreController;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlaylistUsecase getPlaylistUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final Widget? leading;
  final void Function()? customAction;
  final List<AppMenuEntry> Function(BuildContext context)? customOptions;
  final List<TrackTileOptions> hideOptions;
  const TrackTile({
    required this.track,
    required this.coreController,
    required this.playerController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.downloaderController,
    this.hideOptions = const [],
    this.customOptions,
    this.leading,
    this.customAction,
    super.key,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getPlaylistUsecase,
  });

  @override
  State<TrackTile> createState() => _TrackTileState();
}

class _TrackTileState extends State<TrackTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.playerController.builder(builder: (context, data) {
      return LyListTile(
        // focusColor: Colors.transparent,
        minTileHeight: 60,
        onTap: widget.customAction ??
            () async {
              if (data.playingId == widget.track.hash) {
                widget.playerController.methods.pause();
              } else {
                widget.playerController.methods.loadAndPlay(
                  widget.track,
                  widget.track.hash,
                );
              }
            },
        title: Text(
          widget.track.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: widget.leading ??
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  width: 1,
                  color: context.themeData.colorScheme.outline.withOpacity(.2),
                ),
              ),
              child: Builder(
                builder: (context) {
                  if (widget.track.lowResImg != null &&
                      widget.track.lowResImg!.isNotEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AppImage(
                        widget.track.lowResImg!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.music_note,
                      color: context.themeData.iconTheme.color?.withOpacity(.7),
                    ),
                  );
                },
              ),
            ),
        subtitle: Text(
          widget.track.artist.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DownloadButton(
              controller: widget.downloaderController,
              track: widget.track,
            ),
            TrackOptions(
              getPlaylistUsecase: widget.getPlaylistUsecase,
              hideOptions: widget.hideOptions,
              coreController: widget.coreController,
              track: widget.track,
              playerController: widget.playerController,
              downloaderController: widget.downloaderController,
              getPlayableItemUsecase: widget.getPlayableItemUsecase,
              libraryController: widget.libraryController,
              customActions: widget.customOptions,
              getAlbumUsecase: widget.getAlbumUsecase,
              getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
              getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
              getArtistTracksUsecase: widget.getArtistTracksUsecase,
              getArtistUsecase: widget.getArtistUsecase,
            ),
          ],
        ),
      );
    });
  }
}
