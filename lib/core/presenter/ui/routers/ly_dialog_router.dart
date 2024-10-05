import 'package:flutter/material.dart';

class LyDialogRouter<T> extends ModalRoute<T> {
  final Widget Function(BuildContext context) builder;
  final AlignmentGeometry? alignment;

  LyDialogRouter({
    super.settings,
    super.filter,
    super.traversalEdgeBehavior,
    this.alignment,
    required this.builder,
  });

  @override
  Color? get barrierColor => Colors.black.withOpacity(.5);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: alignment ?? Alignment.center,
          child: GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  builder(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
    );

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
