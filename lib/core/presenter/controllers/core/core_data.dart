import 'package:musily/core/domain/presenter/app_controller.dart';

class CoreData extends BaseControllerData {
  bool isShowingDialog;
  bool isPlayerExpanded;
  CoreData({
    required this.isShowingDialog,
    required this.isPlayerExpanded,
  });

  @override
  CoreData copyWith({
    bool? isShowingDialog,
    bool? isPlayerExpanded,
  }) {
    return CoreData(
      isShowingDialog: isShowingDialog ?? this.isShowingDialog,
      isPlayerExpanded: isPlayerExpanded ?? this.isPlayerExpanded,
    );
  }
}
