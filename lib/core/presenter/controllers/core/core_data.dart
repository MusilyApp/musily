import 'package:musily/core/domain/presenter/app_controller.dart';

class CoreData extends BaseControllerData {
  bool isShowingDialog;
  bool isPlayerExpanded;
  bool hadlingDeepLink;
  bool backupInProgress;
  String backupFileDir;
  String windowTitle;
  bool isMaximized;
  bool offlineMode;
  bool showDropFiles;

  CoreData({
    required this.isShowingDialog,
    required this.isPlayerExpanded,
    required this.hadlingDeepLink,
    required this.backupInProgress,
    required this.backupFileDir,
    required this.isMaximized,
    required this.windowTitle,
    this.showDropFiles = false,
    this.offlineMode = false,
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
    bool? offlineMode,
    bool? showDropFiles,
  }) {
    return CoreData(
      isShowingDialog: isShowingDialog ?? this.isShowingDialog,
      isPlayerExpanded: isPlayerExpanded ?? this.isPlayerExpanded,
      hadlingDeepLink: hadlingDeepLink ?? this.hadlingDeepLink,
      backupInProgress: backupInProgress ?? this.backupInProgress,
      backupFileDir: backupFileDir ?? this.backupFileDir,
      windowTitle: windowTitle ?? this.windowTitle,
      isMaximized: isMaximized ?? this.isMaximized,
      offlineMode: offlineMode ?? this.offlineMode,
      showDropFiles: showDropFiles ?? this.showDropFiles,
    );
  }
}
