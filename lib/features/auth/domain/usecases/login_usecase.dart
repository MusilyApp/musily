import 'package:musily/features/auth/domain/entities/user_entity.dart';

abstract class LoginUsecase {
  Future<UserEntity> exec({
    required String email,
    required String password,
  });
}
