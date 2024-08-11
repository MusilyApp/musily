import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/utils/generate_placeholder_string.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TrackResultsPage extends StatefulWidget {
  final String searchQuery;
  final ResultsPageController resultsPageController;
  final LibraryController libraryController;
  final CoreController coreController;
  final GetAlbumUsecase getAlbumUsecase;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final DownloaderController downloaderController;
  final PlayerController playerController;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const TrackResultsPage({
    required this.resultsPageController,
    required this.libraryController,
    required this.searchQuery,
    required this.getAlbumUsecase,
    required this.coreController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.playerController,
    super.key,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  State<TrackResultsPage> createState() => _TrackResultsPageState();
}

class _TrackResultsPageState extends State<TrackResultsPage> {
  @override
  void initState() {
    super.initState();
    if (!widget.resultsPageController.data.keepSearchTrackState) {
      widget.resultsPageController.methods.searchTracks(
        widget.searchQuery,
        limit: 15,
        page: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.resultsPageController.builder(
        builder: (context, data) {
          if (data.searchingTracks) {
            return Skeletonizer(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(
                    Icons.music_note,
                  ),
                  title: Text(generatePlaceholderString(maxLength: 17)),
                  subtitle: Text(generatePlaceholderString(maxLength: 17)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.music_note,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.music_note,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (data.tracksResult.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 50,
                    color: Theme.of(context).iconTheme.color?.withOpacity(.5),
                  ),
                  Text(
                    'Sem resultados',
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color?.withOpacity(.5),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: data.tracksResult.items.length,
            itemBuilder: (context, index) {
              final track = data.tracksResult.items[index];
              return TrackTile(
                track: track,
                getAlbumUsecase: widget.getAlbumUsecase,
                coreController: widget.coreController,
                playerController: widget.playerController,
                downloaderController: widget.downloaderController,
                getPlayableItemUsecase: widget.getPlayableItemUsecase,
                libraryController: widget.libraryController,
                getArtistAlbumsUsecase: widget.getArtistAlbumsUsecase,
                getArtistSinglesUsecase: widget.getArtistSinglesUsecase,
                getArtistTracksUsecase: widget.getArtistTracksUsecase,
                getArtistUsecase: widget.getArtistUsecase,
              );
            },
          );
        },
      ),
    );
  }
}
