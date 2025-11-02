import 'package:flutter/material.dart';
import 'package:musily/core/data/services/updater_service.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdaterDialog extends StatelessWidget {
  const UpdaterDialog({super.key});

  static void show(BuildContext context) {
    LyNavigator.showLyCardDialog(
      width: context.display.isDesktop ? 400 : context.size!.width * 0.8,
      context: context,
      title: Text(
        context.localization.newUpdateAvailable,
      ),
      builder: (context) {
        return const UpdaterDialog();
      },
      actions: (context) => [
        LyFilledButton(
          onPressed: () {
            LyNavigator.pop(context);
          },
          child: Text(
            context.localization.close,
          ),
        ),
        LyFilledButton(
          child: Text(context.localization.download),
          onPressed: () {
            launchUrl(
              Uri.parse(UpdaterService.instance.downloadUrl!),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (UpdaterService.instance.latestVersion != null) ...[
              Text(
                UpdaterService.instance.latestVersion!,
                style: context.themeData.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
            ],
            // GptMarkdown(
            //   UpdaterService.instance.releaseNotes,
            // ),
          ],
        ),
      ),
    );
  }
}
