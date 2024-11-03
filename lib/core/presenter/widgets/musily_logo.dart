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
    return context.settingsBuilder(
      builder: (context, data) => SvgPicture.asset(
        'assets/icons/musily_appbar_icon${context.isDarkMode ? '_dark' : ''}.svg',
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}
