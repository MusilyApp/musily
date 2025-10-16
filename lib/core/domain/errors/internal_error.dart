import 'package:musily/core/domain/errors/musily_error.dart';

class InternalError implements MusilyError {
  @override
  int get code => 500;

  @override
  String get id => 'internal_error';

  @override
  StackTrace? get stackTrace => StackTrace.current;
}
