import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily_repository/core/data/models/musily_user.dart';

class AuthData extends BaseControllerData {
  MusilyUser? user;
  final bool loading;

  AuthData({
    required this.user,
    required this.loading,
  });

  @override
  AuthData copyWith({
    MusilyUser? user,
    bool? loading,
  }) {
    return AuthData(
      user: user ?? this.user,
      loading: loading ?? this.loading,
    );
  }
}
