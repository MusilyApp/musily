import 'package:flutter/material.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/presenter/widgets/player_sized_box.dart';
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
                child: downloaderController.builder(builder: (context, data) {
                  if (data.queue.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.downloading_rounded,
                            color: Theme.of(context)
                                .iconTheme
                                .color
                                ?.withOpacity(.5),
                            size: 50,
                          ),
                          Text(
                            AppLocalizations.of(context)!.noDownloads,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .iconTheme
                                  .color
                                  ?.withOpacity(.5),
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
                }),
              ),
              if (downloaderController.playerController != null)
                PlayerSizedBox(
                  playerController: downloaderController.playerController!,
                ),
            ],
          ),
        );
      },
    );
  }
}
