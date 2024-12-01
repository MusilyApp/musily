import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:musily/core/presenter/extensions/date_time.dart';
import 'package:musily/core/presenter/routers/downup_router.dart';
import 'package:musily/core/presenter/ui/boxes/ly_card.dart';
import 'package:musily/core/presenter/ui/ly_properties/ly_density.dart';
import 'package:musily/core/presenter/ui/utils/ly_disposable.dart';
import 'package:musily/core/utils/id_generator.dart';

class StackContext {
  String key;
  BuildContext context;

  StackContext({
    required this.key,
    required this.context,
  });

  @override
  String toString() => 'StackContext(key: $key)';
}

class ContextManager {
  static final ContextManager _instance = ContextManager._internal();
  factory ContextManager() {
    return _instance;
  }
  ContextManager._internal();

  final List<StackContext> contextStack = [];
  List<StackContext> dialogStack = [];

  StreamController<bool>? changeLockState = StreamController<bool>();
  StreamSubscription<bool>? lockStateListener;

  bool hasMainPage = false;
  bool preventPopGlobal = false;

  static addToDialogStack(StackContext context) {
    final contextManager = ContextManager();
    contextManager.dialogStack.add(context);
  }

  static removeFromDialogStack(String key) {
    final contextManager = ContextManager();
    contextManager.dialogStack.removeWhere((e) => e.key == key);
  }

  static addChangeLockListener(void Function(bool data) listener) {
    final contextManager = ContextManager();
    if (contextManager.changeLockState != null) {
      contextManager.changeLockState?.close();
      contextManager.changeLockState = StreamController<bool>();
    }
    if (contextManager.lockStateListener != null) {
      contextManager.lockStateListener!.cancel();
      contextManager.lockStateListener = null;
    }
    contextManager.lockStateListener =
        contextManager.changeLockState?.stream.listen(
      listener,
    );
  }

  static addContext(String key, BuildContext context, {int? position}) {
    final contextManager = ContextManager();
    final stackContext = StackContext(key: key, context: context);
    if (position != null) {
      contextManager.contextStack.insert(position, stackContext);
    }
    contextManager.contextStack.add(stackContext);
  }

  static setMainContext(String key, BuildContext context) {
    final contextManager = ContextManager();
    contextManager.hasMainPage = true;
    contextManager.contextStack.insert(
      0,
      StackContext(
        key: key,
        context: context,
      ),
    );
  }

  static removeContext(BuildContext context) {
    if (ContextManager().dialogStack.isNotEmpty) {
      return;
    }
    final contextManager = ContextManager();
    contextManager.contextStack.removeWhere((e) => e.context == context);
  }

  static removeContextByKey(String contextKey) {
    if (ContextManager().dialogStack.isNotEmpty) {
      return;
    }
    final contextManager = ContextManager();
    contextManager.contextStack.removeWhere((e) => e.key == contextKey);
  }
}

enum NavigatorPages {
  sectionsPage,
  libraryPage,
  searchPage,
  searchResultsPage,
  downloaderPage,
  blankPage;

  static getRoute(NavigatorPages page) {
    switch (page) {
      case NavigatorPages.sectionsPage:
        return '/sections/';
      case NavigatorPages.libraryPage:
        return '/library/';
      case NavigatorPages.searchPage:
        return '/search/';
      case NavigatorPages.searchResultsPage:
        return '/searcher/results_page/';
      case NavigatorPages.downloaderPage:
        return '/downloader/';
      case NavigatorPages.blankPage:
        return '/blank/';
    }
  }
}

class LyNavigator {
  static navigateTo(
    NavigatorPages page, {
    dynamic arguments,
  }) {
    final route = NavigatorPages.getRoute(page);
    Modular.to.navigate(
      route,
      arguments: arguments,
    );
  }

  static push(
    BuildContext context,
    Widget widget, {
    String? contextKey,
  }) {
    final contextManager = ContextManager();
    late final BuildContext usingContext;

    final stackContext = contextManager.contextStack
        .where((e) => e.key == contextKey)
        .firstOrNull;
    usingContext = stackContext?.context ?? context;
    Navigator.of(usingContext).push(
      DownupRouter(
        builder: (context) => widget,
      ),
    );
  }

  static pop(BuildContext context) {
    Navigator.pop(context);
  }

