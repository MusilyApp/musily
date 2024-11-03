import 'package:musily/features/auth/domain/repositories/auth_repository.dart';
import 'package:musily/features/auth/domain/usecases/logout_usecase.dart';

class LogoutUsecaseImpl implements LogoutUsecase {
  late final AuthRepository _authRepository;

  LogoutUsecaseImpl({
    required AuthRepository authRepository,
  }) {
    _authRepository = authRepository;
  }

  @override
  Future<void> exec() async {
    await _authRepository.logout();
  }
}
