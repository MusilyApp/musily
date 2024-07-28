import 'package:flutter/material.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';

class CoreData extends BaseControllerData {
  bool isShowingDialog;
  bool isPlayerExpanded;
  Widget? page;
  CoreData({
    required this.isShowingDialog,
    required this.isPlayerExpanded,
    required this.page,
  });

  @override
  CoreData copyWith({
    bool? isShowingDialog,
    bool? isPlayerExpanded,
    Widget? page,
  }) {
    return CoreData(
      isShowingDialog: isShowingDialog ?? this.isShowingDialog,
      isPlayerExpanded: isPlayerExpanded ?? this.isPlayerExpanded,
      page: page ?? this.page,
    );
  }
}
