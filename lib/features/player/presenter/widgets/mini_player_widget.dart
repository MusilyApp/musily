import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/favorite/presenter/widgets/favorite_button.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';
import 'package:musily/features/player/presenter/widgets/player_widget.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily_player/widget/utils/infinity_marquee.dart';

class MiniPlayerWidget extends StatefulWidget {
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final CoreController coreController;
  final LibraryController libraryController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistUsecase getArtistUsecase;
  final ResultsPageController resultsPageController;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const MiniPlayerWidget({
    required this.downloaderController,
    required this.playerController,
    required this.getAlbumUsecase,
    required this.coreController,
    required this.libraryController,
    required this.getPlayableItemUsecase,
    required this.getArtistUsecase,
    required this.resultsPageController,
    super.key,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
}

class _MiniPlayerWidgetState extends State<MiniPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.playerController.builder(
      builder: (context, data) {
        if (data.currentPlayingItem != null) {
          return InkWell(
            onTap: () async {
              widget.coreController.updateData(
                widget.coreController.data.copyWith(
                  isPlayerExpanded: true,
                ),
              );
              Navigator.of(context).push(
                DownupRouter(
                  builder: (context) => PlayerWidget(
                    getPlayableItemUsecase: widget.getPlayableItemUsecase,
                    downloaderController: widget.downloaderController,
                    getArtistUsecase: widget.getArtistUsecase,
                    resultsPageController: widget.resultsPageController,
                    getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                    getArtistTracksUsecase: widget.getArtistTracksUsecase,
                    getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                    onClose: () {
                      Navigator.of(context).pop();
                      widget.coreController.updateData(
                        widget.coreController.data.copyWith(
                          isPlayerExpanded: false,
                        ),
                      );
                    },
                    coreController: widget.coreController,
                    playerController: widget.playerController,
                    libraryController: widget.libraryController,
                    getAlbumUsecase: widget.getAlbumUsecase,
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.outline.withOpacity(.2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outline
                                      .withOpacity(.2),
                                ),
                              ),
                              child: Builder(
                                builder: (context) {
                                  if (data.currentPlayingItem!.lowResImg !=
                                          null &&
                                      data.currentPlayingItem!.lowResImg!
                                          .isNotEmpty) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: AppImage(
                                        data.currentPlayingItem!.lowResImg!,
                                        width: 45,
                                        height: 45,
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    height: 45,
                                    width: 45,
                                    child: Icon(
                                      Icons.music_note,
                                      color: Theme.of(context)
                                          .iconTheme
                                          .color
                                          ?.withOpacity(.7),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 180,
                                  child: InfinityMarquee(
                                    child: Text(
                                      data.currentPlayingItem!.title ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: InfinityMarquee(
                                    child: Text(
                                      data.currentPlayingItem!.artist?.name ??
                                          '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            FavoriteButton(
                              libraryController: widget.libraryController,
                              track: TrackModel.fromMusilyTrack(
                                  data.currentPlayingItem!),
                            ),
                            Builder(builder: (context) {
                              if (data.currentPlayingItem?.duration.inSeconds ==
                                  0) {
                                return SizedBox(
                                  width: 48,
                                  height: 30,
                                  child: Center(
                                    child:
                                        LoadingAnimationWidget.halfTriangleDot(
                                      color:
                                          Theme.of(context).iconTheme.color ??
                                              Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                );
                              }
                              return IconButton(
                                onPressed: () {
                                  if (data.isPlaying) {
                                    widget.playerController.methods.pause();
                                  } else {
                                    widget.playerController.methods.resume();
                                  }
                                },
                                icon: Icon(
                                  data.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 30,
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      height: 2,
                      child: Builder(builder: (context) {
                        late final double progressBarValue;
                        final progress = data.currentPlayingItem!.position;
                        final total = data.currentPlayingItem!.duration;
                        if (progress.inMilliseconds == 0 ||
                            total.inMilliseconds == 0) {
                          progressBarValue = 0;
                        } else {
                          progressBarValue =
                              progress.inMilliseconds / total.inMilliseconds;
                        }
                        return LinearProgressIndicator(
                          value: progressBarValue,
                          backgroundColor: Colors.white.withOpacity(.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).buttonTheme.colorScheme!.primary,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
