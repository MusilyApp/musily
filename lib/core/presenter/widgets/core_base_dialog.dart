import 'package:flutter/material.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';

class CoreBaseDialog extends StatelessWidget {
  final Widget child;
  final CoreController coreController;
  const CoreBaseDialog({
    super.key,
    required this.child,
    required this.coreController,
  });

  @override
  Widget build(BuildContext context) {
    return coreController.builder(
      eventListener: (context, event, data) {
        if (event.id == 'closeDialog') {
          Navigator.canPop(context);
          coreController.updateData(
            coreController.data.copyWith(
              isShowingDialog: false,
            ),
          );
        }
      },
      builder: (context, data) {
        return PopScope(
          onPopInvoked: (didPop) {
            coreController.updateData(
              coreController.data.copyWith(
                isShowingDialog: false,
              ),
            );
          },
          child: child,
        );
      },
    );
  }
}
