import 'package:flutter/material.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/core/presenter/controllers/core/core_data.dart';
import 'package:musily/core/presenter/controllers/core/core_methods.dart';

class CoreController extends BaseController<CoreData, CoreMethods> {
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
    return CoreMethods(
      closeDialog: () {
        dispatchEvent(
          BaseControllerEvent(
            id: 'closeDialog',
            data: data,
          ),
        );
      },
      pushModal: (widget) {
        updateData(
          data.copyWith(
            isShowingDialog: true,
          ),
        );
        dispatchEvent(
          BaseControllerEvent<Widget>(
            id: 'pushModal',
            data: widget,
          ),
        );
      },
      pushWidget: (widget) {
        dispatchEvent(
          BaseControllerEvent<Widget>(
            id: 'pushWidget',
            data: widget,
          ),
        );
        updateData(
          data.copyWith(
            pages: data.pages
              ..add(
                widget,
              ),
          ),
        );
      },
    );
  }
}
