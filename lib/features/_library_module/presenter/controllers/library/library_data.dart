import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';

class LibraryData extends BaseControllerData {
  final bool loading;
  final List<String> itemsAddingToFavorites;
  final List<LibraryItemEntity> items;
  final List<String> itemsAddingToLibrary;
  final List<String> loadedFavoritesHash;
  final List<String> alreadyLoadedFirstFavoriteState;
  LibraryData({
    required this.loading,
    required this.items,
    required this.itemsAddingToLibrary,
    required this.loadedFavoritesHash,
    required this.alreadyLoadedFirstFavoriteState,
    required this.itemsAddingToFavorites,
  });

  @override
  LibraryData copyWith({
    bool? loading,
    List<LibraryItemEntity>? items,
    List<String>? itemsAddingToLibrary,
    List<String>? loadedFavoritesHash,
    List<String>? alreadyLoadedFirstFavoriteState,
    List<String>? itemsAddingToFavorites,
  }) {
    return LibraryData(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      itemsAddingToLibrary: itemsAddingToLibrary ?? this.itemsAddingToLibrary,
      loadedFavoritesHash: loadedFavoritesHash ?? this.loadedFavoritesHash,
      itemsAddingToFavorites:
          itemsAddingToFavorites ?? this.itemsAddingToFavorites,
      alreadyLoadedFirstFavoriteState: alreadyLoadedFirstFavoriteState ??
          this.alreadyLoadedFirstFavoriteState,
    );
  }
}
