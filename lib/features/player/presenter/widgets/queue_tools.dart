import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_text_field.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/ui/utils/ly_snackbar.dart';
import 'package:musily/core/presenter/widgets/empty_state.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/core/presenter/widgets/musily_loading.dart';
import 'package:musily/features/_library_module/data/dtos/create_playlist_dto.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/player/presenter/controllers/player/player_controller.dart';
import 'package:musily/features/track/presenter/widgets/track_tile_static.dart';

class QueueTools extends StatefulWidget {
  final PlayerController playerController;
  final LibraryController libraryController;
  final bool showAsPage;
  final VoidCallback? onBack;

  const QueueTools({
    super.key,
    required this.playerController,
    required this.libraryController,
    this.showAsPage = true,
    this.onBack,
  });

  @override
  State<QueueTools> createState() => _QueueToolsState();
}

class _QueueToolsState extends State<QueueTools> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _createPlaylistFromQueue() async {
    final data = widget.playerController.data;
    if (data.queue.isEmpty) {
      LySnackbar.show(context.localization.queueEmptyMessage);
      return;
    }

    if (!mounted) return;

    final result = await LyNavigator.showLyCardDialog<Map<String, dynamic>>(
      density: LyDensity.dense,
      context: context,
      width: context.display.isDesktop ? 500 : 330,
      builder: (dialogContext) => _CreatePlaylistFromQueueDialog(
        playerController: widget.playerController,
        tracks: data.queue,
      ),
    );

