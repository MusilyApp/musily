import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/core/presenter/extensions/build_context.dart';
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
        Positioned(
          top: 8,
          right: 8,
          child: libraryController.builder(
            builder: (context, data) {
              final synced = libraryItem?.synced ?? true;
              if (data.itemsAddingToLibrary.contains(libraryItem?.id)) {
                return Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: context.themeData.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: context.themeData.colorScheme.primary
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    LucideIcons.upload,
                    size: 16,
                    color: context.themeData.colorScheme.primary,
                  ),
                );
              }
              if (synced || !UserService.loggedIn) {
                return const SizedBox.shrink();
              }
              return Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.themeData.colorScheme.error
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.themeData.colorScheme.error
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  LucideIcons.cloudOff,
                  size: 16,
                  color: context.themeData.colorScheme.error,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
