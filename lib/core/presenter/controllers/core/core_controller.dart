import 'package:flutter/material.dart';
import 'package:musily/core/data/database/legacy_library_database.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/presenter/controllers/core/core_data.dart';
import 'package:musily/core/presenter/controllers/core/core_methods.dart';

class CoreController extends BaseController<CoreData, CoreMethods> {
  final GlobalKey coreKey = GlobalKey();
  final GlobalKey coreShowingKey = GlobalKey();

  BuildContext? get coreContext => coreKey.currentContext;
  BuildContext? get coreShowingContext => coreShowingKey.currentContext;

  final legacyLibraryDatabase = LegacyLibraryDatabase();

  @override
  CoreData defineData() {
    return CoreData(
      isShowingDialog: false,
      isPlayerExpanded: false,
      pages: [],
    );
  }

  @override
  CoreMethods defineMethods() {
    return CoreMethods();
  }
}
