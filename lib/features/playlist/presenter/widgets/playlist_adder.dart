import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/playlist/domain/usecases/get_playlist_usecase.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_creator.dart';
import 'package:musily/features/playlist/presenter/widgets/playlist_tile_thumb.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class PlaylistAdder extends StatefulWidget {
  final LibraryController libraryController;
  final CoreController coreController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final BuildContext? contextDialog;
  final Widget Function(
    BuildContext context,
    Function() showAdder,
  ) builder;
  final Future<List<TrackEntity>> Function()? asyncTracks;
  final List<TrackEntity> tracks;
  final void Function()? onAdded;
  const PlaylistAdder(
    this.libraryController, {
    required this.builder,
    required this.coreController,
    this.tracks = const [],
    this.asyncTracks,
    this.onAdded,
    super.key,
    required this.getPlaylistUsecase,
    this.contextDialog,
  });

  @override
  State<PlaylistAdder> createState() => _PlaylistAdderState();
}

class _PlaylistAdderState extends State<PlaylistAdder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      () {
        LyNavigator.showLyDialog(
          context: context,
          builder: (context) => PlaylistAdderWidget(
            onAdded: widget.onAdded,
            coreController: widget.coreController,
            getPlaylistUsecase: widget.getPlaylistUsecase,
            libraryController: widget.libraryController,
            tracks: widget.tracks,
            asyncTracks: widget.asyncTracks,
          ),
        );
      },
    );
  }
}

class PlaylistAdderWidget extends StatelessWidget {
  final List<TrackEntity> tracks;
  final Future<List<TrackEntity>> Function()? asyncTracks;
  final LibraryController libraryController;
  final GetPlaylistUsecase getPlaylistUsecase;
  final CoreController coreController;
  final void Function()? onAdded;
  final BuildContext? contextDialog;
  const PlaylistAdderWidget({
    super.key,
    required this.libraryController,
    this.tracks = const [],
    this.asyncTracks,
    this.onAdded,
    required this.coreController,
    required this.getPlaylistUsecase,
    this.contextDialog,
  });

  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'PlaylistAdderWidget',
      child: Scaffold(
        backgroundColor: context.themeData.colorScheme.surface,
        appBar: context.display.isDesktop
            ? null
            : MusilyAppBar(
                backgroundColor: context.themeData.colorScheme.surface,
                title: Text(
                  context.localization.addToPlaylist,
                  style: context.themeData.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
        floatingActionButton: PlaylistCreator(
          libraryController,
          coreController: coreController,
          getPlaylistUsecase: getPlaylistUsecase,
          builder: (context, showCreator) => FloatingActionButton.extended(
            onPressed: showCreator,
            icon: const Icon(LucideIcons.listPlus),
            label: Text(context.localization.createPlaylist),
          ),
        ),
        body: libraryController.builder(
          builder: (context, data) {
            final playlist =
                data.items.where((e) => e.playlist != null).toList();

            if (playlist.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context
                              .themeData.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: context.themeData.colorScheme.outline
                                .withValues(alpha: 0.15),
                          ),
                        ),
                        child: Icon(
                          LucideIcons.listX,
                          size: 36,
                          color: context.themeData.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.localization.noPlaylists,
                        style: context.themeData.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.localization.playlistEmptyStateDescription,
                        textAlign: TextAlign.center,
                        style: context.themeData.textTheme.bodyMedium?.copyWith(
                          color: context.themeData.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.themeData.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: context.themeData.colorScheme.outline
                          .withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: context.themeData.colorScheme.primary
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          LucideIcons.listMusic,
                          size: 20,
                          color: context.themeData.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.localization.playlistSelectTitle,
                              style: context.themeData.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.localization.playlistSelectDescription,
                              style: context.themeData.textTheme.bodySmall
                                  ?.copyWith(
                                color: context.themeData.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (contextDialog != null)
                        IconButton(
                          onPressed: () {
                            Navigator.pop(contextDialog!);
                          },
                          icon: const Icon(LucideIcons.x, size: 20),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      final scaffoldColor =
                          context.themeData.scaffoldBackgroundColor;
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          scaffoldColor,
                          scaffoldColor,
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.05, 0.95, 1],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 60),
                      itemCount: playlist.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = playlist[index];
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () async {
                              LyNavigator.pop(contextDialog!);
                              late final List<TrackEntity> tracksToAdd;
                              if (tracks.isEmpty) {
                                tracksToAdd = await asyncTracks?.call() ?? [];
                              } else {
                                tracksToAdd = tracks;
                              }
                              libraryController.methods.addTracksToPlaylist(
                                item.id,
                                tracksToAdd,
                              );
                              onAdded?.call();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: context.themeData.colorScheme.surface,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: context.themeData.colorScheme.outline
                                      .withValues(alpha: 0.08),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: context.themeData.colorScheme.shadow
                                        .withValues(alpha: 0.05),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  PlaylistTileThumb(
                                    playlist: item.playlist!,
                                    size: 42,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.playlist!.id ==
                                                  UserService.favoritesId
                                              ? context.localization.favorites
                                              : item.playlist!.title,
                                          style: context
                                              .themeData.textTheme.titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${context.localization.playlist} · ${item.playlist!.trackCount} ${context.localization.songs}',
                                          style: context
                                              .themeData.textTheme.bodySmall
                                              ?.copyWith(
                                            color: context
                                                .themeData.colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    LucideIcons.chevronRight,
                                    size: 18,
                                    color: context
                                        .themeData.colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
