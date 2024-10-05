import 'package:flutter/material.dart';
import 'package:musily/core/domain/entities/app_menu_entry.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/core/presenter/ui/utils/show_ly_dialog.dart';
import 'package:musily/core/presenter/widgets/core_base_dialog.dart';
import 'package:musily/core/presenter/widgets/menu_entry.dart';
import 'package:musily_player/core/utils/display_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final MenuController menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return widget.coreController.builder(
      builder: (context, data) {
        if ((DisplayHelper(context).isDesktop || widget.forceFloatingMenu) &&
            !widget.forceModalMenu) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: MenuAnchor(
              controller: menuController,
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
                  if (menuController.isOpen) {
                    menuController.close();
                  } else {
                    menuController.open();
                  }
                },
              ),
            ),
          );
        }
        return widget.toggler(
          context,
          () {
            widget.coreController.methods.pushModal(
              const SizedBox.shrink(),
            );
            showLyDialog(
              context: widget.coreController.coreKey.currentContext!,
              title: widget.modalHeader,
              padding: EdgeInsets.zero,
              // height: widget.entries.length < 5 ? 50 * 5.5 : 400,
              alignment: Alignment.bottomCenter,
              actionsPadding: const EdgeInsets.all(16),
              actions: [
                LyFilledButton(
                  onPressed: () {
                    Navigator.pop(
                      widget.coreController.coreKey.currentContext!,
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.close),
                ),
              ],
              content: SizedBox(
                height: widget.entries.length < 5 ? 50 * 5.5 : 250,
                child: CoreBaseDialog(
                  coreController: widget.coreController,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ...widget.entries.map(
                        (entry) => LyListTile(
                          onTap: () {
                            Navigator.pop(
                              widget.coreController.coreKey.currentContext!,
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
            // widget.coreController.methods.pushModal(
            //   CoreBaseDialog(
            //     coreController: widget.coreController,
            //     child: Column(
            //       children: [
            //         if (widget.modalHeader != null)
            //           Builder(
            //             builder: (context) {
            //               return Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   widget.modalHeader!,
            //                   const Divider(),
            //                 ],
            //               );
            //             },
            //           ),
            //         Expanded(
            //           child: ListView(
            //             children: [
            //               ...widget.entries.map(
            //                 (entry) => LyListTile(
            //                   onTap: () {
            //                     widget.coreController.methods.closeDialog();
            //                     entry.onTap?.call();
            //                   },
            //                   leading: entry.leading,
            //                   title: entry.title,
            //                   trailing: entry.trailing,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // );
          },
        );
      },
    );
  }
}
