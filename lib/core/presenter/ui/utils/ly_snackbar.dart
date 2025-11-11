import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:toastification/toastification.dart';

class LySnackbarProps {
  final String message;
  final Color color;
  final IconData? icon;

  LySnackbarProps({
    required this.message,
    required this.color,
    required this.icon,
  });

  static LySnackbarProps success(String message) {
    return LySnackbarProps(
      message: message,
      color: Colors.green,
      icon: LucideIcons.circleCheck,
    );
  }

  static LySnackbarProps error(String message) {
    return LySnackbarProps(
      message: message,
      color: Colors.red,
      icon: LucideIcons.circleX,
    );
  }

  static LySnackbarProps warning(String message) {
    return LySnackbarProps(
      message: message,
      color: Colors.yellow,
      icon: LucideIcons.circleAlert,
    );
  }

  static LySnackbarProps info(String message) {
    return LySnackbarProps(
      message: message,
      color: Colors.blue,
      icon: LucideIcons.info,
    );
  }
}

class _Snackbar {
  static show({
    required LySnackbarProps props,
  }) {
    final contextManager = ContextManager();
    final context = contextManager.contextStack.last.context;
    if (context.display.isDesktop) {
      toastification.show(
        context: context,
        title: Text(
          props.message,
          style: context.themeData.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: props.color,
          ),
        ),
        backgroundColor: context.themeData.colorScheme.surface,
        style: ToastificationStyle.fillColored,
        margin: const EdgeInsets.only(bottom: 12, right: 12),
        closeButton: ToastCloseButton(
          buttonBuilder: (context, onClose) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.circular(4),
                child: Icon(LucideIcons.x, color: props.color),
              ),
            );
          },
        ),
        borderSide: BorderSide(color: props.color, width: 1),
        icon: Icon(props.icon ?? LucideIcons.info, color: props.color),
        type: ToastificationType.custom(
          props.message,
          context.themeData.colorScheme.surface,
          props.icon ?? LucideIcons.info,
        ),
        autoCloseDuration: const Duration(seconds: 10),
        alignment: Alignment.bottomRight,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          content: Row(
            children: [
              if (props.icon != null) ...[
                Icon(props.icon!, color: props.color),
                const SizedBox(width: 8),
              ],
              Text(
                props.message,
                style: TextStyle(
                  color: props.color,
                ),
              ),
            ],
          ),
          backgroundColor: context.themeData.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: props.color,
              width: 1,
            ),
          ),
        ),
      );
    }
  }
}

class LySnackbar {
  static void showSuccess(String message, {IconData? icon}) {
    _Snackbar.show(
      props: LySnackbarProps.success(message),
    );
  }

  static void showError(String message, {IconData? icon}) {
    _Snackbar.show(
      props: LySnackbarProps.error(message),
    );
  }

  static void showWarning(String message, {IconData? icon}) {
    _Snackbar.show(
      props: LySnackbarProps.warning(message),
    );
  }

  static void showInfo(String message, {IconData? icon}) {
    _Snackbar.show(
      props: LySnackbarProps.info(message),
    );
  }
}
