import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/show_ly_dialog.dart';
import 'package:musily/features/settings/presenter/widgets/about.dart';

class OtherSection extends StatelessWidget {
  const OtherSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Text(
            AppLocalizations.of(context)!.others,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        LyListTile(
          leading: const Icon(
            Icons.description_rounded,
          ),
          onTap: () {
            showLicensePage(
              applicationName: 'Musily',
              useRootNavigator: true,
              applicationIcon: SvgPicture.asset(
                'assets/icons/musily.svg',
                width: 60,
              ),
              context: context,
            );
          },
          title: Text(AppLocalizations.of(context)!.licenses),
        ),
        LyListTile(
          onTap: () {
            showLyDialog(
              context: context,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              title: const Text('Musily'),
              content: const About(),
            );
          },
          leading: const Icon(
            Icons.info_rounded,
          ),
          title: Text(AppLocalizations.of(context)!.about),
        ),
      ],
    );
  }
}
