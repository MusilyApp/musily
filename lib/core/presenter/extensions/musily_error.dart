import 'package:musily/core/domain/errors/musily_error.dart';

extension ExtendedMusilyError on MusilyError {
  String get message {
    return MusilyError.getErrorStringById(id);
  }
}
