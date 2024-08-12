import 'package:flutter/material.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/utils/display_helper.dart';
import 'package:musily_player/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily_player/presenter/widgets/download_manager_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return coreController.builder(
      eventListener: (context, event, data) {
        if (event.id == 'pushWidget') {
          if (data.pages.length > 1) {
            if (DisplayHelper(context).isDesktop) {
              Navigator.pop(context);
            }
          }
          Navigator.of(context).push(
            DownupRouter(
              builder: (context) => event.data,
            ),
          );
          if (DisplayHelper(context).isDesktop) {
            coreController.updateData(
              data.copyWith(
                pages: [event.data],
              ),
            );
          }
        }
      },
      builder: (context, data) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.downloadManager,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: DownloadManagerWidget(
                  backgroundItemColor: Colors.transparent,
                  controller: downloaderController,
                  borderLess: true,
                  dense: true,
                ),
              ),
              if (downloaderController.playerController != null)
                downloaderController.playerController!.builder(
                  builder: (context, data) {
                    if (data.currentPlayingItem != null &&
                        !DisplayHelper(context).isDesktop) {
                      return const SizedBox(
                        height: 75,
                      );
                    }
                    return Container();
                  },
                )
            ],
          ),
        );
      },
    );
  }
}