  static close(String contextKey) {
    final stack = ContextManager().contextStack;
    final context =
        stack.where((e) => e.key == contextKey).firstOrNull?.context;
    if (context != null) {
      Navigator.pop(context);
    }
  }

  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget content,
    Widget? title,
    List<Widget> Function(BuildContext context)? actions,
    AlignmentGeometry? alignment,
    EdgeInsets? margin,
    EdgeInsets? padding,
    EdgeInsets? actionsPadding,
    LyDensity density = LyDensity.normal,
    double elevation = 4.0,
    double? height,
    double width = 300,
    BorderRadius? borderRadius,
    ShapeBorder? shape,
    bool barrierDismissible = true,
    Color? barrierColor,
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder,
    bool useRootNavigator = true,
  }) {
    final key = idGenerator();
    ContextManager().dialogStack.add(
          StackContext(
            key: key,
            context: context,
          ),
        );
    log('+[${DateTime.now().toHourMinuteSecond()}] Bottom Sheet Added to Stack');
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      useRootNavigator: true,
      builder: (context) => SafeArea(
        child: LyCard(
          onInitState: () {
            ContextManager.addChangeLockListener(
              (data) {
                if (!data) {
                  if (ContextManager()
                      .dialogStack
                      .where((e) => e.key == key)
                      .isNotEmpty) {
                    if (ContextManager().preventPopGlobal) {
                      return;
                    }
                    ContextManager().preventPopGlobal = true;
                    Navigator.pop(context);
                    return;
                  }
                  log('-[${DateTime.now().toHourMinuteSecond()}] Bottom Sheet Removed from Stack');
                }
              },
            );
          },
          onDispose: () {
            ContextManager().dialogStack.removeWhere((e) => e.key == key);
            ContextManager().preventPopGlobal = false;
            log('-[${DateTime.now().toHourMinuteSecond()}] Bottom Sheet Removed from Stack');
          },
          transitionDuration: transitionDuration,
          margin: margin ?? EdgeInsets.zero,
          header: title,
          headerPadding: EdgeInsets.zero,
          height: height,
          width: width,
          content: content,
          footer: (actions?.call(context).isEmpty ?? true)
              ? null
              : Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    ...actions?.call(context) ?? [],
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

  static Future<T?> showLyCardDialog<T>({
    required BuildContext context,
    required Widget Function(BuildContext context) builder,
    Widget? title,
    List<Widget> Function(BuildContext context)? actions,
    AlignmentGeometry? alignment,
    EdgeInsets? margin,
    EdgeInsets? padding,
    EdgeInsets? actionsPadding,
    LyDensity density = LyDensity.normal,
    double elevation = 4.0,
    double? height,
    double width = 300,
    BorderRadius? borderRadius,
    ShapeBorder? shape,
    bool barrierDismissible = true,
    Color? barrierColor,
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder,
    bool useRootNavigator = true,
  }) {
    final key = idGenerator();
    ContextManager().dialogStack.add(
          StackContext(
            key: key,
            context: context,
          ),
        );
    log('+[${DateTime.now().toHourMinuteSecond()}] Dialog $key added to Stack');
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => LyCard(
        onInitState: () {
          ContextManager.addChangeLockListener(
            (data) {
              if (!barrierDismissible) {
                return;
              }
              if (!data) {
                if (ContextManager()
                    .dialogStack
                    .where((e) => e.key == key)
                    .isNotEmpty) {
                  if (ContextManager().preventPopGlobal) {
                    return;
                  }
                  ContextManager().preventPopGlobal = true;
                  Navigator.pop(context);
                  return;
                }
                log('-[${DateTime.now().toHourMinuteSecond()}] Dialog $key Removed from Stack');
              }
            },
          );
        },
        onDispose: () {
          ContextManager().dialogStack.removeWhere((e) => e.key == key);
          ContextManager().preventPopGlobal = false;
          log('-[${DateTime.now().toHourMinuteSecond()}] Dialog $key Removed from Stack');
        },
        transitionDuration: transitionDuration,
        margin: margin ?? EdgeInsets.zero,
        header: title,
        height: height,
        width: width,
        content: Padding(
          padding: padding ?? const EdgeInsets.all(8.0),
          child: builder(context),
        ),
        footer: ((actions?.call(context))?.isEmpty ?? true)
            ? null
            : Wrap(
                spacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  ...actions?.call(context) ?? [],
                ],
              ),
        elevation: elevation,
        borderRadius: borderRadius,
        shape: shape,
        padding: padding ?? EdgeInsets.zero,
        density: density,
      ),
    );
  }

  static Future<T?> showLyDialog<T>({
    required BuildContext context,
    required Widget Function(BuildContext context) builder,
  }) {
    final key = idGenerator();
    ContextManager().dialogStack.add(
          StackContext(
            key: key,
            context: context,
          ),
        );
    log('+[${DateTime.now().toHourMinuteSecond()}] Dialog $key added to Stack');
    return showDialog(
      context: context,
      builder: (context) => LyDisposable(
        onInitState: () {
          ContextManager.addChangeLockListener(
            (data) {
              if (!data) {
                if (ContextManager()
                    .dialogStack
                    .where((e) => e.key == key)
                    .isNotEmpty) {
                  if (ContextManager().preventPopGlobal) {
                    return;
                  }
                  ContextManager().preventPopGlobal = true;
                  Navigator.pop(context);
                  return;
                }
                log('-[${DateTime.now().toHourMinuteSecond()}] Dialog $key Removed from Stack');
              }
            },
          );
        },
        onDispose: () {
          ContextManager().dialogStack.removeWhere((e) => e.key == key);
          ContextManager().preventPopGlobal = false;
          log('-[${DateTime.now().toHourMinuteSecond()}] Dialog $key Removed from Stack');
        },
        child: builder(context),
      ),
    );
  }
}
