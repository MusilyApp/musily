import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/window/draggable_box.dart';

class MusilyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  final bool autoImplyLeading;
  final bool centerTitle;
  final double? height;

  const MusilyAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.backgroundColor,
    this.surfaceTintColor,
    this.autoImplyLeading = true,
    this.centerTitle = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableBox(
      child: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: surfaceTintColor,
        toolbarHeight: height,
        leading: autoImplyLeading && Navigator.canPop(context)
            ? Tooltip(
                message: context.localization.back,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.chevronLeft),
                ),
              )
            : leading,
        title: title,
        centerTitle: centerTitle,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}
