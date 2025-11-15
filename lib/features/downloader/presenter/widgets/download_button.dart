import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/string.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_data.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DownloadButton extends StatefulWidget {
  final DownloaderController controller;
  final TrackEntity track;
  final Color? color;

  const DownloadButton({
    super.key,
    required this.controller,
    required this.track,
    this.color,
  });

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  DownloadingItem? _cachedItem;
  DownloadStatus? _cachedStatus;
  double _cachedProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _updateCache();
  }

  void _updateCache() {
    final item = widget.controller.methods.getItem(widget.track);
    _cachedItem = item;
    _cachedStatus = item?.status;
    _cachedProgress = item?.progress ?? 0.0;
  }

  bool _shouldRebuild(DownloadingItem? newItem) {
    if (newItem == null && _cachedItem == null) return false;
    if (newItem == null || _cachedItem == null) return true;

    final statusChanged = newItem.status != _cachedStatus;
    final progressChanged = (newItem.progress - _cachedProgress).abs() > 0.01;

    return statusChanged || progressChanged;
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.builder(
      builder: (context, data) {
        final item = widget.controller.methods.getItem(widget.track);

        if (!_shouldRebuild(item)) {
          return _buildButton(context, _cachedItem);
        }

        _updateCache();
        return _buildButton(context, item);
      },
    );
  }

  Widget _buildButton(BuildContext context, DownloadingItem? item) {
    final iconSize = context.display.isDesktop ? 20.0 : null;

    if (item != null) {
      switch (item.status) {
        case DownloadStatus.queued:
          return Tooltip(
            message: 'Queued',
            child: IconButton(
              onPressed: () {},
              iconSize: iconSize,
              icon: Icon(
                LucideIcons.hourglass,
                size: iconSize ?? 20,
                color: widget.color ?? context.themeData.colorScheme.primary,
              ),
            ),
          );

        case DownloadStatus.downloading:
          final percent = item.totalBytes > 0
              ? (item.downloadedBytes / item.totalBytes).clamp(0.0, 1.0)
              : item.progress;
          return Tooltip(
            message:
                '${(percent * 100).toStringAsFixed(0)}% • ${item.formattedSpeed}',
            child: IconButton(
              onPressed: () {},
              icon: SizedBox(
                height: iconSize,
                width: iconSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularPercentIndicator(
                      lineWidth: 4,
                      startAngle: 180,
                      progressColor:
                          widget.color ?? context.themeData.colorScheme.primary,
                      backgroundColor:
                          context.themeData.colorScheme.inversePrimary,
                      percent: percent.clamp(0.0, 1.0),
                      radius: 10,
                      animation: false,
                    ),
                    if (item.downloadSpeed > 0)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: widget.color ??
                              context.themeData.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );

        case DownloadStatus.completed:
          if ((item.track.url ?? '').isDirectory) {
            return Tooltip(
              message: 'Downloaded • ${item.formattedSize}',
              child: IconButton(
                onPressed: () {},
                iconSize: iconSize,
                icon: Icon(
                  LucideIcons.circleCheckBig,
                  size: iconSize ?? 20,
                  color: widget.color ?? context.themeData.colorScheme.primary,
                ),
              ),
            );
          }
          break;

        case DownloadStatus.failed:
          return Tooltip(
            message: 'Failed: ${item.errorMessage ?? "Unknown error"}',
            child: IconButton(
              onPressed: () {
                if (widget.controller.methods.retryDownload != null) {
                  widget.controller.methods.retryDownload!(widget.track);
                }
              },
              iconSize: iconSize,
              icon: Icon(
                LucideIcons.refreshCcw,
                size: iconSize ?? 20,
                color: context.themeData.colorScheme.error,
              ),
            ),
          );

        default:
          break;
      }
    }

    return Tooltip(
      message: 'Download',
      child: IconButton(
        onPressed: () {
          widget.controller.methods.addDownload(widget.track);
        },
        iconSize: iconSize,
        icon: Icon(
          LucideIcons.download,
          size: iconSize ?? 20,
          color: widget.color ?? context.themeData.colorScheme.primary,
        ),
      ),
    );
  }
}

class DownloadButtonBuilder extends StatelessWidget {
  final DownloaderController controller;
  final TrackEntity track;
  final Function(
    BuildContext context,
    DownloadingItem? item,
  ) builder;
  const DownloadButtonBuilder({
    required this.controller,
    required this.track,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return controller.builder(
      builder: (context, data) => builder(
        context,
        controller.methods.getItem(track),
      ),
    );
  }
}
