import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_dropdown_button.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/features/settings/domain/enums/accent_color_preference.dart';
import 'package:musily/features/settings/domain/enums/close_preference.dart';
import 'package:musily/features/settings/presenter/controllers/settings/settings_controller.dart';

class AppSection extends StatefulWidget {
  final SettingsController controller;
  const AppSection({
    super.key,
    required this.controller,
  });

  @override
  State<AppSection> createState() => _AppSectionState();
}

class _AppSectionState extends State<AppSection> {
  @override
  void initState() {
    super.initState();
    widget.controller.data.context = context;
    widget.controller.updateData(
      widget.controller.data,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.builder(builder: (context, data) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: context.themeData.colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  LucideIcons.settings,
                  size: 18,
                  color: context.themeData.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  context.localization.application,
                  style: context.themeData.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          // Settings Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LyDropdownButton(
                  density: LyDensity.dense,
                  items: const [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'pt',
                      child: Text('Português'),
                    ),
                    DropdownMenuItem(
                      value: 'ru',
                      child: Text('Русский'),
                    ),
                    DropdownMenuItem(
                      value: 'es',
                      child: Text('Español'),
                    ),
                    DropdownMenuItem(
                      value: 'uk',
                      child: Text('Українська'),
                    ),
                  ],
                  value: data.locale?.languageCode,
                  onChanged: (value) {
                    widget.controller.methods.changeLanguage(value);
                  },
                  labelText: context.localization.language,
                ),
                const SizedBox(height: 12),
                LyDropdownButton<ThemeMode>(
                  labelText: context.localization.theme,
                  value: data.themeMode ?? ThemeMode.system,
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text(
                        context.localization.dark,
                      ),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text(
                        context.localization.light,
                      ),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text(
                        context.localization.system,
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    widget.controller.methods.changeTheme(value);
                  },
                ),
                const SizedBox(height: 12),
                LyDropdownButton<AccentColorPreference>(
                  labelText: context.localization.accentColor,
                  value: data.accentColorPreference,
                  onChanged: (value) {
                    widget.controller.methods.setAccentColorPreference(value!);
                  },
                  items: [
                    DropdownMenuItem(
                      value: AccentColorPreference.system,
                      child: Text(context.localization.system),
                    ),
                    DropdownMenuItem(
                      value: AccentColorPreference.defaultColor,
                      child: Text(context.localization.defaultColor),
                    ),
                  ],
                ),
                if (Platform.isWindows ||
                    Platform.isLinux ||
                    Platform.isMacOS) ...[
                  const SizedBox(height: 12),
                  LyDropdownButton<ClosePreference>(
                    labelText: context.localization.whenClosingTheApplication,
                    density: LyDensity.dense,
                    value: data.closePreference,
                    onChanged: (value) {
                      widget.controller.methods.setClosePreference(value!);
                    },
                    items: [
                      DropdownMenuItem(
                        value: ClosePreference.hide,
                        child: Text(context.localization.hide),
                      ),
                      DropdownMenuItem(
                        value: ClosePreference.close,
                        child: Text(context.localization.close),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      );
    });
  }
}
