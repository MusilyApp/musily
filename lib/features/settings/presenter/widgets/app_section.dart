import 'package:flutter/material.dart';
import 'package:musily/core/presenter/widgets/app_input_base.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Text(
              AppLocalizations.of(context)!.application,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          AppInputBase(
            labelText: AppLocalizations.of(context)!.language,
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                // hintText: '',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
              ),
              value: data.locale?.languageCode,
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
              onChanged: (value) {
                widget.controller.methods.changeLanguage(value);
              },
            ),
          ),
          AppInputBase(
            labelText: AppLocalizations.of(context)!.theme,
            child: DropdownButtonFormField<ThemeMode>(
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
              ),
              value: data.themeMode ?? ThemeMode.system,
              items: [
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(
                    AppLocalizations.of(context)!.dark,
                  ),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(
                    AppLocalizations.of(context)!.light,
                  ),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(
                    AppLocalizations.of(context)!.system,
                  ),
                ),
              ],
              onChanged: (value) {
                widget.controller.methods.changeTheme(value);
              },
            ),
          ),
        ],
      );
    });
  }
}
