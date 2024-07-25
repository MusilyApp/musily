import 'package:flutter/material.dart';
import 'package:musily/core/utils/display_helper.dart';

class AppFlex extends StatelessWidget {
  final List<Widget> children;
  final bool expanded;
  final bool wrap;
  final int maxItemsPerRow;
  final AppFlexSpacing? spacing;
  final int? maxItemsPerRowXs;
  final int? maxItemsPerRowSm;
  final int? maxItemsPerRowMd;
  final int? maxItemsPerRowLg;
  final int? maxItemsPerRowXl;
  final int? maxItemsPerRowXxl;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  const AppFlex({
    required this.children,
    this.expanded = true,
    this.wrap = false,
    this.maxItemsPerRow = 1,
    this.spacing,
    this.maxItemsPerRowLg,
    this.maxItemsPerRowMd,
    this.maxItemsPerRowSm,
    this.maxItemsPerRowXl,
    this.maxItemsPerRowXs,
    this.maxItemsPerRowXxl,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    super.key,
  });

  int getMaxItems(DisplayHelper displayHelper) {
    if (displayHelper.moreThanXl) {
      return maxItemsPerRowXxl ??
          maxItemsPerRowXl ??
          maxItemsPerRowLg ??
          maxItemsPerRowMd ??
          maxItemsPerRowSm ??
          maxItemsPerRowXs ??
          maxItemsPerRow;
    } else if (displayHelper.moreThanLg) {
      return maxItemsPerRowXl ??
          maxItemsPerRowLg ??
          maxItemsPerRowMd ??
          maxItemsPerRowSm ??
          maxItemsPerRowXs ??
          maxItemsPerRow;
    } else if (displayHelper.moreThanMd) {
      return maxItemsPerRowLg ??
          maxItemsPerRowMd ??
          maxItemsPerRowSm ??
          maxItemsPerRowXs ??
          maxItemsPerRow;
    } else if (displayHelper.moreThanSm) {
      return maxItemsPerRowMd ??
          maxItemsPerRowSm ??
          maxItemsPerRowXs ??
          maxItemsPerRow;
    } else if (displayHelper.moreThanXs) {
      return maxItemsPerRowSm ?? maxItemsPerRowXs ?? maxItemsPerRow;
    } else {
      return maxItemsPerRowXs ?? maxItemsPerRow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final DisplayHelper displayHelper = DisplayHelper(context);
      final int maxItems = getMaxItems(displayHelper);

      return Column(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        children: List<Widget>.generate(
          (children.length / maxItems).ceil(),
          (index) {
            final startIndex = index * maxItems;
            final endIndex =
                (index * maxItems + maxItems).clamp(0, children.length);
            final rowItems = children.sublist(startIndex, endIndex);

            return Column(
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (startIndex != 0 && spacing != null)
                  SizedBox(
                    height: spacing!.betweenColumnItems,
                  ),
                Builder(
                  builder: (context) {
                    List<Widget> rowChildren = [];
                    if (wrap) {
                      rowChildren = List<Widget>.generate(
                        maxItems,
                        (index) {
                          if (index >= 0 && index < rowItems.length) {
                            if (rowItems[index] is AppFlexItem) {
                              return rowItems[index];
                            }
                            return AppFlexItem(
                              expanded: expanded,
                              child: rowItems[index],
                            );
                          }
                          return AppFlexItem(
                            expanded: expanded,
                            child: Container(),
                          );
                        },
                      );
                    } else {
                      rowChildren = rowItems.asMap().entries.map(
                        (entry) {
                          final item = entry.value;
                          final index = entry.key;
                          if ((rowItems.length == 1) && item is AppFlexItem) {
                            return item;
                          }
                          return Expanded(
                            child: Row(
                              mainAxisAlignment:
                                  mainAxisAlignment ?? MainAxisAlignment.start,
                              crossAxisAlignment: crossAxisAlignment ??
                                  CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Builder(
                                  builder: (context) {
                                    if (item is AppFlexItem) {
                                      return item;
                                    }
                                    return AppFlexItem(
                                      expanded: expanded,
                                      child: item,
                                    );
                                  },
                                ),
                                if (index < rowItems.length - 1 &&
                                    spacing != null)
                                  SizedBox(
                                    width: spacing!.betweenRowItems,
                                  )
                              ],
                            ),
                          );
                        },
                      ).toList();
                    }
                    return Row(
                      mainAxisAlignment:
                          mainAxisAlignment ?? MainAxisAlignment.start,
                      crossAxisAlignment:
                          crossAxisAlignment ?? CrossAxisAlignment.start,
                      children: rowChildren,
                    );
                  },
                ),
              ],
            );
          },
        ),
      );
    });
  }
}

class AppFlexItem extends StatelessWidget {
  final Widget child;
  final int flex;
  final bool expanded;
  const AppFlexItem({
    required this.child,
    this.flex = 1,
    this.expanded = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!expanded) {
      return SizedBox(
        child: child,
      );
    }
    return Expanded(
      flex: flex,
      child: child,
    );
  }
}

class AppFlexSpacing {
  final double betweenRowItems;
  final double betweenColumnItems;

  AppFlexSpacing({
    this.betweenColumnItems = 0,
    this.betweenRowItems = 0,
  });

  factory AppFlexSpacing.all(double value) {
    return AppFlexSpacing(
      betweenColumnItems: value,
      betweenRowItems: value,
    );
  }
}
