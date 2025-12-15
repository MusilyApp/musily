import 'package:flutter/material.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/features/wrapped/presenter/pages/wrapped_main_page.dart';

class WrappedBanner extends StatelessWidget {
  final int? year;
  final CoreController coreController;

  const WrappedBanner({
    super.key,
    this.year,
    required this.coreController,
  });

  @override
  Widget build(BuildContext context) {
    final displayYear = year ?? DateTime.now().year;
    final colorScheme = context.themeData.colorScheme;
    final backgroundColor = colorScheme.surfaceContainerHighest;
    final textColor = colorScheme.onSurface;

    return Container(
      width: double.infinity,
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _navigateToWrapped(context),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: backgroundColor),
                CustomPaint(
                  painter: _PlusPatternPainter(
                    color: textColor.withValues(alpha: 0.06),
                  ),
                ),
                _BannerContent(
                  displayYear: displayYear,
                  backgroundColor: backgroundColor,
                  textColor: textColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToWrapped(BuildContext context) {
    final targetContext = context.display.isDesktop
        ? context
        : coreController.coreKey.currentContext;
    if (targetContext != null) {
      LyNavigator.push(targetContext, WrappedMainPage(year: year));
    }
  }
}

class _BannerContent extends StatelessWidget {
  final int displayYear;
  final Color backgroundColor;
  final Color textColor;

  const _BannerContent({
    required this.displayYear,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          bottom: -25,
          child: Text(
            '$displayYear',
            style: TextStyle(
              fontSize: 130,
              fontWeight: FontWeight.w900,
              height: 1.0,
              letterSpacing: -6,
              color: textColor.withValues(alpha: 0.06),
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 20,
          child: Text(
            '{',
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w100,
              height: 1.0,
              color: textColor.withValues(alpha: 0.15),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _WrappedTag(
                backgroundColor: backgroundColor,
                textColor: textColor,
              ),
              _YearSection(
                displayYear: displayYear,
                textColor: textColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WrappedTag extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;

  const _WrappedTag({
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: textColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'WRAPPED',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
          color: backgroundColor,
        ),
      ),
    );
  }
}

class _YearSection extends StatelessWidget {
  final int displayYear;
  final Color textColor;

  const _YearSection({
    required this.displayYear,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$displayYear',
          style: TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.w900,
            height: 1.0,
            letterSpacing: -3,
            color: textColor,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 2,
          height: 36,
          margin: const EdgeInsets.only(bottom: 6),
          color: textColor.withValues(alpha: 0.2),
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.localization.wrappedBannerYourRetrospective,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColor.withValues(alpha: 0.6),
                ),
              ),
              Text(
                context.localization.wrappedBannerMusical,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlusPatternPainter extends CustomPainter {
  final Color color;

  _PlusPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double spacing = 40.0;
    const double sizeCross = 6.0;

    for (double x = 0; x < size.width; x += spacing) {
      double offsetY = (x % (spacing * 2) == 0) ? 0 : spacing / 2;

      for (double y = -spacing; y < size.height; y += spacing) {
        final centerX = x + 20;
        final centerY = y + offsetY + 20;

        canvas.drawLine(
          Offset(centerX - sizeCross / 2, centerY),
          Offset(centerX + sizeCross / 2, centerY),
          paint,
        );
        canvas.drawLine(
          Offset(centerX, centerY - sizeCross / 2),
          Offset(centerX, centerY + sizeCross / 2),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PlusPatternPainter oldDelegate) =>
      oldDelegate.color != color;
}
