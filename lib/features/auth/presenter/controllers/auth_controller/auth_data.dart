import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/auth/domain/entities/user_entity.dart';

class AuthData extends BaseControllerData {
  UserEntity? user;
  final bool loading;

  AuthData({
    required this.user,
    required this.loading,
  });

  @override
  AuthData copyWith({
    UserEntity? user,
    bool? loading,
  }) {
    return AuthData(
      user: user ?? this.user,
      loading: loading ?? this.loading,
    );
  }
}
