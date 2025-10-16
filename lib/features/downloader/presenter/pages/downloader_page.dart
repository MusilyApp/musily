import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/core/presenter/widgets/musily_app_bar.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
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
        appBar: MusilyAppBar(
          title: Text(
            context.localization.downloadManager,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: downloaderController.builder(
                builder: (context, data) {
                  if (data.queue.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.download,
                            color: context.themeData.iconTheme.color
                                ?.withValues(alpha: .5),
                            size: 50,
                          ),
                          Text(
                            context.localization.noDownloads,
                            style: TextStyle(
                              color: context.themeData.iconTheme.color
                                  ?.withValues(alpha: .5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return DownloadManagerWidget(
                    backgroundItemColor: Colors.transparent,
                    controller: downloaderController,
                    borderLess: true,
                    dense: true,
                  );
                },
              ),
            ),
            if (downloaderController.playerController != null)
              PlayerSizedBox(
                playerController: downloaderController.playerController!,
              ),
          ],
        ),
      ),
    );
  }
}
