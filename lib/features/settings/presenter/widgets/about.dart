import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/icons/musily.svg',
          width: 60,
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          'by Felipe Yslaoker',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              child: FilledButton.tonal(
                onPressed: () {
                  Navigator.pop(context);
                  launchUrl(
                    Uri.parse('https://github.com/MusilyApp'),
                  );
                },
                child: const Icon(
                  SimpleIcons.github,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: FilledButton.tonal(
                onPressed: () {
                  Clipboard.setData(
                    const ClipboardData(
                      text: '4c7837e6-18b3-4892-87c4-d44d1759e611',
                    ),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(
                        seconds: 2,
                      ),
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      content: Text(
                        AppLocalizations.of(context)!.copiedToClipboard,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.pix,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
