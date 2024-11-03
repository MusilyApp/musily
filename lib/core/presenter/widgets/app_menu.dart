import 'package:flutter/material.dart';
import 'package:musily/core/domain/entities/app_menu_entry.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/menu_entry.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class AppMenu extends StatefulWidget {
  final List<AppMenuEntry> entries;
  final CoreController coreController;
  final Widget Function(
    BuildContext context,
    void Function() invoke,
  ) toggler;
  final bool forceFloatingMenu;
  final bool forceModalMenu;
  final Widget? modalHeader;

  const AppMenu({
    super.key,
    required this.entries,
    required this.coreController,
    required this.toggler,
    this.forceFloatingMenu = false,
    this.forceModalMenu = false,
    this.modalHeader,
  });

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  final MenuController _menuController = MenuController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return widget.coreController.builder(
      builder: (context, data) {
        if ((context.display.isDesktop || widget.forceFloatingMenu) &&
            !widget.forceModalMenu) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: MenuAnchor(
              controller: _menuController,
              menuChildren: MenuEntry.build(
                context,
                [
                  ...widget.entries.map(
                    (entry) => MenuEntry(
                      leading: entry.leading,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: entry.title,
                      onPressed: entry.onTap,
                    ),
                  ),
                ],
              ),
              child: widget.toggler(
                context,
                () {
                  if (_menuController.isOpen) {
                    _menuController.close();
                  } else {
                    _menuController.open();
                  }
                },
              ),
            ),
          );
        }
        return widget.toggler(
          context,
          () {
            LyNavigator.showBottomSheet(
              context: widget.coreController.coreContext!,
              title: widget.modalHeader,
              width: context.display.width,
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.all(12),
              alignment: Alignment.bottomCenter,
              actionsPadding: const EdgeInsets.all(16),
              actions: (context) => [
                LyFilledButton(
                  onPressed: () {
                    Navigator.pop(
                      widget.coreController.coreContext!,
                    );
                  },
                  child: Text(context.localization.close),
                ),
              ],
              content: SizedBox(
                height: widget.entries.length < 5 ? 50 * 5.5 : 250,
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      ...widget.entries.map(
                        (entry) => LyListTile(
                          onTap: () {
                            Navigator.pop(
                              widget.coreController.coreContext!,
                            );
                            entry.onTap?.call();
                          },
                          leading: entry.leading,
                          title: entry.title,
                          trailing: entry.trailing,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
