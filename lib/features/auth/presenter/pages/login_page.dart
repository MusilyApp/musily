import 'package:flutter/material.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_text_field.dart';
import 'package:musily/core/utils/display_helper.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await widget.authController.methods.login(
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text.trim().toLowerCase(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.authController.builder(
      allowAlertDialog: true,
      builder: (context, data) {
        return PopScope(
          canPop: !data.loading,
          child: Scaffold(
            key: widget.authController.loginPageKey,
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.login),
              automaticallyImplyLeading: !data.loading,
            ),
            body: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width *
                    (DisplayHelper(context).isDesktop ? .3 : .8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LyTextField(
                        enabled: !data.loading,
                        hintText: AppLocalizations.of(context)!.email,
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterYourEmail;
                          }
                          if (!validateEmail(value)) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterAValidEmail;
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
                        hintText: AppLocalizations.of(context)!.password,
                        obscureText: true,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterYourPassword;
                          }
                          if (value.length < 6) {
                            return AppLocalizations.of(context)!
                                .passwordMustBeAtLeast8Characters;
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
                        child: Text(AppLocalizations.of(context)!.login),
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
