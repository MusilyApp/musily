import 'package:musily_repository/core/domain/errors/musily_error.dart';

class SignupError implements MusilyError {
  @override
  int get code => 400;

  @override
  String get id => 'signupError';
}
