import 'package:musily/core/domain/errors/app_error.dart';

class InternalError implements AppError {
  @override
  int get code => 500;

  @override
  String get error => 'internal_error';

  @override
  String get message => 'Erro interno da aplicação';

  @override
  String get title => '';
}
