import 'package:flutter/material.dart';
import 'package:musily/core/presenter/ui/buttons/ly_tonal_icon_button.dart';
import 'package:musily/core/presenter/ui/lists/ly_list_tile.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';

class LibraryWrapper extends StatelessWidget {
  final LibraryController libraryController;
  final LibraryItemEntity? libraryItem;
  final Widget child;
  const LibraryWrapper({
    super.key,
    required this.libraryController,
    required this.libraryItem,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        LyListTile(
          leading: IgnorePointer(
            child: libraryController.builder(
              builder: (context, data) {
                final synced = libraryItem?.synced ?? true;
                if (data.itemsAddingToLibrary.contains(libraryItem?.id)) {
                  return LyTonalIconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.cloud_upload_rounded),
                  );
                }
                if (synced) {
                  return const SizedBox.shrink();
                }
                return LyTonalIconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.cloud_off),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
