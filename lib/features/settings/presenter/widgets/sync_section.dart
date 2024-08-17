import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:musily/core/utils/get_theme_mode.dart';
import 'package:musily_repository/musily_repository.dart';

class SyncSection extends StatelessWidget {
  final musilyRepository = MusilyRepository();
  SyncSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = getThemeMode(context) == ThemeMode.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Text(
            AppLocalizations.of(context)!.accounts,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ListTile(
          leading: SvgPicture.asset(
            'assets/logos/google_drive.svg',
            width: 25,
          ),
          title: const Text('Google Drive'),
        ),
        ListTile(
          leading: SvgPicture.asset(
            'assets/logos/spotify_${isDarkMode ? 'white' : 'black'}.svg',
            width: 25,
          ),
          title: const Text('Spotify'),
          trailing: FilledButton(
            onPressed: () async {
              await musilyRepository.login(
                source: Source.spotify,
              );
              await musilyRepository.setDefaultSource(
                Source.spotify,
              );
            },
            child: const Text('login'),
          ),
        ),
      ],
    );
  }
}
