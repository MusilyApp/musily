import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/core_base_widget.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/entitites/artist_entity.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';
import 'package:musily_player/musily_entities.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArtistTracksPage extends StatefulWidget {
  final List<TrackEntity> tracks;
  final ArtistEntity artist;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final CoreController coreController;
  final PlayerController playerController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final DownloaderController downloaderController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final GetArtistUsecase getArtistUsecase;
  final void Function(List<TrackEntity> tracks) onLoadedTracks;

  const ArtistTracksPage({
    super.key,
    required this.tracks,
    required this.artist,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.coreController,
    required this.playerController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.downloaderController,
    required this.getAlbumUsecase,
    required this.onLoadedTracks,
    required this.getArtistSinglesUsecase,
    required this.getArtistUsecase,
  });

  @override
  State<ArtistTracksPage> createState() => _ArtistTracksPageState();
}

class _ArtistTracksPageState extends State<ArtistTracksPage> {
  List<TrackEntity> allTracks = [];
  bool loadingTracks = false;

  Future<void> loadTracks() async {
    if (widget.tracks.isNotEmpty) {
      allTracks = widget.tracks;
      return;
    }
    setState(() {
      loadingTracks = true;
    });
    try {
      final tracks = await widget.getArtistTracksUsecase.exec(
        widget.artist.id,
      );
      setState(() {
        allTracks = tracks;
      });
      widget.onLoadedTracks(allTracks);
    } catch (e) {
      setState(() {
        allTracks = [];
      });
    }
    setState(() {
      loadingTracks = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTracks();
  }

  @override
  Widget build(BuildContext context) {
    return CoreBaseWidget(
      coreController: widget.coreController,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.songs,
          ),
        ),
        body: Builder(
          builder: (context) {
            if (loadingTracks) {
              return Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: Theme.of(context).colorScheme.primary,
                  size: 50,
                ),
              );
            }
            if (allTracks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.music_off_rounded,
                      size: 50,
                      color: Theme.of(context).iconTheme.color?.withOpacity(.7),
                    ),
                    Text(
                      AppLocalizations.of(context)!.songsNotFound,
                    )
                  ],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: allTracks.length,
                    itemBuilder: (context, index) {
                      final track = allTracks[index];
                      return TrackTile(
                        track: track,
                        coreController: widget.coreController,
                        playerController: widget.playerController,
                        getPlayableItemUsecase: widget.getPlayableItemUsecase,
                        libraryController: widget.libraryController,
                        downloaderController: widget.downloaderController,
                        getAlbumUsecase: widget.getAlbumUsecase,
                        getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                        getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                        getArtistTracksUsecase: widget.getArtistTracksUsecase,
                        getArtistUsecase: widget.getArtistUsecase,
                        customAction: () {
                          late final List<MusilyTrack> queueToPlay;
                          if (widget.playerController.data.playingId ==
                              widget.artist.id) {
                            queueToPlay = widget.playerController.data.queue;
                          } else {
                            queueToPlay = [
                              ...allTracks.map((element) =>
                                  TrackModel.toMusilyTrack(element))
                            ];
                          }

                          final startIndex = queueToPlay.indexWhere(
                            (element) => element.hash == track.hash,
                          );

                          widget.playerController.methods.playPlaylist(
                            queueToPlay,
                            widget.artist.id,
                            startFrom: startIndex == -1 ? 0 : startIndex,
                          );
                          widget.libraryController.methods.updateLastTimePlayed(
                            widget.artist.id,
                          );
                        },
                      );
                    },
                  ),
                ),
                widget.playerController.builder(
                  builder: (context, data) {
                    if (data.currentPlayingItem != null) {
                      return const SizedBox(
                        height: 70,
                      );
                    }
                    return Container();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
