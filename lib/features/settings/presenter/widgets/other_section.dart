import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
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
            context.localization.others,
            style: context.themeData.textTheme.titleSmall,
          ),
        ),
        LyListTile(
          leading: const Icon(
            LucideIcons.scale,
            size: 20,
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
          title: Text(context.localization.licenses),
        ),
        LyListTile(
          onTap: () {
            LyNavigator.showLyCardDialog(
              context: context,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              title: const Text('Musily'),
              builder: (context) => const About(),
            );
          },
          leading: const Icon(
            LucideIcons.info,
            size: 20,
          ),
          title: Text(context.localization.about),
        ),
      ],
    );
  }
}
