import 'package:musily/features/auth/domain/entities/user_entity.dart';
import 'package:musily/features/auth/domain/repositories/auth_repository.dart';
import 'package:musily/features/auth/domain/usecases/create_account_usecase.dart';

class CreateAccountUsecaseImpl implements CreateAccountUsecase {
  late final AuthRepository _authRepository;

  CreateAccountUsecaseImpl({
    required AuthRepository authRepository,
  }) {
    _authRepository = authRepository;
  }

  @override
  Future<UserEntity> exec({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await _authRepository.createAccount(
      name,
      email,
      password,
    );
    return user;
  }
}
