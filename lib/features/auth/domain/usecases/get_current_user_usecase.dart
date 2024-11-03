import 'package:musily/features/auth/domain/entities/user_entity.dart';

abstract class GetCurrentUserUsecase {
  UserEntity? exec();
}
