import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/core_base_dialog.dart';
import 'package:musily/core/presenter/widgets/menu_entry.dart';
import 'package:musily/core/utils/display_helper.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/playlist_adder.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/pages/album_page.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/artist/presenter/pages/artist_page.dart';
import 'package:musily/features/downloader/presenter/widgets/downloader_menu_entry.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/data/models/track_model.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/features/track/presenter/widgets/track_tile.dart';
import 'package:musily/features/track/presenter/widgets/track_tile_static.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:musily_player/presenter/widgets/download_button.dart';

class TrackOptionsBuilder extends StatelessWidget {
  final TrackEntity track;
  final CoreController coreController;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final LibraryController libraryController;
  final GetAlbumUsecase getAlbumUsecase;
  final List<Widget> Function(BuildContext context)? customActions;
  final List<TrackTileOptions>? hideOptions;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final Widget Function(
    BuildContext context,
    void Function()? showOptions,
  ) builder;
  const TrackOptionsBuilder({
    required this.track,
    required this.builder,
    required this.coreController,
    required this.playerController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    this.hideOptions,
    this.customActions,
    super.key,
    required this.getAlbumUsecase,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = DisplayHelper(context).isDesktop;
    if (isDesktop) {
      return downloaderController.builder(
        builder: (context, data) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: MenuBar(
              style: const MenuStyle(
                padding: WidgetStatePropertyAll(
                  EdgeInsets.zero,
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Colors.transparent,
                ),
                elevation: WidgetStatePropertyAll(0),
              ),
              children: [
                ...MenuEntry.build(context, [
                  MenuEntry(
                    child: const Icon(
                      Icons.more_horiz_rounded,
                    ),
                    menuChildren: [
                      // TODO custom actions
                      if (!(hideOptions ?? [])
                          .contains(TrackTileOptions.download))
                        (DownloaderMenuEntry(
                          downloaderController: downloaderController,
                        )).builder(
                          context,
                          TrackModel.toMusilyTrack(track),
                        ),
                      if (!(hideOptions ?? [])
                          .contains(TrackTileOptions.addToPlaylist))
                        MenuEntry(
                          leading: Icon(
                            Icons.playlist_add_rounded,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                ?.primary,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  height:
                                      MediaQuery.of(context).size.height * .6,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: Theme.of(context)
                                            .dividerColor
                                            .withOpacity(.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: PlaylistAdderWidget(
                                      libraryController: libraryController,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.addToPlaylist,
                          ),
                        ),
                      if (!(hideOptions ?? [])
                          .contains(TrackTileOptions.addToQueue))
                        MenuEntry(
                          onPressed: () {
                            playerController.methods
                                .addToQueue([TrackModel.toMusilyTrack(track)]);
                            coreController.updateData(
                              coreController.data.copyWith(
                                isShowingDialog: false,
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.addToQueue,
                          ),
                          leading: Icon(
                            Icons.queue_music_rounded,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                ?.primary,
                          ),
                        ),
                      if (!(hideOptions ?? [])
                          .contains(TrackTileOptions.seeAlbum))
                        if (track.album.id.isNotEmpty)
                          MenuEntry(
                            onPressed: () {
                              coreController.updateData(
                                coreController.data.copyWith(
                                  isShowingDialog: false,
                                ),
                              );
                              coreController.methods.pushWidget(
                                AsyncAlbumPage(
                                  albumId: track.album.id,
                                  coreController: coreController,
                                  playerController: playerController,
                                  getAlbumUsecase: getAlbumUsecase,
                                  downloaderController: downloaderController,
                                  getPlayableItemUsecase:
                                      getPlayableItemUsecase,
                                  libraryController: libraryController,
                                  getArtistAlbumsUsecase:
                                      getArtistAlbumsUsecase,
                                  getArtistSinglesUsecase:
                                      getArtistSinglesUsecase,
                                  getArtistTracksUsecase:
                                      getArtistTracksUsecase,
                                  getArtistUsecase: getArtistUsecase,
                                ),
                              );
                            },
                            child:
                                Text(AppLocalizations.of(context)!.goToAlbum),
                            leading: Icon(
                              Icons.album_rounded,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme
                                  ?.primary,
                            ),
                          ),
                      if (!(hideOptions ?? [])
                          .contains(TrackTileOptions.seeArtist))
                        MenuEntry(
                          onPressed: () {
                            coreController.updateData(
                              coreController.data.copyWith(
                                isShowingDialog: false,
                              ),
                            );
                            coreController.methods.pushWidget(
                              AsyncArtistPage(
                                artistId: track.artist.id,
                                coreController: coreController,
                                playerController: playerController,
                                downloaderController: downloaderController,
                                getPlayableItemUsecase: getPlayableItemUsecase,
                                libraryController: libraryController,
                                getAlbumUsecase: getAlbumUsecase,
                                getArtistUsecase: getArtistUsecase,
                                getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                                getArtistTracksUsecase: getArtistTracksUsecase,
                                getArtistSinglesUsecase:
                                    getArtistSinglesUsecase,
                              ),
                            );
                          },
                          child: Text(AppLocalizations.of(context)!.goToArtist),
                          leading: Icon(
                            Icons.person_rounded,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                ?.primary,
                          ),
                        ),
                      if (!(hideOptions ?? []).contains(TrackTileOptions.share))
                        MenuEntry(
                          child: Text(AppLocalizations.of(context)!.share),
                          leading: Icon(
                            Icons.share_rounded,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                ?.primary,
                          ),
                        ),
                    ],
                  ),
                ]),
              ],
            ),
          );
        },
      );
    }
    return builder(context, () {
      coreController.methods.pushModal(
        CoreBaseDialog(
          coreController: coreController,
          child: TrackOptions(
            track: track,
            coreController: coreController,
            playerController: playerController,
            downloaderController: downloaderController,
            getPlayableItemUsecase: getPlayableItemUsecase,
            libraryController: libraryController,
            customActions: customActions,
            hideOptions: hideOptions,
            getAlbumUsecase: getAlbumUsecase,
            getArtistAlbumsUsecase: getArtistAlbumsUsecase,
            getArtistSinglesUsecase: getArtistSinglesUsecase,
            getArtistTracksUsecase: getArtistTracksUsecase,
            getArtistUsecase: getArtistUsecase,
          ),
        ),
      );
    });
  }
}

class TrackOptions extends StatelessWidget {
  final TrackEntity track;
  final CoreController coreController;
  final PlayerController playerController;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetAlbumUsecase getAlbumUsecase;
  final LibraryController libraryController;
  final List<Widget> Function(BuildContext context)? customActions;
  final List<TrackTileOptions>? hideOptions;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  const TrackOptions({
    super.key,
    required this.track,
    required this.coreController,
    required this.playerController,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getAlbumUsecase,
    this.hideOptions,
    this.customActions,
    required this.getArtistUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TrackTileStatic(
            track: track,
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                if (customActions != null) ...customActions!.call(context),
                if (!(hideOptions ?? []).contains(TrackTileOptions.download))
                  DownloadButtonBuilder(
                    track: TrackModel.toMusilyTrack(track),
                    controller: downloaderController,
                    builder: (context, item) {
                      if (item == null) {
                        return ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            downloaderController.methods.addDownload(
                              TrackModel.toMusilyTrack(
                                track,
                              ),
                            );
                            downloaderController.methods.setDownloadingKey(
                              track.hash,
                            );
                          },
                          leading: Icon(
                            Icons.download_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(AppLocalizations.of(context)!.download),
                        );
                      }
                      if (item.status == item.downloadCompleted) {
                        return ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            downloaderController.methods.deleteDownloadedFile(
                              track: TrackModel.toMusilyTrack(
                                track,
                              ),
                            );
                          },
                          leading: Icon(
                            Icons.delete_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.deleteDownload,
                          ),
                        );
                      }
                      return ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          final item = downloaderController.methods.getItem(
                            TrackModel.toMusilyTrack(
                              track,
                            ),
                          );
                          if (item?.track.url != null) {
                            downloaderController.methods.cancelDownload(
                              item!.track.url!,
                            );
                          }
                        },
                        leading: Icon(
                          Icons.cancel_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title:
                            Text(AppLocalizations.of(context)!.cancelDownload),
                      );
                    },
                  ),
                if (!(hideOptions ?? [])
                    .contains(TrackTileOptions.addToPlaylist))
                  PlaylistAdder(
                    libraryController,
                    onAdded: () {
                      Navigator.pop(context);
                      coreController.updateData(
                        coreController.data.copyWith(
                          isShowingDialog: false,
                        ),
                      );
                    },
                    builder: (context, showAdder) {
                      return ListTile(
                        onTap: showAdder,
                        title:
                            Text(AppLocalizations.of(context)!.addToPlaylist),
                        leading: Icon(
                          Icons.playlist_add_rounded,
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme
                              ?.primary,
                        ),
                      );
                    },
                    tracks: [track],
                  ),
                if (!(hideOptions ?? []).contains(TrackTileOptions.addToQueue))
                  ListTile(
                    onTap: () {
                      playerController.methods
                          .addToQueue([TrackModel.toMusilyTrack(track)]);
                      Navigator.pop(context);
                      coreController.updateData(
                        coreController.data.copyWith(
                          isShowingDialog: false,
                        ),
                      );
                    },
                    title: Text(
                      AppLocalizations.of(context)!.addToQueue,
                    ),
                    leading: Icon(
                      Icons.queue_music_rounded,
                      color: Theme.of(context).buttonTheme.colorScheme?.primary,
                    ),
                  ),
                if (!(hideOptions ?? []).contains(TrackTileOptions.seeAlbum))
                  if (track.album.id.isNotEmpty)
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        coreController.updateData(
                          coreController.data.copyWith(
                            isShowingDialog: false,
                          ),
                        );
                        coreController.methods.pushWidget(
                          AsyncAlbumPage(
                            albumId: track.album.id,
                            coreController: coreController,
                            playerController: playerController,
                            getAlbumUsecase: getAlbumUsecase,
                            downloaderController: downloaderController,
                            getPlayableItemUsecase: getPlayableItemUsecase,
                            libraryController: libraryController,
                            getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                            getArtistSinglesUsecase: getArtistSinglesUsecase,
                            getArtistTracksUsecase: getArtistTracksUsecase,
                            getArtistUsecase: getArtistUsecase,
                          ),
                        );
                      },
                      title: Text(AppLocalizations.of(context)!.goToAlbum),
                      leading: Icon(
                        Icons.album_rounded,
                        color:
                            Theme.of(context).buttonTheme.colorScheme?.primary,
                      ),
                    ),
                if (!(hideOptions ?? []).contains(TrackTileOptions.seeArtist))
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      coreController.updateData(
                        coreController.data.copyWith(
                          isShowingDialog: false,
                        ),
                      );
                      coreController.methods.pushWidget(
                        AsyncArtistPage(
                          artistId: track.artist.id,
                          coreController: coreController,
                          playerController: playerController,
                          downloaderController: downloaderController,
                          getPlayableItemUsecase: getPlayableItemUsecase,
                          libraryController: libraryController,
                          getAlbumUsecase: getAlbumUsecase,
                          getArtistUsecase: getArtistUsecase,
                          getArtistAlbumsUsecase: getArtistAlbumsUsecase,
                          getArtistTracksUsecase: getArtistTracksUsecase,
                          getArtistSinglesUsecase: getArtistSinglesUsecase,
                        ),
                      );
                    },
                    title: Text(AppLocalizations.of(context)!.goToArtist),
                    leading: Icon(
                      Icons.person_rounded,
                      color: Theme.of(context).buttonTheme.colorScheme?.primary,
                    ),
                  ),
                if (!(hideOptions ?? []).contains(TrackTileOptions.share))
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.share),
                    leading: Icon(
                      Icons.share_rounded,
                      color: Theme.of(context).buttonTheme.colorScheme?.primary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
