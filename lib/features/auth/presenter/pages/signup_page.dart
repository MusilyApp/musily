import 'package:flutter/material.dart';
import 'package:musily/core/presenter/ui/buttons/ly_filled_button.dart';
import 'package:musily/core/presenter/ui/text_fields/ly_text_field.dart';
import 'package:musily/core/utils/display_helper.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createAccount),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width *
              (DisplayHelper(context).isDesktop ? .3 : .8),
          child: widget.authController.builder(builder: (context, data) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LyTextField(
                    enabled: !data.loading,
                    hintText: AppLocalizations.of(context)!.name,
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .pleaseEnterYourName;
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
                    child: Text(AppLocalizations.of(context)!.createAccount),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
