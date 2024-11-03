import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/usecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/player/presenter/widgets/track_lyrics.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';

class PlayerBanner extends StatefulWidget {
  final TrackEntity track;
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

  const PlayerBanner({
    super.key,
    required this.track,
    required this.playerController,
    required this.libraryController,
    required this.getAlbumUsecase,
    required this.getPlayableItemUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
    required this.getArtistTracksUsecase,
    required this.coreController,
    required this.getArtistUsecase,
    required this.downloaderController,
  });

  @override
  State<PlayerBanner> createState() => _PlayerBannerState();
}

class _PlayerBannerState extends State<PlayerBanner> {
  @override
  Widget build(BuildContext context) {
    return widget.playerController.builder(
      builder: (context, data) {
        return Stack(
          children: [
            AnimatedOpacity(
              opacity: data.showLyrics ? 1.0 : 0.0,
              duration: Duration(milliseconds: data.showLyrics ? 400 : 70),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 414,
                width: MediaQuery.of(context).size.width,
                child: Builder(builder: (context) {
                  if (data.loadingLyrics) {
                    return Center(
                      child: LoadingAnimationWidget.waveDots(
                        color: IconTheme.of(context).color ?? Colors.white,
                        size: 45,
                      ),
                    );
                  }
                  if (data.lyrics.lyrics == null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.music_off_rounded,
                            size: 45,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            context.localization.lyricsNotFound,
                            style:
                                context.themeData.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return TrackLyrics(
                    totalDuration: widget.track.duration,
                    currentPosition: widget.track.position,
                    synced: data.syncedLyrics,
                    lyrics: data.lyrics.lyrics!,
                  );
                }),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 414,
              child: Center(
                child: AnimatedOpacity(
                  opacity: data.showLyrics ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: data.showLyrics
                      ? const SizedBox.shrink()
                      : MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: !data.showLyrics
                                ? () {
                                    LyNavigator.close('player');
                                    LyNavigator.push(
                                      context.showingPageContext,
                                      AsyncAlbumPage(
                                        albumId:
                                            data.currentPlayingItem!.album.id,
                                        coreController: widget.coreController,
                                        playerController:
                                            widget.playerController,
                                        getAlbumUsecase: widget.getAlbumUsecase,
                                        downloaderController:
                                            widget.downloaderController,
                                        getPlayableItemUsecase:
                                            widget.getPlayableItemUsecase,
                                        libraryController:
                                            widget.libraryController,
                                        getArtistAlbumsUsecase:
                                            widget.getArtistAlbumsUsecase,
                                        getArtistSinglesUsecase:
                                            widget.getArtistSinglesUsecase,
                                        getArtistTracksUsecase:
                                            widget.getArtistTracksUsecase,
                                        getArtistUsecase:
                                            widget.getArtistUsecase,
                                      ),
                                    );
                                  }
                                : null,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Builder(
                                    builder: (context) {
                                      if (widget.track.highResImg != null &&
                                          widget.track.highResImg!.isNotEmpty) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: AppImage(
                                            height: 350,
                                            width: 350,
                                            widget.track.highResImg!,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                            width: 1,
                                            color: context
                                                .themeData.colorScheme.outline
                                                .withOpacity(.2),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 350,
                                              width: 350,
                                              child: Icon(
                                                Icons.music_note,
                                                size: 75,
                                                color: context
                                                    .themeData.iconTheme.color
                                                    ?.withOpacity(.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (data.tracksFromSmartQueue.contains(
                                  widget.track.hash,
                                ))
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Container(
                                      height: 350,
                                      width: 350,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            context
                                                .themeData.colorScheme.primary,
                                            context
                                                .themeData.colorScheme.primary
                                                .withOpacity(.2),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          CupertinoIcons.wand_stars,
                                          color: context
                                              .themeData.colorScheme.onPrimary,
                                          size: 60,
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
