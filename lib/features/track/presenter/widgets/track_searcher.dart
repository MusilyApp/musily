import 'package:flutter/material.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';

class TrackSearcher extends StatelessWidget {
  final CoreController coreController;
  final PlayerController playerController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final DownloaderController downloaderController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final void Function(TrackEntity track, SearchController controller)?
      clickAction;
  final List<TrackEntity> tracks;

  const TrackSearcher({
    super.key,
    required this.tracks,
    required this.coreController,
    required this.playerController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.downloaderController,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    this.clickAction,
  });

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      isFullScreen: !context.display.isDesktop,
      builder: (context, controller) {
        return IconButton(
          onPressed: () {
            controller.openView();
          },
          icon: const Icon(
            Icons.search_rounded,
          ),
        );
      },
      viewBackgroundColor: context.display.isDesktop
          ? context.themeData.cardTheme.color
          : context.themeData.scaffoldBackgroundColor,
      viewShape: context.display.isDesktop
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
              side: BorderSide(
                color: context.themeData.dividerColor.withOpacity(
                  .2,
                ),
              ),
            )
          : null,
      suggestionsBuilder: (context, controller) {
        return [
          ...tracks
              .where(
                (e) => RegExp(
                  controller.text.toLowerCase().trim(),
                ).hasMatch(
                  '${e.title} ${e.artist.name} ${e.album.title}'
                      .toLowerCase()
                      .trim(),
                ),
              )
              .map<Widget>(
                (e) => TrackTile(
                  customAction: () => clickAction?.call(e, controller),
                  track: e,
                  coreController: coreController,
                  playerController: playerController,
                  getPlayableItemUsecase: getPlayableItemUsecase,
                  libraryController: libraryController,
                  downloaderController: downloaderController,
                  getAlbumUsecase: getAlbumUsecase,
                  getArtistUsecase: getArtistUsecase,
                  getArtistTracksUsecase: getArtistTracksUsecase,
                  getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                  getArtistSinglesUsecase: getArtistSinglesUsecase,
                ),
              )
              .toList()
            ..addAll(
              [
                PlayerSizedBox(
                  playerController: playerController,
                ),
              ],
            ),
        ];
      },
    );
  }
}
