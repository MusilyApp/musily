import 'package:flutter/material.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';
import 'package:musily/features/auth/presenter/controllers/auth_controller/auth_controller.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';
import 'package:musily/features/settings/presenter/widgets/app_section.dart';
import 'package:musily/features/settings/presenter/widgets/other_section.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/settings/presenter/widgets/sync_section.dart';

class SettingsPage extends StatelessWidget {
  final CoreController coreController;
  final SettingsController settingsController;
  final AuthController authController;
  const SettingsPage({
    super.key,
    required this.coreController,
    required this.settingsController,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    return LyPage(
      contextKey: 'SettingsPage',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.localization.settings,
          ),
        ),
        body: ListView(
          children: [
            if (settingsController.showSyncSection)
              SyncSection(
                coreController: coreController,
                authController: authController,
              ),
            AppSection(
              controller: settingsController,
            ),
            const Divider(),
            const OtherSection(),
          ],
        ),
      ),
    );
  }
}
