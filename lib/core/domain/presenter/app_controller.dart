import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musily/core/domain/errors/app_error.dart';
import 'package:musily/core/domain/errors/musily_error.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';
import 'package:musily/core/presenter/widgets/app_builder.dart';

abstract class BaseControllerData {
  copyWith();
}

abstract class BaseController<Data extends BaseControllerData, Methods> {
  final _dataStreamController = StreamController<Data>.broadcast();
  final _eventStreamController =
      StreamController<BaseControllerEvent>.broadcast();

  late Data data;
  late BaseControllerEvent event;
  late Methods methods;
  final List<BaseControllerEvent> events;

  Data defineData();
  Methods defineMethods();
  void updateData(Data data) {
    this.data = data;
    if (!_dataStreamController.isClosed) {
      _dataStreamController.add(data);
    }
  }

  void dispatchEvent(BaseControllerEvent event) {
    this.event = event;
    onEventDispatched(event);
    if (event.streamController != null) {
      event.streamController!.add(event);
    }
    _eventStreamController.add(event);
  }

  void catchError(dynamic error) {
    if (error is AppError) {
      dispatchEvent(
        BaseControllerEvent<AppError>(
          id: 'catch_error',
          data: error,
        ),
      );
    }
    if (error is MusilyError) {
      dispatchEvent(
        BaseControllerEvent<MusilyError>(
          id: 'catch_error',
          data: error,
        ),
      );
    }
  }

  AppBuilder<Data, BaseControllerEvent> builder({
    required Widget Function(BuildContext context, Data data) builder,
    void Function(BuildContext context, BaseControllerEvent event, Data data)?
        eventListener,
    bool allowAlertDialog = false,
  }) {
    return AppBuilder(
      streams: [
        _dataStreamController.stream,
        _eventStreamController.stream,
      ],
      initialData: data,
      listener: (context, data) {
        if (this.event.id == 'catch_error' && allowAlertDialog) {
          if (this.event.data is MusilyError) {
            LyNavigator.showLyCardDialog(
              context: context,
              actions: (context) => [
                LyFilledButton(
                  onPressed: () {
                    dispatchEvent(
                      BaseControllerEvent(
                        data: 'errorDone',
                      ),
                    );
                    Navigator.pop(context);
                    // LyNavigator.navigateTo(NavigatorPages.homePage);
                  },
                  child: const Text('Ok'),
                )
              ],
              title: Text(
                getErrorStringById(
                  (this.event.data as MusilyError).id,
                ),
              ),
              builder: (context) => const SizedBox.shrink(),
            );
          }
        }
        return eventListener?.call(context, this.event, this.data);
      },
      builder: (context, data) {
        return builder(context, this.data);
      },
    );
  }

  List<StreamSubscription> subscriptions = [];

  BaseController({this.events = const []}) {
    data = defineData();
    methods = defineMethods();
    event = BaseControllerEvent(id: 'initialEvent', data: data);

    for (final event in events) {
      if (event.streamController != null) {
        subscriptions.add(event.streamController!.stream.listen((e) {
          onEventDispatched(e);
        }));
      }
    }
  }

  void onEventDispatched(BaseControllerEvent event) {}

  void dispose() {
    _dataStreamController.close();
    _eventStreamController.close();
    for (final sub in subscriptions) {
      sub.cancel();
    }
  }
}

class BaseControllerEvent<D> {
  String id;
  D data;
  StreamController? streamController;

  BaseControllerEvent({this.id = '', required this.data});

  BaseControllerEvent<D> copyWith({
    String? id,
    D? data,
  }) {
    return BaseControllerEvent<D>(
      id: id ?? this.id,
      data: data ?? this.data,
    );
  }

  void listen() {
    streamController ??= StreamController<D>();
  }

  void dispose() {
    if (streamController != null) {
      streamController!.close();
    }
  }
}
