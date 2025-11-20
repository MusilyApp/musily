import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/buttons/ly_outlined_button.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_image.dart';
import 'package:musily/core/presenter/widgets/infinity_marquee.dart';
import 'package:musily/core/presenter/widgets/section_header.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_data.dart';

enum DownloadFilter {
  all,
  downloading,
  queued,
  completed,
  failed,
}

class DownloadManagerWidget extends StatefulWidget {
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
  State<DownloadManagerWidget> createState() => _DownloadManagerWidgetState();
}

class _DownloadManagerWidgetState extends State<DownloadManagerWidget> {
  DownloadFilter _selectedFilter = DownloadFilter.all;

  @override
  Widget build(BuildContext context) {
    return widget.controller.builder(
      builder: (context, data) {
        final downloadingItems =
            data.queue.where((e) => e.status == e.downloadDownloading).toList();
        final queuedItems = data.queue
            .where((e) =>
                e.status == e.downloadQueued || e.status == e.downloadPaused)
            .toList();
        final completedItems =
            data.queue.where((e) => e.status == e.downloadCompleted).toList();
        final failedItems = data.queue
            .where((e) =>
                e.status == e.downloadFailed || e.status == e.downloadCanceled)
            .toList();

        final hasSections = downloadingItems.isNotEmpty ||
            queuedItems.isNotEmpty ||
            completedItems.isNotEmpty ||
            failedItems.isNotEmpty;

        if (!hasSections) {
          return const SizedBox.shrink();
        }

        // Apply filter
        final shouldShowDownloading = _selectedFilter == DownloadFilter.all ||
            _selectedFilter == DownloadFilter.downloading;
        final shouldShowQueued = _selectedFilter == DownloadFilter.all ||
            _selectedFilter == DownloadFilter.queued;
        final shouldShowCompleted = _selectedFilter == DownloadFilter.all ||
            _selectedFilter == DownloadFilter.completed;
        final shouldShowFailed = _selectedFilter == DownloadFilter.all ||
            _selectedFilter == DownloadFilter.failed;

        return ListView(
          children: [
            // Filter chips
            if (hasSections)
              SizedBox(
                height: 80,
                child: DownloadFilterChips(
                  data: data,
                  selectedFilter: _selectedFilter,
                  onFilterSelected: (filter) {
                    setState(() => _selectedFilter = filter);
                  },
                ),
              ),
            if (downloadingItems.isNotEmpty || queuedItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: DownloadSummaryBanner(
                  data: data,
                  controller: widget.controller,
                ),
              ),

            // Downloading Section
            if (downloadingItems.isNotEmpty && shouldShowDownloading) ...[
              SectionHeader(
                title: context.localization.downloadingSectionTitle,
                icon: LucideIcons.download,
                color: context.themeData.colorScheme.primary,
                subtitle:
                    context.localization.itemCount(downloadingItems.length),
              ),
              ...downloadingItems.map(
                (item) => DownloadItemTile(
                  item: item,
                  controller: widget.controller,
                ),
              ),
            ],

            if (queuedItems.isNotEmpty && shouldShowQueued) ...[
              SectionHeader(
                title: context.localization.queuedSectionTitle,
                icon: LucideIcons.clock,
                color: context.themeData.colorScheme.secondary,
                subtitle: context.localization.itemCount(queuedItems.length),
                trailing: IconButton(
                  onPressed: () async {
                    final confirmed = await LyNavigator.showLyCardDialog(
                      context: context,
                      width: 300,
                      padding: EdgeInsets.zero,
                      builder: (context) => _ClearQueueDialog(
                        downloaderController: widget.downloaderController,
                      ),
                    );

                    if (confirmed == true) {
                      await widget.downloaderController.methods
                          .clearQueuedDownloads();
                    }
                  },
                  icon: Icon(
                    LucideIcons.trash2,
                    size: 18,
                    color: context.themeData.colorScheme.error
                        .withValues(alpha: 0.7),
                  ),
                  tooltip: context.localization.clearQueueTitle,
                ),
              ),
              ...queuedItems.map(
                (item) => DownloadItemTile(
                  item: item,
                  controller: widget.controller,
                ),
              ),
            ],

            // Completed Section
            if (completedItems.isNotEmpty && shouldShowCompleted) ...[
              SectionHeader(
                title: context.localization.completedSectionTitle,
                icon: LucideIcons.check,
                color: context.themeData.colorScheme.tertiary,
                subtitle: context.localization.itemCount(completedItems.length),
                trailing: IconButton(
                  onPressed: () async {
                    final confirmed = await LyNavigator.showLyCardDialog(
                      context: context,
                      width: 300,
                      padding: EdgeInsets.zero,
                      builder: (context) => _ClearCompletedDownloadsDialog(
                        downloaderController: widget.downloaderController,
                      ),
                    );

                    if (confirmed == true) {
                      await widget.downloaderController.methods
                          .clearCompletedDownloads();
                    }
                  },
                  icon: Icon(
                    LucideIcons.trash2,
                    size: 18,
                    color: context.themeData.colorScheme.error
                        .withValues(alpha: 0.7),
                  ),
                  tooltip: context.localization.downloadManagerClearCompleted,
                ),
              ),
              ...completedItems.map(
                (item) => DownloadItemTile(
                  item: item,
                  controller: widget.controller,
                ),
              ),
            ],

            // Failed Section
            if (failedItems.isNotEmpty && shouldShowFailed) ...[
              SectionHeader(
                title: context.localization.failedSectionTitle,
                icon: LucideIcons.x,
                color: context.themeData.colorScheme.error,
                subtitle: context.localization.itemCount(failedItems.length),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (widget
                                .downloaderController.methods.retryAllFailed !=
                            null) {
                          await widget
                              .downloaderController.methods.retryAllFailed!();
                        }
                      },
                      icon: Icon(
                        LucideIcons.refreshCcw,
                        size: 18,
                        color: context.themeData.colorScheme.secondary
                            .withValues(alpha: 0.7),
                      ),
                      tooltip: context.localization.downloadManagerRetryAll,
                    ),
                    IconButton(
                      onPressed: () async {
                        for (final item in failedItems) {
                          await widget.downloaderController.methods
                              .deleteDownloadedFile(
                            track: item.track,
                          );
                        }
                      },
                      icon: Icon(
                        LucideIcons.trash2,
                        size: 18,
                        color: context.themeData.colorScheme.error
                            .withValues(alpha: 0.7),
                      ),
                      tooltip: context.localization.downloadManagerClearFailed,
                    ),
                  ],
                ),
              ),
              ...failedItems.map(
                (item) => DownloadItemTile(
                  item: item,
                  controller: widget.controller,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class DownloadFilterChips extends StatelessWidget {
  final DownloaderData data;
  final DownloadFilter selectedFilter;
  final ValueChanged<DownloadFilter> onFilterSelected;

  const DownloadFilterChips({
    super.key,
    required this.data,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final downloadingCount =
        data.queue.where((e) => e.status == DownloadStatus.downloading).length;
    final queuedCount = data.queue
        .where((e) =>
            e.status == DownloadStatus.queued ||
            e.status == DownloadStatus.paused)
        .length;
    final completedCount =
        data.queue.where((e) => e.status == DownloadStatus.completed).length;
    final failedCount = data.queue
        .where((e) =>
            e.status == DownloadStatus.failed ||
            e.status == DownloadStatus.canceled)
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      scrollDirection: Axis.horizontal,
      children: [
        DownloadFilterChip(
          label: context.localization.all,
          count: data.queue.length,
          isSelected: selectedFilter == DownloadFilter.all,
          icon: LucideIcons.list,
          onTap: () => onFilterSelected(DownloadFilter.all),
        ),
        if (downloadingCount > 0) ...[
          const SizedBox(width: 8),
          DownloadFilterChip(
            label: context.localization.downloadingSectionTitle,
            count: downloadingCount,
            isSelected: selectedFilter == DownloadFilter.downloading,
            icon: LucideIcons.download,
            color: context.themeData.colorScheme.primary,
            onTap: () => onFilterSelected(DownloadFilter.downloading),
          ),
        ],
        if (queuedCount > 0) ...[
          const SizedBox(width: 8),
          DownloadFilterChip(
            label: context.localization.queuedSectionTitle,
            count: queuedCount,
            isSelected: selectedFilter == DownloadFilter.queued,
            icon: LucideIcons.clock,
            color: context.themeData.colorScheme.secondary,
            onTap: () => onFilterSelected(DownloadFilter.queued),
          ),
        ],
        if (completedCount > 0) ...[
          const SizedBox(width: 8),
          DownloadFilterChip(
            label: context.localization.completedSectionTitle,
            count: completedCount,
            isSelected: selectedFilter == DownloadFilter.completed,
            icon: LucideIcons.check,
            color: context.themeData.colorScheme.tertiary,
            onTap: () => onFilterSelected(DownloadFilter.completed),
          ),
        ],
        if (failedCount > 0) ...[
          const SizedBox(width: 8),
          DownloadFilterChip(
            label: context.localization.failedSectionTitle,
            count: failedCount,
            isSelected: selectedFilter == DownloadFilter.failed,
            icon: LucideIcons.x,
            color: context.themeData.colorScheme.error,
            onTap: () => onFilterSelected(DownloadFilter.failed),
          ),
        ],
      ],
    );
  }
}

class DownloadSummaryBanner extends StatelessWidget {
  final DownloaderData data;
  final DownloaderController controller;

  const DownloadSummaryBanner({
    super.key,
    required this.data,
    required this.controller,
  });
  Duration? _calculateTotalEta() {
    Duration total = Duration.zero;
    var hasEta = false;
    for (final item in data.queue) {
      if (item.status == DownloadStatus.downloading) {
        final eta = item.estimatedTimeRemaining;
        if (eta != null) {
          total += eta;
          hasEta = true;
        }
      }
    }
    return hasEta ? total : null;
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    }
    return '${duration.inSeconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeData;
    final colorScheme = theme.colorScheme;
    final totalEta = controller.estimateTotalEta(data) ?? _calculateTotalEta();
    final etaLabel = totalEta != null ? _formatDuration(totalEta) : '--:--';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.12),
            colorScheme.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 420;
              final headerContent = [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    LucideIcons.activity,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.localization.downloadingSectionTitle,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        data.formattedGlobalSpeed,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isCompact) ...[
                  const SizedBox(width: 12),
                  _SummaryChip(
                    label: context.localization.downloadCompletedFailedSummary(
                      data.totalCompletedCount,
                      data.totalFailedCount,
                    ),
                    color: colorScheme.primary,
                    icon: LucideIcons.cloudDownload,
                    useMarquee: true,
                  ),
                ],
              ];

              if (!isCompact) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: headerContent,
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: headerContent.take(3).toList(),
                  ),
                  const SizedBox(height: 12),
                  _SummaryChip(
                    label: context.localization.downloadCompletedFailedSummary(
                      data.totalCompletedCount,
                      data.totalFailedCount,
                    ),
                    color: colorScheme.primary,
                    icon: LucideIcons.cloudDownload,
                    useMarquee: true,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  title: context.localization.downloadingSectionTitle,
                  value: data.totalDownloadingCount.toString(),
                  icon: LucideIcons.download,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryTile(
                  title: context.localization.downloadTotalEta,
                  value: etaLabel,
                  icon: LucideIcons.timer,
                  color: colorScheme.secondary,
                  useMarquee: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool useMarquee;

  const _SummaryTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.useMarquee = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeData;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: 0.07),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfinityMarquee(
                  child: Text(
                    title,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
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

class _SummaryChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final bool useMarquee;

  const _SummaryChip({
    required this.label,
    required this.color,
    this.icon = LucideIcons.gauge,
    this.useMarquee = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeData;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.withValues(alpha: 0.12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          if (useMarquee)
            SizedBox(
              width: 150,
              child: InfinityMarquee(
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class DownloadFilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const DownloadFilterChip({
    super.key,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? context.themeData.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? chipColor
                : context.themeData.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? chipColor
                  : context.themeData.colorScheme.outline
                      .withValues(alpha: 0.2),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: chipColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? context.themeData.colorScheme.onPrimary
                    : context.themeData.colorScheme.onSurface
                        .withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: context.themeData.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  letterSpacing: -0.2,
                  color: isSelected
                      ? context.themeData.colorScheme.onPrimary
                      : context.themeData.colorScheme.onSurface
                          .withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.themeData.colorScheme.onPrimary
                          .withValues(alpha: 0.25)
                      : context.themeData.colorScheme.onSurface
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: context.themeData.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: isSelected
                        ? context.themeData.colorScheme.onPrimary
                        : context.themeData.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DownloadItemTile extends StatelessWidget {
  final DownloadingItem item;
  final DownloaderController controller;

  const DownloadItemTile({
    super.key,
    required this.item,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDownloading = item.status == DownloadStatus.downloading;
    final isFailed = item.status == DownloadStatus.failed;

    return LyListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child:
              item.track.lowResImg != null && item.track.lowResImg!.isNotEmpty
                  ? AppImage(
                      item.track.lowResImg!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.themeData.colorScheme.primary
                                .withValues(alpha: 0.6),
                            context.themeData.colorScheme.primary
                                .withValues(alpha: 0.3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        LucideIcons.music,
                        color: context.themeData.colorScheme.onPrimary
                            .withValues(alpha: 0.7),
                        size: 22,
                      ),
                    ),
        ),
      ),
      title: InfinityMarquee(
        child: Text(
          item.track.title,
          style: context.themeData.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.micVocal,
                size: 12,
                color: context.themeData.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: InfinityMarquee(
                  child: Text(
                    item.track.artist.name,
                    style: context.themeData.textTheme.bodySmall?.copyWith(
                      color: context.themeData.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isDownloading) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  LucideIcons.gauge,
                  size: 11,
                  color: context.themeData.colorScheme.primary
                      .withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  item.formattedSpeed,
                  style: context.themeData.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: context.themeData.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  LucideIcons.hardDrive,
                  size: 11,
                  color: context.themeData.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  '${item.formattedDownloaded} / ${item.formattedSize}',
                  style: context.themeData.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: context.themeData.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  LucideIcons.clock,
                  size: 11,
                  color: context.themeData.colorScheme.secondary
                      .withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  item.formattedTimeRemaining,
                  style: context.themeData.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: context.themeData.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: item.totalBytes > 0
                    ? (item.downloadedBytes / item.totalBytes).clamp(0.0, 1.0)
                    : (item.progress > 0 ? item.progress : null),
                backgroundColor: context
                    .themeData.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.themeData.colorScheme.primary,
                ),
                minHeight: 3,
              ),
            ),
          ],
          if (isFailed && item.errorMessage != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  LucideIcons.triangleAlert,
                  size: 11,
                  color: context.themeData.colorScheme.error,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.errorMessage!,
                    style: context.themeData.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: context.themeData.colorScheme.error,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      trailing: controller.methods.trailing(context, item),
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
        maxHeight: MediaQuery.of(context).size.height * 0.7,
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

class _ClearCompletedDownloadsDialog extends StatelessWidget {
  final DownloaderController downloaderController;

  const _ClearCompletedDownloadsDialog({
    required this.downloaderController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: 280,
      ),
      decoration: BoxDecoration(
        color: context.themeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                Expanded(
                  child: Text(
                    context.localization.clearCompletedDownloadsTitle,
                    style: context.themeData.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                          LucideIcons.trash2,
                          size: 48,
                          color: context.themeData.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.localization.clearCompletedDownloadsMessage,
                          textAlign: TextAlign.center,
                          style:
                              context.themeData.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context
                              .localization.clearCompletedDownloadsDescription,
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
