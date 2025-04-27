import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class MusilyLogo extends StatefulWidget {
  final double? width;
  final double? height;
  const MusilyLogo({
    super.key,
    this.width,
    this.height,
  });

  @override
  State<MusilyLogo> createState() => _MusilyLogoState();
}

class _MusilyLogoState extends State<MusilyLogo> {
  @override
  Widget build(BuildContext context) {
    return context.settingsBuilder(builder: (context, data) {
      late final Color defaultColor;
      if (context.isDarkMode) {
        defaultColor = const Color(0xFFe8def7);
      } else {
        defaultColor = const Color(0xFF68548f);
      }
      return SvgPicture.asset(
        'assets/icons/musily_appbar_icon.svg',
        colorFilter: ColorFilter.mode(
            context.themeData.buttonTheme.colorScheme?.primary ?? defaultColor,
            BlendMode.srcATop),
        width: widget.width,
        height: widget.height,
      );
    });
  }
}

class MusilyTitle extends StatelessWidget {
  const MusilyTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return context.settingsBuilder(builder: (context, data) {
      late final Color defaultColor;
      if (context.isDarkMode) {
        defaultColor = const Color(0xFFe8def7);
      } else {
        defaultColor = const Color(0xFF68548f);
      }
      return Text(
        'Musily',
        style: context.themeData.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w400,
          color: context.themeData.buttonTheme.colorScheme?.primary ??
              defaultColor,
        ),
      );
    });
  }
}
