import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/widgets/track_downloader_widget.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';
import 'package:musily/features/track/data/models/track_model.dart';
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
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final Widget? leading;
  final void Function()? customAction;
  final List<Widget> Function(BuildContext context)? customOptions;
  final List<TrackTileOptions>? hideOptions;
  const TrackTile({
    required this.track,
    required this.coreController,
    required this.playerController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.downloaderController,
    this.hideOptions,
    this.customOptions,
    this.leading,
    this.customAction,
    super.key,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
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
      return ListTile(
        onTap: widget.customAction ??
            () async {
              if (data.playingId == widget.track.hash) {
                widget.playerController.methods.pause();
              } else {
                widget.playerController.methods.loadAndPlay(
                  TrackModel.toMusilyTrack(widget.track),
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
                  color: Theme.of(context).colorScheme.outline.withOpacity(.2),
                ),
              ),
              child: Builder(
                builder: (context) {
                  if (widget.track.lowResImg != null &&
                      widget.track.highResImg!.isNotEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
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
                      color: Theme.of(context).iconTheme.color?.withOpacity(.7),
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
            TrackDownloaderWidget(
              downloaderController: widget.downloaderController,
              track: widget.track,
              getPlayableItemUsecase: widget.getPlayableItemUsecase,
            ),
            TrackOptionsBuilder(
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
              builder: (
                BuildContext context,
                void Function() showOptions,
              ) {
                return IconButton(
                  onPressed: showOptions,
                  icon: const Icon(
                    Icons.more_vert_outlined,
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
