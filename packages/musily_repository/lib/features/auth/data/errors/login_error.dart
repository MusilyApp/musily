import 'package:musily_repository/core/domain/errors/musily_error.dart';

class LoginError implements MusilyError {
  @override
  int get code => 401;
  @override
  String get id => 'loginError';
}
