import 'package:flutter/material.dart';
import 'package:musily/core/domain/entities/identifiable.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';

class LibraryToggler<T> extends StatefulWidget {
  final T item;
  final LibraryController libraryController;
  final Widget Function(
    BuildContext context,
    Future<void> Function() addToLibrary,
  ) notInLibraryWidget;
  final Widget Function(
    BuildContext context,
    Future<void> Function() removeFromLibrary,
  ) inLibraryWidget;
  final Widget Function(
    BuildContext context,
  )? loadingWidget;

  const LibraryToggler({
    required this.libraryController,
    required this.notInLibraryWidget,
    required this.item,
    required this.inLibraryWidget,
    this.loadingWidget,
    super.key,
  });

  @override
  State<LibraryToggler<T>> createState() => _LibraryTogglerState<T>();
}

class _LibraryTogglerState<T> extends State<LibraryToggler<T>> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.libraryController.builder(
      builder: (context, data) {
        if (loading || data.addingToLibrary) {
          return widget.loadingWidget?.call(context) ??
              const Center(
                child: CircularProgressIndicator(),
              );
        }
        if (data.items
            .where((element) =>
                (element.value as Identifiable).id ==
                (widget.item as Identifiable).id)
            .isNotEmpty) {
          return widget.inLibraryWidget(
            context,
            () async {
              if (widget.item is Identifiable) {
                await widget.libraryController.methods.deleteLibraryItem(
                  (widget.item as Identifiable).id,
                );
              }
            },
          );
        }
        return widget.notInLibraryWidget(
          context,
          () async {
            if (widget.item is Identifiable) {
              await widget.libraryController.methods.addToLibrary(widget.item);
            }
          },
        );
      },
    );
  }
}
