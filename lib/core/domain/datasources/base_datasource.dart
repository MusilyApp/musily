import 'dart:developer';

import 'package:musily/core/domain/adapters/http_adapter.dart';
import 'package:musily/core/domain/errors/internal_error.dart';
import 'package:musily/core/domain/errors/musily_error.dart';

abstract class BaseDatasource {
  Future<T> exec<T>(
    Future<T> Function() callback, {
    Future<T?> Function()? onCatch,
  }) async {
    try {
      final callbackData = await callback();
      return callbackData;
    } catch (e, stracktrace) {
      log('error: $e', stackTrace: stracktrace);
      if (onCatch != null) {
        final catchResult = await onCatch();
        if (catchResult != null) {
          return catchResult;
        }
      }
      if (e is HttpResponse) {
        throw MusilyError(
          code: e.statusCode,
          id: e.data['error'] ?? 'unknown_error',
          stackTrace: stracktrace,
        );
      }
      if (e is MusilyError) {
        rethrow;
      }
      throw InternalError();
    }
  }
}
