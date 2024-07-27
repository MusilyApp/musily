import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/core_base_widget.dart';
import 'package:musily/core/utils/generate_placeholder_string.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_search_module/presenter/controllers/results_page/results_page_controller.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ArtistResultsPage extends StatefulWidget {
  final ResultsPageController resultsPageController;
  final CoreController coreController;
  final PlayerController playerController;
  final String searchQuery;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final LibraryController libraryController;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;

  const ArtistResultsPage({
    required this.resultsPageController,
    required this.searchQuery,
    required this.playerController,
    required this.coreController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    super.key,
    required this.libraryController,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  State<ArtistResultsPage> createState() => _ArtistResultsPageState();
}

class _ArtistResultsPageState extends State<ArtistResultsPage> {
  @override
  void initState() {
    super.initState();
    if (!widget.resultsPageController.data.keepSearchArtistState) {
      widget.resultsPageController.methods.searchArtists(
        widget.searchQuery,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CoreBaseWidget(
      coreController: widget.coreController,
      child: Scaffold(
        body: widget.resultsPageController.builder(
          builder: (context, data) {
            if (data.searchingArtists) {
              return Skeletonizer(
                child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(
                      Icons.music_note,
                    ),
                    title: Text(generatePlaceholderString()),
                    subtitle: Text(generatePlaceholderString()),
                  ),
                ),
              );
            }
            if (data.artistsResult.items.isEmpty) {
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
                        color:
                            Theme.of(context).iconTheme.color?.withOpacity(.5),
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: data.artistsResult.items.length,
              itemBuilder: (context, index) {
                final artist = data.artistsResult.items[index];
                return ListTile(
                  onTap: () => Navigator.push(
                    context,
                    DownupRouter(
                      builder: (context) => artist.topTracks.isNotEmpty
                          ? ArtistPage(
                              getAlbumUsecase: widget.getAlbumUsecase,
                              artist: artist,
                              coreController: widget.coreController,
                              playerController: widget.playerController,
                              downloaderController: widget.downloaderController,
                              getPlayableItemUsecase:
                                  widget.getPlayableItemUsecase,
                              libraryController: widget.libraryController,
                              getArtistUsecase: widget.getArtistUsecase,
                              getArtistAlbumsUsecase:
                                  widget.getArtistAlbumsUsecase,
                              getArtistTracksUsecase:
                                  widget.getArtistTracksUsecase,
                              getArtistSinglesUsecase:
                                  widget.getArtistSinglesUsecase,
                            )
                          : AsyncArtistPage(
                              artistId: artist.id,
                              coreController: widget.coreController,
                              playerController: widget.playerController,
                              downloaderController: widget.downloaderController,
                              getPlayableItemUsecase:
                                  widget.getPlayableItemUsecase,
                              libraryController: widget.libraryController,
                              getAlbumUsecase: widget.getAlbumUsecase,
                              getArtistUsecase: widget.getArtistUsecase,
                              getArtistAlbumsUsecase:
                                  widget.getArtistAlbumsUsecase,
                              getArtistTracksUsecase:
                                  widget.getArtistTracksUsecase,
                              getArtistSinglesUsecase:
                                  widget.getArtistSinglesUsecase,
                            ),
                    ),
                  ),
                  subtitle: const Text(
                    'Artista',
                  ),
                  leading: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(360),
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
                        if (artist.lowResImg != null) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(360),
                            child: AppImage(
                              artist.lowResImg!,
                              width: 40,
                              height: 40,
                            ),
                          );
                        }
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.person_rounded,
                          ),
                        );
                      },
                    ),
                  ),
                  title: Text(artist.name),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
