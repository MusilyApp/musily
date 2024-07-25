import 'package:flutter/material.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';

class CoreBaseWidget extends StatelessWidget {
  final CoreController coreController;
  final Widget child;
  const CoreBaseWidget({
    super.key,
    required this.coreController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return coreController.builder(
      builder: (context, data) => PopScope(
        canPop: !data.isShowingDialog && !data.isPlayerExpanded,
        onPopInvoked: (didPop) {
          if (data.isShowingDialog) {
            coreController.dispatchEvent(
              BaseControllerEvent(
                id: 'closeDialog',
                data: data,
              ),
            );
          }
          if (data.isPlayerExpanded) {
            coreController.dispatchEvent(
              BaseControllerEvent(
                id: 'closePlayer',
                data: data,
              ),
            );
          }
        },
        child: child,
      ),
    );
  }
}
