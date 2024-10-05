import 'package:flutter/material.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/auth/presenter/controllers/auth_controller/auth_data.dart';
import 'package:musily/features/auth/presenter/controllers/auth_controller/auth_methods.dart';
import 'package:musily_repository/musily_repository.dart';

class AuthController extends BaseController<AuthData, AuthMethods> {
  final musilyRepository = MusilyRepository();

  final GlobalKey loginPageKey = GlobalKey();
  final GlobalKey signupPageKey = GlobalKey();

  AuthController() {
    updateData(
      data.copyWith(
        user: musilyRepository.currentUser,
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
      login: ({required email, required password}) async {
        updateData(
          data.copyWith(
            loading: true,
          ),
        );
        try {
          final user = await musilyRepository.login(email, password);
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
          await musilyRepository.logout();
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
          final user = await musilyRepository.createAccount(
            name.trim().toLowerCase(),
            email.trim().toLowerCase(),
            password.trim().toLowerCase(),
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
