import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        ListTile(
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
        ListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                title: Text('Musily'),
                content: About(),
              ),
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
