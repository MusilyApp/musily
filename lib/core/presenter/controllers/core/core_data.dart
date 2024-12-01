import 'package:musily/core/domain/presenter/app_controller.dart';

class CoreData extends BaseControllerData {
  bool isShowingDialog;
  bool isPlayerExpanded;
  bool hadlingDeepLink;
  bool backupInProgress;
  String backupFileDir;

  CoreData({
    required this.isShowingDialog,
    required this.isPlayerExpanded,
    required this.hadlingDeepLink,
    required this.backupInProgress,
    required this.backupFileDir,
  });

  @override
  CoreData copyWith({
    bool? isShowingDialog,
    bool? isPlayerExpanded,
    bool? hadlingDeepLink,
    bool? backupInProgress,
    String? backupFileDir,
  }) {
    return CoreData(
      isShowingDialog: isShowingDialog ?? this.isShowingDialog,
      isPlayerExpanded: isPlayerExpanded ?? this.isPlayerExpanded,
      hadlingDeepLink: hadlingDeepLink ?? this.hadlingDeepLink,
      backupInProgress: backupInProgress ?? this.backupInProgress,
      backupFileDir: backupFileDir ?? this.backupFileDir,
    );
  }
}
