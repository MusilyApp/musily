// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:musily/core/domain/presenter/app_controller.dart';

class CoreData extends BaseControllerData {
  bool isShowingDialog;
  bool isPlayerExpanded;
  bool hadlingDeepLink;
  bool backupInProgress;
  String backupFileDir;
  String windowTitle;
  bool isMaximized;

  CoreData({
    required this.isShowingDialog,
    required this.isPlayerExpanded,
    required this.hadlingDeepLink,
    required this.backupInProgress,
    required this.backupFileDir,
    required this.isMaximized,
    required this.windowTitle,
  });

  @override
  CoreData copyWith({
    bool? isShowingDialog,
    bool? isPlayerExpanded,
    bool? hadlingDeepLink,
    bool? backupInProgress,
    String? backupFileDir,
    String? windowTitle,
    bool? isMaximized,
  }) {
    return CoreData(
      isShowingDialog: isShowingDialog ?? this.isShowingDialog,
      isPlayerExpanded: isPlayerExpanded ?? this.isPlayerExpanded,
      hadlingDeepLink: hadlingDeepLink ?? this.hadlingDeepLink,
      backupInProgress: backupInProgress ?? this.backupInProgress,
      backupFileDir: backupFileDir ?? this.backupFileDir,
      windowTitle: windowTitle ?? this.windowTitle,
      isMaximized: isMaximized ?? this.isMaximized,
    );
  }
}
