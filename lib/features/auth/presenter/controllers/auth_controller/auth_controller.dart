import 'package:flutter/material.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/auth/domain/usecases/create_account_usecase.dart';
import 'package:musily/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:musily/features/auth/domain/usecases/login_usecase.dart';
import 'package:musily/features/auth/domain/usecases/logout_usecase.dart';
import 'package:musily/features/auth/presenter/controllers/auth_controller/auth_data.dart';
import 'package:musily/features/auth/presenter/controllers/auth_controller/auth_methods.dart';

class AuthController extends BaseController<AuthData, AuthMethods> {
  final GlobalKey loginPageKey = GlobalKey();
  final GlobalKey signupPageKey = GlobalKey();

  late final GetCurrentUserUsecase _getCurrentUserUsecase;
  late final LoginUsecase _loginUsecase;
  late final CreateAccountUsecase _createAccountUsecase;
  late final LogoutUsecase _logoutUsecase;

  AuthController({
    required GetCurrentUserUsecase getCurrentUserUsecase,
    required LoginUsecase loginUsecase,
    required CreateAccountUsecase createAccountUsecase,
    required LogoutUsecase logoutUsecase,
  }) {
    _getCurrentUserUsecase = getCurrentUserUsecase;
    _loginUsecase = loginUsecase;
    _createAccountUsecase = createAccountUsecase;
    _logoutUsecase = logoutUsecase;

    updateData(
      data.copyWith(
        user: _getCurrentUserUsecase.exec(),
      ),
    );
  }

  @override
  defineData() {
    return AuthData(
      user: null,
      loading: false,
    );
  }

  @override
  defineMethods() {
    return AuthMethods(
      login: ({
        required email,
        required password,
      }) async {
        updateData(
          data.copyWith(
            loading: true,
          ),
        );
        try {
          final user = await _loginUsecase.exec(
            email: email,
            password: password,
          );
          updateData(
            data.copyWith(
              user: user,
            ),
          );
          if (loginPageKey.currentContext != null) {
            Navigator.pop(loginPageKey.currentContext!);
          }
        } catch (e) {
          catchError(e);
        }
        updateData(
          data.copyWith(
            loading: false,
          ),
        );
      },
      logout: () async {
        updateData(
          data.copyWith(
            loading: true,
          ),
        );
        try {
          await _logoutUsecase.exec();
          data.user = null;
          updateData(data);
        } catch (e) {
          data.user = null;
          updateData(data);
          catchError(e);
        }
        updateData(
          data.copyWith(
            loading: false,
          ),
        );
      },
      createAccout: ({
        required email,
        required name,
        required password,
      }) async {
        updateData(
          data.copyWith(
            loading: true,
          ),
        );
        try {
          final user = await _createAccountUsecase.exec(
            name: name.trim(),
            email: email.trim().toLowerCase(),
            password: password.trim(),
          );
          updateData(
            data.copyWith(
              user: user,
            ),
          );
          if (signupPageKey.currentContext != null) {
            Navigator.pop(signupPageKey.currentContext!);
          }
        } catch (e) {
          catchError(e);
        }
        updateData(
          data.copyWith(
            loading: false,
          ),
        );
      },
      updateUser: ({name, email, password}) async {},
    );
  }
}
