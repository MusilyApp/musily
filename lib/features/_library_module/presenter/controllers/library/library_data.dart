import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';

class LibraryData extends BaseControllerData {
  final bool loading;
  final bool addingToFavorites;
  final List<LibraryItemEntity> items;
  final bool addingToLibrary;
  final List<String> loadedFavoritesHash;
  final List<String> alreadyLoadedFirstFavoriteState;
  LibraryData({
    required this.loading,
    required this.items,
    required this.addingToLibrary,
    required this.loadedFavoritesHash,
    required this.alreadyLoadedFirstFavoriteState,
    required this.addingToFavorites,
  });

  @override
  LibraryData copyWith({
    bool? loading,
    List<LibraryItemEntity>? items,
    bool? addingToLibrary,
    List<String>? loadedFavoritesHash,
    List<String>? alreadyLoadedFirstFavoriteState,
    bool? addingToFavorites,
  }) {
    return LibraryData(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      addingToLibrary: addingToLibrary ?? this.addingToLibrary,
      loadedFavoritesHash: loadedFavoritesHash ?? this.loadedFavoritesHash,
      addingToFavorites: addingToFavorites ?? this.addingToFavorites,
      alreadyLoadedFirstFavoriteState: alreadyLoadedFirstFavoriteState ??
          this.alreadyLoadedFirstFavoriteState,
    );
  }
}
