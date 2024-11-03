import 'package:flutter/material.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/utils/display_helper.dart';

/// A widget that arranges its children in a flexible grid.
///
/// It allows for customizing the number of items per row based on the screen size.
/// It also provides options for spacing between items and alignment.
///
/// Example:
///
/// ```dart
/// AppFlex(
///   children: [
///     Text('Item 1'),
///     Text('Item 2'),
///     Text('Item 3'),
///   ],
///   maxItemsPerRow: 2,
///   spacing: AppFlexSpacing.all(16),
/// )
/// ```
class AppFlex extends StatelessWidget {
  /// The children to be arranged in the grid.
  final List<Widget> children;

  /// Whether each child should expand to fill the available space in the row.
  final bool expanded;

  /// Whether the children should wrap to the next row if they exceed the maximum items per row.
  final bool wrap;

  /// The maximum number of items per row for all screen sizes.
  final int maxItemsPerRow;

  /// The spacing between items in the grid.
  final AppFlexSpacing? spacing;

  /// The maximum number of items per row for extra small screens.
  final int? maxItemsPerRowXs;

  /// The maximum number of items per row for small screens.
  final int? maxItemsPerRowSm;

  /// The maximum number of items per row for medium screens.
  final int? maxItemsPerRowMd;

  /// The maximum number of items per row for large screens.
  final int? maxItemsPerRowLg;

  /// The maximum number of items per row for extra large screens.
  final int? maxItemsPerRowXl;

  /// The maximum number of items per row for extra extra large screens.
  final int? maxItemsPerRowXxl;

  /// The main axis alignment of the children.
  final MainAxisAlignment? mainAxisAlignment;

  /// The cross axis alignment of the children.
  final CrossAxisAlignment? crossAxisAlignment;

  final bool asListView;

  final EdgeInsetsGeometry? contentPadding;

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
    this.asListView = false,
    this.contentPadding,
    super.key,
  });

  /// Returns the maximum number of items per row based on the current screen size.
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final int maxItems = getMaxItems(context.display);
        final widgetChildren = List<Widget>.generate(
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
                              return Expanded(
                                flex: (rowItems[index] as AppFlexItem).flex,
                                child: Row(
                                  children: [
                                    rowItems[index] as AppFlexItem,
                                    if (index < rowItems.length - 1 &&
                                        spacing != null)
                                      SizedBox(
                                        width: spacing!.betweenRowItems,
                                      )
                                  ],
                                ),
                              );
                            }
                            return Expanded(
                              child: Row(
                                mainAxisAlignment: mainAxisAlignment ??
                                    MainAxisAlignment.start,
                                crossAxisAlignment: crossAxisAlignment ??
                                    CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppFlexItem(
                                    expanded: expanded,
                                    child: rowItems[index],
                                  ),
                                  if (index < rowItems.length - 1 &&
                                      spacing != null)
                                    SizedBox(
                                      width: spacing!.betweenRowItems,
                                    )
                                ],
                              ),
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
        );
        if (asListView) {
          return ListView.builder(
            padding: contentPadding,
            itemCount: widgetChildren.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => widgetChildren[index],
          );
        }
        return Padding(
          padding: contentPadding ?? EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
            children: widgetChildren,
          ),
        );
      },
    );
  }
}

/// A widget that allows for customizing the flex value of its child.
///
/// It can be used to control how much space a child takes up in a row.
class AppFlexItem extends StatelessWidget {
  /// The child widget to be displayed.
  final Widget child;

  /// The flex value of the child.
  final int flex;

  /// Whether the child should expand to fill the available space in the row.
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

/// A class for defining spacing values between items in an AppFlex grid.
class AppFlexSpacing {
  /// The spacing between items in a row.
  final double betweenRowItems;

  /// The spacing between items in a column.
  final double betweenColumnItems;

  AppFlexSpacing({
    this.betweenColumnItems = 0,
    this.betweenRowItems = 0,
  });

  /// Creates an AppFlexSpacing with the same value for both row and column spacing.
  factory AppFlexSpacing.all(double value) {
    return AppFlexSpacing(
      betweenColumnItems: value,
      betweenRowItems: value,
    );
  }
}
