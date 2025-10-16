import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/extensions/string.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_data.dart';
import 'package:musily/features/track/domain/entities/track_entity.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DownloadButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return controller.builder(
      builder: (context, data) {
        final item = controller.methods.getItem(track);
        final iconSize = context.display.isDesktop ? 20.0 : null;
        if (item != null) {
          if (item.status == DownloadStatus.queued) {
            return IconButton(
              onPressed: () {},
              iconSize: iconSize,
              icon: Icon(
                LucideIcons.hourglass,
                size: iconSize ?? 20,
                color: color ?? context.themeData.colorScheme.primary,
              ),
            );
          }
          if (item.status == DownloadStatus.downloading) {
            return IconButton(
              onPressed: () {},
              icon: SizedBox(
                height: iconSize,
                width: iconSize,
                child: CircularPercentIndicator(
                  lineWidth: 4,
                  startAngle: 180,
                  progressColor: color ?? context.themeData.colorScheme.primary,
                  backgroundColor: context.themeData.colorScheme.inversePrimary,
                  percent: item.progress,
                  radius: 10,
                ),
              ),
            );
          }
          if (item.status == DownloadStatus.completed &&
              (item.track.url ?? '').isDirectory) {
            return IconButton(
              onPressed: () {},
              iconSize: iconSize,
              icon: Icon(
                LucideIcons.circleCheckBig,
                size: iconSize ?? 20,
                color: color ?? context.themeData.colorScheme.primary,
              ),
            );
          }
        }
        return IconButton(
          onPressed: () {
            controller.methods.addDownload(
              track,
            );
          },
          iconSize: iconSize,
          icon: Icon(
            LucideIcons.download,
            size: iconSize ?? 20,
            color: color ?? context.themeData.colorScheme.primary,
          ),
        );
      },
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
