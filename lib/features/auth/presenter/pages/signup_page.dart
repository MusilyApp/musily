import 'package:flutter/material.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_text_field.dart';
import 'package:musily/core/presenter/ui/utils/ly_page.dart';

import 'package:musily/core/presenter/extensions/build_context.dart';
import 'package:musily/core/utils/validate_email.dart';
import 'package:musily/features/auth/presenter/controllers/auth_controller/auth_controller.dart';

class SignupPage extends StatefulWidget {
  final AuthController authController;
  const SignupPage({
    super.key,
    required this.authController,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.authController.methods.createAccout(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.authController.builder(
      builder: (context, data) {
        return LyPage(
          contextKey: 'SignupPage',
          preventPop: data.loading,
          child: Scaffold(
            key: widget.authController.signupPageKey,
            appBar: AppBar(
              title: Text(context.localization.createAccount),
            ),
            body: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width *
                    (context.display.isDesktop ? .3 : .8),
                child: widget.authController.builder(builder: (context, data) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LyTextField(
                          enabled: !data.loading,
                          hintText: context.localization.name,
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.localization.pleaseEnterYourName;
                            }
                            return null;
                          },
                          onSubmitted: (value) {
                            _emailFocusNode.requestFocus();
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
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
                              return context
                                  .localization.pleaseEnterAValidEmail;
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
                              return context
                                  .localization.pleaseEnterYourPassword;
                            }
                            if (value.length < 6) {
                              return context.localization
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
                          child: Text(context.localization.createAccount),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
