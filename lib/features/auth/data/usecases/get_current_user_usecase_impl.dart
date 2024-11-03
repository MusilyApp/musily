import 'package:musily/features/auth/domain/entities/user_entity.dart';
import 'package:musily/features/auth/domain/repositories/auth_repository.dart';
import 'package:musily/features/auth/domain/usecases/get_current_user_usecase.dart';

class GetCurrentUserUsecaseImpl implements GetCurrentUserUsecase {
  late final AuthRepository _authRepository;

  GetCurrentUserUsecaseImpl({
    required AuthRepository authRepository,
  }) {
    _authRepository = authRepository;
  }

  @override
  UserEntity? exec() {
    final user = _authRepository.currentUser;
    return user;
  }
}
