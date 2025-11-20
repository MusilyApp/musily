// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:musily/features/auth/data/models/user_model.dart';
import 'package:musily/features/auth/domain/entities/user_entity.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() {
    return _instance;
  }
  UserService._internal();

  // final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;

  static bool get loggedIn {
    final userService = UserService();
    return userService.currentUser != null;
  }

  static String get favoritesId {
    final userService = UserService();
    if (UserService.loggedIn) {
      return 'favorites.${userService.currentUser!.id}';
    }
    return 'favorites.anonymous';
  }

  Future<void> initialize() async {
    // final user = await _secureStorage.read(key: 'user');
    // if (user != null) {
    // _currentUser = UserModel.fromJson(user);
    // } else {
    _currentUser = null;
    // }
  }
}
