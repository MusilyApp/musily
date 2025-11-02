import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/track/presenter/widgets/track_tile_static.dart';

class DownloadManagerWidget extends StatelessWidget {
  final DownloaderController controller;
  final bool borderLess;
  final bool dense;
  final Color? backgroundItemColor;
  final DownloaderController downloaderController;

  const DownloadManagerWidget({
    super.key,
    required this.controller,
    this.borderLess = false,
    this.dense = true,
    this.backgroundItemColor,
    required this.downloaderController,
  });

  @override
  Widget build(BuildContext context) {
    return controller.builder(
      builder: (context, data) {
        final downloadingItems = data.queue
            .where(
              (e) => e.status == e.downloadDownloading,
            )
            .toList();
        final queuedItems = data.queue
            .where(
              (e) =>
                  e.status == e.downloadQueued || e.status == e.downloadPaused,
            )
            .toList();
        final completedItems = data.queue
            .where(
              (e) => e.status == e.downloadCompleted,
            )
            .toList();
        final failedItems = data.queue
            .where(
              (e) =>
                  e.status == e.downloadFailed ||
                  e.status == e.downloadCanceled,
            )
            .toList();

        final hasSections = downloadingItems.isNotEmpty ||
            queuedItems.isNotEmpty ||
            completedItems.isNotEmpty ||
            failedItems.isNotEmpty;

        if (!hasSections) {
          return const SizedBox.shrink();
        }

        return ListView(
          children: [
            if (downloadingItems.isNotEmpty) ...[
              _buildSectionHeader(
                context,
                title: context.localization.downloadingSectionTitle,
                icon: LucideIcons.download,
                color: context.themeData.colorScheme.primary,
              ),
              ...downloadingItems.map((item) => _buildDownloadItem(
                    context,
                    item,
                    controller,
                  )),
            ],
            if (queuedItems.isNotEmpty) ...[
              _buildSectionHeader(
                context,
                title: context.localization.queuedSectionTitle,
                icon: LucideIcons.clock,
                color: context.themeData.colorScheme.secondary,
                action: IconButton(
                  onPressed: () async {
                    final confirmed = await LyNavigator.showLyCardDialog(
                      context: context,
                      width: 300,
                      padding: EdgeInsets.zero,
                      builder: (context) => _ClearQueueDialog(
                        downloaderController: downloaderController,
                      ),
                    );

                    if (confirmed == true) {
                      await downloaderController.methods.clearQueuedDownloads();
                    }
                  },
                  icon: Icon(
                    LucideIcons.trash2,
                    size: 18,
                    color: context.themeData.colorScheme.error,
                  ),
                  tooltip: 'Clear queue',
                ),
              ),
              ...queuedItems.map((item) => _buildDownloadItem(
                    context,
                    item,
                    controller,
                  )),
            ],
            if (completedItems.isNotEmpty) ...[
              _buildSectionHeader(
                context,
                title: context.localization.completedSectionTitle,
                icon: LucideIcons.check,
                color: context.themeData.colorScheme.tertiary,
              ),
              ...completedItems.map((item) => _buildDownloadItem(
                    context,
                    item,
                    controller,
                  )),
            ],
            if (failedItems.isNotEmpty) ...[
              _buildSectionHeader(
                context,
                title: context.localization.failedSectionTitle,
                icon: LucideIcons.x,
                color: context.themeData.colorScheme.error,
              ),
              ...failedItems.map((item) => _buildDownloadItem(
                    context,
                    item,
                    controller,
                  )),
            ],
            if (downloaderController.playerController != null)
              PlayerSizedBox(
                playerController: downloaderController.playerController!,
              ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    Widget? action,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            icon,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: context.themeData.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
          if (action != null) action,
        ],
      ),
    );
  }

  Widget _buildDownloadItem(
    BuildContext context,
    dynamic item,
    DownloaderController controller,
  ) {
    final isDownloading = item.status == DownloadStatus.downloading;
    final isPaused = item.status == DownloadStatus.paused;
    final isCompleted = item.status == DownloadStatus.completed;
    final isFailed = item.status == DownloadStatus.failed;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundItemColor ??
            context.themeData.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.themeData.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TrackTileStatic(
                    track: item.track,
                    trailing: controller.methods.trailing(
                      context,
                      item,
                    ),
                  ),
                ),
                if (isDownloading)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: context.themeData.colorScheme.primary
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      LucideIcons.download,
                      size: 14,
                      color: context.themeData.colorScheme.primary,
                    ),
                  )
                else if (isPaused)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: context.themeData.colorScheme.secondary
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      LucideIcons.pause,
                      size: 14,
                      color: context.themeData.colorScheme.secondary,
                    ),
                  )
                else if (isCompleted)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: context.themeData.colorScheme.tertiary
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      LucideIcons.check,
                      size: 14,
                      color: context.themeData.colorScheme.tertiary,
                    ),
                  )
                else if (isFailed)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: context.themeData.colorScheme.error
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      LucideIcons.x,
                      size: 14,
                      color: context.themeData.colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
          if (isDownloading || isPaused)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: LinearProgressIndicator(
                value: item.progress,
                backgroundColor: context.themeData.colorScheme.surface
                    .withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isPaused
                      ? context.themeData.colorScheme.secondary
                      : context.themeData.colorScheme.primary,
                ),
                minHeight: 3,
              ),
            ),
        ],
      ),
    );
  }
}

class _ClearQueueDialog extends StatelessWidget {
  final DownloaderController downloaderController;

  const _ClearQueueDialog({
    required this.downloaderController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
        minHeight: 280,
      ),
      decoration: BoxDecoration(
        color: context.themeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color:
                  context.themeData.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.themeData.colorScheme.error
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    LucideIcons.trash2,
                    size: 20,
                    color: context.themeData.colorScheme.error,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  context.localization.clearQueueTitle,
                  style: context.themeData.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context
                          .themeData.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: context.themeData.colorScheme.outline
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.triangleAlert,
                          size: 48,
                          color: context.themeData.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.localization.clearQueueMessage,
                          textAlign: TextAlign.center,
                          style:
                              context.themeData.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.localization.clearQueueDescription,
                          textAlign: TextAlign.center,
                          style:
                              context.themeData.textTheme.bodySmall?.copyWith(
                            color: context.themeData.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: LyOutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(context.localization.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LyFilledButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    color: context.themeData.colorScheme.error,
                    child: Text(
                      context.localization.clear,
                      style: TextStyle(
                          color: context.themeData.colorScheme.onError),
                    ),
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