    if (result != null && mounted) {
      final playlistTitle = result['title'] as String;
      final selectedTrackIds = result['selectedTracks'] as Set<String>;
      final selectedTracksList = data.queue
          .where((track) => selectedTrackIds.contains(track.id))
          .toList();

      if (playlistTitle.isNotEmpty && selectedTracksList.isNotEmpty) {
        await widget.libraryController.methods.createPlaylist(
          CreatePlaylistDTO(
            title: playlistTitle,
            tracks: selectedTracksList,
          ),
        );

        if (mounted) {
          LySnackbar.show(context.localization.playlistCreated);
          Navigator.of(context).pop();
        }
      }
    }
  }

  Widget _buildContent(BuildContext context) {
    return widget.playerController.builder(
      builder: (context, data) {
        return Column(
          children: [
            if (data.currentPlayingItem != null) ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.themeData.colorScheme.outline
                          .withValues(alpha: .1),
                    ),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: data.loadingSmartQueue
                        ? null
                        : () {
                            widget.playerController.methods.toggleSmartQueue();
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: data.autoSmartQueue
                                  ? context.themeData.colorScheme.primary
                                      .withValues(alpha: 0.15)
                                  : context.themeData.colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TweenAnimationBuilder<Color?>(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              tween: ColorTween(
                                begin: data.autoSmartQueue
                                    ? context
                                        .themeData.colorScheme.onSurfaceVariant
                                    : context.themeData.colorScheme.primary,
                                end: data.autoSmartQueue
                                    ? context.themeData.colorScheme.primary
                                    : context
                                        .themeData.colorScheme.onSurfaceVariant,
                              ),
                              builder: (context, color, child) {
                                return Icon(
                                  CupertinoIcons.wand_stars,
                                  size: 20,
                                  color: color,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.localization.smartSuggestionsTitle,
                                  style: context.themeData.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  tween: Tween<double>(
                                    begin: data.autoSmartQueue ? 0.5 : 0.7,
                                    end: data.autoSmartQueue ? 0.7 : 0.5,
                                  ),
                                  builder: (context, opacity, child) {
                                    return Text(
                                      context.localization
                                          .smartSuggestionsDescription,
                                      style: context
                                          .themeData.textTheme.bodySmall
                                          ?.copyWith(
                                        color: context.themeData.colorScheme
                                            .onSurfaceVariant
                                            .withValues(alpha: opacity),
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: AnimatedScale(
                              key: const ValueKey('switch'),
                              scale: data.autoSmartQueue ? 1.0 : 0.95,
                              duration: const Duration(milliseconds: 200),
                              child: Switch(
                                value: data.autoSmartQueue,
                                onChanged: data.loadingSmartQueue
                                    ? null
                                    : (value) {
                                        widget.playerController.methods
                                            .toggleSmartQueue();
                                      },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            Expanded(
              child: widget.playerController.data.queue.length <= 1
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: EmptyState(
                          title: context.localization.queueEmptyTitle,
                          message: context.localization.queueEmptyMessage,
                          icon: const Icon(LucideIcons.music, size: 50),
                        ),
                      ),
                    )
                  : _ReorderableQueueList(
                      playerController: widget.playerController,
                      scrollController: _scrollController,
                    ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);

    if (widget.showAsPage) {
      return Scaffold(
        appBar: MusilyAppBar(
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(context.localization.queue),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.plus),
              onPressed: _createPlaylistFromQueue,
              tooltip: context.localization.createPlaylist,
            ),
          ],
        ),
        body: content,
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (widget.onBack != null)
                IconButton(
                  icon: const Icon(LucideIcons.chevronLeft, size: 20),
                  onPressed: widget.onBack,
                  tooltip: context.localization.back,
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.localization.queueTools,
                  style: context.themeData.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.plus, size: 20),
                onPressed: _createPlaylistFromQueue,
                tooltip: context.localization.createPlaylist,
              ),
            ],
          ),
        ),
        Expanded(child: content),
      ],
    );
  }
}

class _ReorderableQueueList extends StatelessWidget {
  final PlayerController playerController;
  final ScrollController scrollController;

  const _ReorderableQueueList({
    required this.playerController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return playerController.builder(
      builder: (context, data) {
        // Use the queue directly without any manipulations
        final queue = data.queue;

        return Scrollbar(
          thumbVisibility: true,
          controller: scrollController,
          radius: const Radius.circular(4),
          child: ReorderableListView.builder(
            scrollController: scrollController,
            itemCount: queue.length,
            onReorder: (oldIndex, newIndex) {
              playerController.methods.reorderQueue(
                newIndex,
                oldIndex,
              );
            },
            itemBuilder: (context, index) {
              final track = queue[index];
              final isSmartQueue =
                  data.tracksFromSmartQueue.contains(track.hash);
              final isCurrentPlaying = track.id == data.currentPlayingItem?.id;

              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: isSmartQueue ? 12 : 0,
                ),
                decoration: BoxDecoration(
                  color: isSmartQueue
                      ? context.themeData.colorScheme.primaryContainer
                          .withValues(alpha: 0.4)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSmartQueue
                        ? context.themeData.colorScheme.primary
                            .withValues(alpha: 0.3)
                        : Colors.transparent,
                    width: isCurrentPlaying || isSmartQueue ? 1.5 : 1,
                  ),
                ),
                key: Key('${track.id}_$index'),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await playerController.methods.queueJumpTo(track.id);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: TrackTileStatic(
                      leading: isCurrentPlaying
                          ? SizedBox(
                              width: 48,
                              height: 48,
                              child: MusilyWaveLoading(
                                size: 20,
                                color: context.themeData.colorScheme.primary,
                              ),
                            )
                          : null,
                      track: track,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSmartQueue) ...[
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: context.themeData.colorScheme.primary
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                LucideIcons.sparkles,
                                size: 16,
                                color: context.themeData.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (Platform.isAndroid)
                            Icon(
                              LucideIcons.gripVertical,
                              size: 20,
                              color: context.themeData.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CreatePlaylistFromQueueDialog extends StatefulWidget {
  final PlayerController playerController;
  final List<dynamic> tracks;

  const _CreatePlaylistFromQueueDialog({
    required this.playerController,
    required this.tracks,
  });

  @override
  State<_CreatePlaylistFromQueueDialog> createState() =>
      _CreatePlaylistFromQueueDialogState();
}

class _CreatePlaylistFromQueueDialogState
    extends State<_CreatePlaylistFromQueueDialog> {
  final TextEditingController _playlistNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Set<String> _selectedTracks;

  @override
  void initState() {
    super.initState();
    // Select all tracks by default
    _selectedTracks = widget.tracks.map((track) => track.id as String).toSet();
    _playlistNameController.text = '';
  }

  @override
  void dispose() {
    _playlistNameController.dispose();
    super.dispose();
  }

  void _toggleTrack(String trackId) {
    setState(() {
      if (_selectedTracks.contains(trackId)) {
        _selectedTracks.remove(trackId);
      } else {
        _selectedTracks.add(trackId);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedTracks =
          widget.tracks.map((track) => track.id as String).toSet();
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedTracks.clear();
    });
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate() && _selectedTracks.isNotEmpty) {
      Navigator.of(context).pop({
        'title': _playlistNameController.text,
        'selectedTracks': _selectedTracks,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.themeData.colorScheme.primary
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      LucideIcons.listPlus,
                      size: 20,
                      color: context.themeData.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.localization.createPlaylist,
                          style: context.themeData.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_selectedTracks.length} ${context.localization.tracksSelected}',
                          style:
                              context.themeData.textTheme.bodySmall?.copyWith(
                            color: context.themeData.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Playlist Name Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: LyTextField(
                autofocus: true,
                controller: _playlistNameController,
                labelText: context.localization.playlistName,
                hintText: context.localization.playlistName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.localization.requiredField;
                  }
                  return null;
                },
              ),
            ),

            // Toggle Select All / Deselect All button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: _selectedTracks.length == widget.tracks.length
                    ? _deselectAll
                    : _selectAll,
                child: Text(
                  _selectedTracks.length == widget.tracks.length
                      ? context.localization.deselectAll
                      : context.localization.selectAll,
                ),
              ),
            ),

            // Tracks List
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: context.themeData.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.themeData.colorScheme.outline
                        .withValues(alpha: 0.1),
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.tracks.length,
                  itemBuilder: (context, index) {
                    final track = widget.tracks[index];
                    final isSelected = _selectedTracks.contains(track.id);

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _toggleTrack(track.id),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: TrackTileStatic(
                            track: track,
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (value) => _toggleTrack(track.id),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Row(
                children: [
                  Expanded(
                    child: LyOutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(context.localization.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LyFilledButton(
                      onPressed: () => _submit(context),
                      child: Text(context.localization.create),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
