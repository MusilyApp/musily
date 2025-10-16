import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/presenter/ui/utils/ly_navigator.dart';

class MusilyError implements Exception {
  final int code;
  final String id;
  final StackTrace? stackTrace;

  MusilyError({
    required this.code,
    required this.id,
    required this.stackTrace,
  });

  static String getErrorStringById(String errorId) {
    final contextManager = ContextManager();
    final context = contextManager.contextStack.last.context;

    switch (errorId) {
      case 'auth.invalid_credentials':
        return context.localization.invalidCredentials;
      case 'internal_server_error':
        return context.localization.internalServerError;
      case 'invalid_request':
        return context.localization.invalidRequest;
      case 'auth.email_already_in_use':
        return context.localization.emailAlreadyInUse;
      case 'auth.login_required':
        return context.localization.loginRequired;
      case 'library.item_not_found':
        return context.localization.itemNotFound;
      case 'library.playlist_not_found':
        return context.localization.playlistNotFound;
      case 'user.invalid_user_id':
        return context.localization.invalidUserId;
      case 'user.user_not_found':
        return context.localization.userNotFound;
      case 'backup_failed':
        return context.localization.backupFailed;
      case 'backup_file_does_not_exist':
        return context.localization.backupFileDoesNotExist;
      default:
        return 'Internal error';
    }
  }

  @override
  String toString() => 'AppError(code: $code, id: $id)';
}
