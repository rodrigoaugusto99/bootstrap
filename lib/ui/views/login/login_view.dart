import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (viewModel.isRegister) ...[
                TextFormField(controller: viewModel.emailController),
                TextFormField(controller: viewModel.passwordController),
              ] else ...[
                TextFormField(controller: viewModel.emailController),
                TextFormField(controller: viewModel.passwordController),
              ],
              const SizedBox(height: 20),
              if (viewModel.isRegister)
                TextButton(
                  onPressed: () {
                    viewModel.wantToLogin();
                  },
                  child: const Text('quero fazer login'),
                ),
              if (viewModel.isLogin)
                TextButton(
                  onPressed: () {
                    viewModel.wantToRegister();
                  },
                  child: const Text('quero fazer cadastro'),
                ),
              if (viewModel.isLogin)
                ElevatedButton(
                  onPressed: () {
                    viewModel.handleLogin(isEmailAndPassword: true);
                  },
                  child: const Text('Login'),
                ),
              if (viewModel.isRegister)
                ElevatedButton(
                  onPressed: viewModel.registerWithEmailAndPassword,
                  child: const Text('Register'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();
}
