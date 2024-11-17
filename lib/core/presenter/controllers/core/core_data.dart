import 'package:musily/core/domain/presenter/app_controller.dart';

class CoreData extends BaseControllerData {
  bool isShowingDialog;
  bool isPlayerExpanded;
  bool hadlingDeepLink;
  CoreData({
    required this.isShowingDialog,
    required this.isPlayerExpanded,
    required this.hadlingDeepLink,
  });

  @override
  CoreData copyWith({
    bool? isShowingDialog,
    bool? isPlayerExpanded,
    bool? hadlingDeepLink,
  }) {
    return CoreData(
      isShowingDialog: isShowingDialog ?? this.isShowingDialog,
      isPlayerExpanded: isPlayerExpanded ?? this.isPlayerExpanded,
      hadlingDeepLink: hadlingDeepLink ?? this.hadlingDeepLink,
    );
  }
}
