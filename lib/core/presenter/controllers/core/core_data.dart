import 'package:flutter/material.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';

class CoreData extends BaseControllerData {
  bool isShowingDialog;
  bool isPlayerExpanded;
  List<Widget> pages;
  CoreData({
    required this.isShowingDialog,
    required this.isPlayerExpanded,
    required this.pages,
  });

  @override
  CoreData copyWith({
    bool? isShowingDialog,
    bool? isPlayerExpanded,
    List<Widget>? pages,
  }) {
    return CoreData(
      isShowingDialog: isShowingDialog ?? this.isShowingDialog,
      isPlayerExpanded: isPlayerExpanded ?? this.isPlayerExpanded,
      pages: pages ?? this.pages,
    );
  }
}
