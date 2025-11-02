import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/empty_state.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/downloader/presenter/widgets/download_manager_widget.dart';

class DownloaderPage extends StatelessWidget {
  final CoreController coreController;
  final DownloaderController downloaderController;
  const DownloaderPage({
    super.key,
    required this.downloaderController,
    required this.coreController,
  });

  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'DownloaderPage',
      child: Scaffold(
        appBar: context.display.isDesktop
            ? null
            : MusilyAppBar(
                title: Text(
                  context.localization.downloadManager,
                ),
              ),
        body: downloaderController.builder(
          builder: (context, data) {
            return Column(
              children: [
                Expanded(
                  child: data.queue.isEmpty
                      ? Center(
                          child: EmptyState(
                            icon: Icon(
                              LucideIcons.download,
                              size: 64,
                              color: context.themeData.colorScheme.onSurface
                                  .withValues(alpha: 0.3),
                            ),
                            title: context.localization.noDownloads,
                            message: context.localization.downloadsEmptyMessage,
                          ),
                        )
                      : DownloadManagerWidget(
                          controller: downloaderController,
                          dense: true,
                          downloaderController: downloaderController,
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
