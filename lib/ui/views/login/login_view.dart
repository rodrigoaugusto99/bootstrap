import 'package:bootstrap/schemas/login_view_schema.dart';
import 'package:bootstrap/ui/components/app_button.dart';
import 'package:bootstrap/ui/components/custom_text_form_field.dart';
import 'package:bootstrap/utils/enums.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:bootstrap/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  final LoginViewSchema? schema;
  const LoginView({
    Key? key,
    this.schema,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    Widget buildLoginForm() {
      return Column(
        children: [
          CustomTextFormField(
            controller: viewModel.emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          heightSeparator(32),
          CustomTextFormField(
            controller: viewModel.passwordController,
            label: 'Senha',
            validator: Validators.password,
            hasEye: true,
            obscureText: true,
          ),
        ],
      );
    }

    Widget buildRegisterForm() {
      return Column(
        children: [
          CustomTextFormField(
            controller: viewModel.emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          heightSeparator(32),
          CustomTextFormField(
            controller: viewModel.passwordController,
            label: 'Senha',
            validator: Validators.password,
            hasEye: true,
            obscureText: true,
          ),
          heightSeparator(32),
          CustomTextFormField(
            controller: viewModel.confirmPasswordController,
            label: 'Confirme sua senha',
            validator: (value) => Validators.validateConfirmPassword(
              value,
              confirmPassword: viewModel.passwordController.text,
            ),
            hasEye: true,
            obscureText: true,
          ),
        ],
      );
    }

    Widget activeForm =
        viewModel.isRegister ? buildRegisterForm() : buildLoginForm();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                styledText(
                  text: viewModel.title,
                  fontSize: 32,
                  fontWeightEnum: FontWeightEnum.bold,
                ),
                heightSeparator(40),
                activeForm,
                heightSeparator(24),
                AppButton(
                  text: viewModel.buttonLabel,
                  onPressed: () => viewModel.handleLogin(
                    LoginProviderEnum.emailAndPassword,
                  ),
                  isBusy: viewModel.isBusy,
                ),
                heightSeparator(16),
                AppButton(
                  text: 'Continuar com Google',
                  onPressed: () => viewModel.handleLogin(
                    LoginProviderEnum.google,
                  ),
                ),
                heightSeparator(12),
                AppButton(
                  text: 'Continuar com Apple',
                  onPressed: () => viewModel.handleLogin(
                    LoginProviderEnum.apple,
                  ),
                ),
                heightSeparator(12),
                AppButton(
                  text: 'Entrar como Anônimo',
                  onPressed: () => viewModel.handleLogin(
                    LoginProviderEnum.anonymous,
                  ),
                ),
                heightSeparator(24),
                Center(
                  child: TextButton(
                    onPressed: viewModel.handleToggleLogin,
                    child: Text(
                      viewModel.textToggleLogin,
                    ),
                  ),
                ),
                heightSeparator(40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel(schema: schema);
}
