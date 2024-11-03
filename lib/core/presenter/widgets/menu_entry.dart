import 'package:flutter/material.dart';

class MenuEntry {
  const MenuEntry({
    required this.child,
    this.shortcut,
    this.onPressed,
    this.menuChildren,
    this.leading,
    this.contentPadding,
  }) : assert(
          menuChildren == null || onPressed == null,
          'onPressed is ignored if menuChildren are provided',
        );
  final Widget child;

  final MenuSerializableShortcut? shortcut;
  final VoidCallback? onPressed;
  final List<MenuEntry>? menuChildren;
  final Widget? leading;
  final EdgeInsetsGeometry? contentPadding;

  static List<Widget> build(BuildContext context, List<MenuEntry> selections) {
    Widget buildSelection(MenuEntry selection) {
      if (selection.menuChildren != null) {
        return SubmenuButton(
          leadingIcon: selection.leading,
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(
              selection.contentPadding,
            ),
            visualDensity: VisualDensity.compact,
            alignment: Alignment.center,
            elevation: const WidgetStatePropertyAll(0),
          ),
          menuChildren: MenuEntry.build(context, selection.menuChildren!),
          child: selection.child,
        );
      }
      return MenuItemButton(
        leadingIcon: selection.leading,
        shortcut: selection.shortcut,
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            selection.contentPadding,
          ),
          visualDensity: VisualDensity.compact,
          alignment: Alignment.center,
          elevation: const WidgetStatePropertyAll(0),
        ),
        onPressed: selection.onPressed,
        child: selection.child,
      );
    }

    return selections.map<Widget>(buildSelection).toList();
  }

  static Map<MenuSerializableShortcut, Intent> shortcuts(
      List<MenuEntry> selections) {
    final Map<MenuSerializableShortcut, Intent> result =
        <MenuSerializableShortcut, Intent>{};
    for (final MenuEntry selection in selections) {
      if (selection.menuChildren != null) {
        result.addAll(MenuEntry.shortcuts(selection.menuChildren!));
      } else {
        if (selection.shortcut != null && selection.onPressed != null) {
          result[selection.shortcut!] =
              VoidCallbackIntent(selection.onPressed!);
        }
      }
    }
    return result;
  }
}
