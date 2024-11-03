import 'package:musily/features/auth/domain/entities/user_entity.dart';

abstract class AuthDatasource {
  Future<UserEntity> login(
    String email,
    String password,
  );
  Future<UserEntity?> getAuthenticatedUser();
  Future<UserEntity> createAccount(
    String name,
    String email,
    String password,
  );
  Future<void> logout();
}
