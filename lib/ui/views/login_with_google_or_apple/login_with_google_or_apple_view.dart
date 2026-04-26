import 'package:bootstrap/ui/components/app_button.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'login_with_google_or_apple_viewmodel.dart';

class LoginWithGoogleOrAppleView
    extends StackedView<LoginWithGoogleOrAppleViewModel> {
  const LoginWithGoogleOrAppleView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginWithGoogleOrAppleViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              heightSeparator(40),
              styledText(
                text: 'Entrar',
                fontSize: 32,
                fontWeightEnum: FontWeightEnum.bold,
              ),
              heightSeparator(40),
              AppButton(
                text: 'Continuar com Google',
                onPressed: viewModel.handleLoginWithGoogle,
                isBusy: viewModel.isBusy,
              ),
              heightSeparator(12),
              AppButton(
                text: 'Continuar com Apple',
                onPressed: viewModel.handleLoginWithApple,
                isBusy: viewModel.isBusy,
              ),
              heightSeparator(40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  LoginWithGoogleOrAppleViewModel viewModelBuilder(BuildContext context) =>
      LoginWithGoogleOrAppleViewModel();
}
