import 'package:flutter/material.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/core_base_widget.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';
import 'package:musily/features/settings/presenter/widgets/app_section.dart';
import 'package:musily/features/settings/presenter/widgets/other_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  final CoreController coreController;
  final SettingsController settingsController;
  const SettingsPage({
    super.key,
    required this.coreController,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    return CoreBaseWidget(
      coreController: coreController,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.settings,
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: AppSection(
                controller: settingsController,
              ),
            ),
            const Divider(),
            const OtherSection(),
          ],
        ),
      ),
    );
  }
}
