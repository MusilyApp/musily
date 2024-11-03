import 'package:musily/core/data/services/user_service.dart';
import 'package:musily/features/auth/domain/datasource/auth_datasource.dart';
import 'package:musily/features/auth/domain/entities/user_entity.dart';
import 'package:musily/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  late final AuthDatasource _authDatasource;

  AuthRepositoryImpl({
    required AuthDatasource authDatasource,
  }) {
    _authDatasource = authDatasource;
    initialize();
  }

  UserEntity? _currentUser;
  @override
  UserEntity? get currentUser => _currentUser;

  initialize() {
    final userService = UserService();
    _currentUser = userService.currentUser;
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    final user = await _authDatasource.login(email, password);
    return user;
  }

  @override
  Future<UserEntity?> getAuthenticatedUser() async {
    final user = await _authDatasource.getAuthenticatedUser();
    return user;
  }

  @override
  Future<UserEntity> createAccount(
    String name,
    String email,
    String password,
  ) async {
    final user = await _authDatasource.createAccount(
      name,
      email,
      password,
    );
    return user;
  }

  @override
  Future<void> logout() async {
    await _authDatasource.logout();
  }
}
