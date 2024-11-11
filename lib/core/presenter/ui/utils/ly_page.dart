import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musily/core/presenter/extensions/date_time.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/utils/id_generator.dart';

class LyPage extends StatefulWidget {
  final contextManager = ContextManager();
  late final String contextKey;
  final bool ignoreFromStack;
  final bool preventPop;
  final bool mainPage;
  final Widget child;
  LyPage({
    required this.child,
    String? contextKey,
    this.ignoreFromStack = false,
    this.preventPop = false,
    this.mainPage = false,
    super.key,
  }) {
    this.contextKey = contextKey ?? idGenerator();
  }

  @override
  State<LyPage> createState() => _LyPageState();
}

class _LyPageState extends State<LyPage> {
  late final String contextKey;
  @override
  void initState() {
    super.initState();
    if (widget.mainPage) {
      contextKey = 'CorePage';
    } else {
      contextKey = widget.contextKey;
    }
    if (widget.ignoreFromStack) {
      return;
    }
    if (widget.mainPage) {
      ContextManager.setMainContext('CorePage', context);
    } else {
      ContextManager.addContext(
        contextKey,
        context,
      );
    }
    log('+[${DateTime.now().toHourMinuteSecond()}]: $contextKey added to stack.');
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.ignoreFromStack || widget.mainPage) {
      return;
    }
    ContextManager.removeContext(context);
    log('-[${DateTime.now().toHourMinuteSecond()}]: $contextKey removed from stack.');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.contextManager.contextStack.length ==
                  (widget.contextManager.hasMainPage ? 2 : 1) &&
              contextKey == 'CorePage'
          ? true
          : widget.preventPop
              ? false
              : widget.ignoreFromStack
                  ? true
                  : false,
      onPopInvoked: (didPop) {
        setState(() {});
        if (widget.ignoreFromStack || widget.preventPop) {
          return;
        }
        if (ContextManager().dialogStack.isNotEmpty) {
          ContextManager().changeLockState?.add(false);
          return;
        }
        if (widget.contextManager.hasMainPage &&
            widget.contextManager.contextStack.length ==
                (widget.contextManager.hasMainPage ? 2 : 1)) {
          SystemNavigator.pop();
          return;
        }
        if (!didPop &&
            widget.contextManager.contextStack.last.key == contextKey) {
          Navigator.pop(context);
          return;
        } else if (widget.contextManager.contextStack.last.key == contextKey) {
          ContextManager.removeContext(context);
          return;
        }
        final lastContext = widget.contextManager.contextStack.lastOrNull;
        if (lastContext != null) {
          LyNavigator.pop(lastContext.context);
        }
      },
      child: widget.child,
    );
  }
}
