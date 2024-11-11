import 'package:flutter/material.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_text_field.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';

import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/utils/validate_email.dart';
import 'package:musily/features/auth/presenter/controllers/auth_controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  final AuthController authController;
  const LoginPage({
    super.key,
    required this.authController,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await widget.authController.methods.login(
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.authController.builder(
      allowAlertDialog: true,
      builder: (context, data) {
        return LyPage(
          contextKey: 'LoginPage',
          preventPop: data.loading,
          child: Scaffold(
            key: widget.authController.loginPageKey,
            appBar: AppBar(
              title: Text(context.localization.login),
              automaticallyImplyLeading: !data.loading,
            ),
            body: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width *
                    (context.display.isDesktop ? .3 : .8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LyTextField(
                        enabled: !data.loading,
                        hintText: context.localization.email,
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.localization.pleaseEnterYourEmail;
                          }
                          if (!validateEmail(value)) {
                            return context.localization.pleaseEnterAValidEmail;
                          }
                          return null;
                        },
                        onSubmitted: (value) {
                          _passwordFocusNode.requestFocus();
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      LyTextField(
                        enabled: !data.loading,
                        hintText: context.localization.password,
                        obscureText: true,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.localization.pleaseEnterYourPassword;
                          }
                          if (value.length < 6) {
                            return context
                                .localization.passwordMustBeAtLeast8Characters;
                          }
                          return null;
                        },
                        onSubmitted: (value) {
                          _submitForm();
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      LyFilledButton(
                        onPressed: _submitForm,
                        fullWidth: true,
                        loading: data.loading,
                        child: Text(context.localization.login),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
