import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';

class SizedRouter<T> extends ModalRoute<T> {
  final Widget Function(BuildContext context) builder;
  final int size;

  SizedRouter({
    super.settings,
    super.filter,
    super.traversalEdgeBehavior,
    required this.builder,
    this.size = 50,
  });

  @override
  Color? get barrierColor => Colors.black.withValues(alpha: .5);

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
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * (size / 100),
            child: GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    border: context.isDarkMode
                        ? Border(
                            top: BorderSide(
                              color:
                                  context.themeData.colorScheme.outlineVariant,
                              width: 1.5,
                            ),
                            left: BorderSide(
                              color:
                                  context.themeData.colorScheme.outlineVariant,
                              width: 1.5,
                            ),
                            right: BorderSide(
                              color:
                                  context.themeData.colorScheme.outlineVariant,
                              width: 1.5,
                            ),
                          )
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Scaffold(
                      body: builder(context),
                    ),
                  ),
                ),
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
