import 'package:musily/features/auth/domain/entities/user_entity.dart';

abstract class CreateAccountUsecase {
  Future<UserEntity> exec({
    required String name,
    required String email,
    required String password,
  });
}
