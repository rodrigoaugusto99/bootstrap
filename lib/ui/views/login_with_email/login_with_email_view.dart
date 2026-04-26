import 'package:bootstrap/ui/components/app_button.dart';
import 'package:bootstrap/ui/components/custom_text_form_field.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:bootstrap/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'login_with_email_viewmodel.dart';

class LoginWithEmailView extends StackedView<LoginWithEmailViewModel> {
  const LoginWithEmailView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginWithEmailViewModel viewModel,
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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                heightSeparator(40),
                styledText(
                  text: viewModel.title,
                  fontSize: 32,
                  fontWeightEnum: FontWeightEnum.bold,
                ),
                heightSeparator(40),
                viewModel.isRegister ? buildRegisterForm() : buildLoginForm(),
                heightSeparator(24),
                AppButton(
                  text: viewModel.buttonLabel,
                  onPressed: viewModel.handleSubmit,
                  isBusy: viewModel.isBusy,
                ),
                heightSeparator(16),
                Center(
                  child: TextButton(
                    onPressed: viewModel.handleToggle,
                    child: Text(viewModel.textToggle),
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
  LoginWithEmailViewModel viewModelBuilder(BuildContext context) =>
      LoginWithEmailViewModel();
}
