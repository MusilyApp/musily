import 'package:musily/features/auth/domain/entities/user_entity.dart';
import 'package:musily/features/auth/domain/repositories/auth_repository.dart';
import 'package:musily/features/auth/domain/usecases/login_usecase.dart';

class LoginUsecaseImpl implements LoginUsecase {
  late final AuthRepository _authRepository;

  LoginUsecaseImpl({
    required AuthRepository authRepository,
  }) {
    _authRepository = authRepository;
  }

  @override
  Future<UserEntity> exec({
    required String email,
    required String password,
  }) async {
    final user = await _authRepository.login(
      email,
      password,
    );
    return user;
  }
}
