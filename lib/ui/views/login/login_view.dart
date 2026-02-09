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
    // Widget
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
                heightSeparator(80),
                styledText(
                  text: viewModel.isRegister ? 'Criar Conta' : 'Entrar',
                  fontSize: 32,
                  fontWeightEnum: FontWeightEnum.bold,
                ),
                heightSeparator(40),
                CustomTextFormField(
                  controller: viewModel.emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                heightSeparator(16),
                CustomTextFormField(
                  controller: viewModel.passwordController,
                  label: 'Senha',
                  validator: Validators.password,
                  hasEye: true,
                ),
                heightSeparator(24),
                AppButton(
                  text: viewModel.isRegister ? 'Cadastrar' : 'Entrar',
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
                    onPressed: viewModel.isRegister
                        ? viewModel.wantToLogin
                        : viewModel.wantToRegister,
                    child: Text(
                      viewModel.isRegister
                          ? 'Já tem conta? Fazer login'
                          : 'Não tem conta? Cadastrar',
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
