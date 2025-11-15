import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/_library_module/domain/entities/library_item_entity.dart';
import 'package:musily/features/_library_module/domain/entities/local_library_playlist.dart';

enum BackupActivityType { backup, restore }

class LibraryData extends BaseControllerData {
  final bool loading;
  final List<String> itemsAddingToFavorites;
  final List<LibraryItemEntity> items;
  final List<String> itemsAddingToLibrary;
  final List<String> loadedFavoritesHash;
  final List<String> alreadyLoadedFirstFavoriteState;
  final bool backupInProgress;
  final double backupProgress;
  final String backupMessage;
  final String? backupMessageKey;
  final Map<String, String>? backupMessageParams;
  final BackupActivityType? backupActivityType;
  final List<LocalLibraryPlaylist> localPlaylists;

  LibraryData({
    required this.loading,
    required this.items,
    required this.itemsAddingToLibrary,
    required this.loadedFavoritesHash,
    required this.alreadyLoadedFirstFavoriteState,
    required this.itemsAddingToFavorites,
    this.localPlaylists = const [],
    this.backupInProgress = false,
    this.backupProgress = 0.0,
    this.backupMessage = '',
    this.backupMessageKey,
    this.backupMessageParams,
    this.backupActivityType,
  });

  @override
  LibraryData copyWith({
    bool? loading,
    List<LibraryItemEntity>? items,
    List<String>? itemsAddingToLibrary,
    List<String>? loadedFavoritesHash,
    List<String>? alreadyLoadedFirstFavoriteState,
    List<String>? itemsAddingToFavorites,
    bool? backupInProgress,
    double? backupProgress,
    String? backupMessage,
    String? backupMessageKey,
    Map<String, String>? backupMessageParams,
    BackupActivityType? backupActivityType,
    List<LocalLibraryPlaylist>? localPlaylists,
    bool clearBackupActivityType = false,
  }) {
    return LibraryData(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      itemsAddingToLibrary: itemsAddingToLibrary ?? this.itemsAddingToLibrary,
      loadedFavoritesHash: loadedFavoritesHash ?? this.loadedFavoritesHash,
      itemsAddingToFavorites:
          itemsAddingToFavorites ?? this.itemsAddingToFavorites,
      localPlaylists: localPlaylists ?? this.localPlaylists,
      alreadyLoadedFirstFavoriteState: alreadyLoadedFirstFavoriteState ??
          this.alreadyLoadedFirstFavoriteState,
      backupInProgress: backupInProgress ?? this.backupInProgress,
      backupProgress: backupProgress ?? this.backupProgress,
      backupMessage: backupMessage ?? this.backupMessage,
      backupMessageKey: backupMessageKey ?? this.backupMessageKey,
      backupMessageParams: backupMessageParams ?? this.backupMessageParams,
      backupActivityType: clearBackupActivityType
          ? null
          : (backupActivityType ?? this.backupActivityType),
    );
  }
}
