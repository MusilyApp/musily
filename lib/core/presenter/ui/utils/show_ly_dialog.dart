import 'package:flutter/material.dart';
import 'package:musily/core/presenter/ui/boxes/ly_card.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';
import 'package:musily/core/presenter/ui/routers/ly_dialog_router.dart';

Future<T?> showLyDialog<T>({
  required BuildContext context,
  required Widget content,
  Widget? title,
  List<Widget>? actions,
  AlignmentGeometry? alignment,
  EdgeInsets? margin,
  EdgeInsets? padding,
  EdgeInsets? actionsPadding,
  LyDensity density = LyDensity.normal,
  double elevation = 4.0,
  double? height,
  BorderRadius? borderRadius,
  ShapeBorder? shape,
  bool barrierDismissible = true,
  Color? barrierColor,
  Duration transitionDuration = const Duration(milliseconds: 200),
  RouteTransitionsBuilder? transitionBuilder,
  bool useRootNavigator = true,
}) {
  return Navigator.push(
    context,
    LyDialogRouter(
      alignment: alignment,
      builder: (context) => LyCard(
        transitionDuration: transitionDuration,
        margin: margin ?? EdgeInsets.zero,
        header: title,
        height: height,
        content: content,
        footer: Wrap(
          spacing: 8,
          alignment: WrapAlignment.end,
          children: [
            ...actions ?? [],
          ],
        ),
        elevation: elevation,
        borderRadius: borderRadius,
        shape: shape,
        padding: padding,
        density: density,
      ),
    ),
  );
}
