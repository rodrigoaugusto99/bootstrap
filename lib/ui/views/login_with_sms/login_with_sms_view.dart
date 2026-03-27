import 'package:bootstrap/ui/components/app_button.dart';
import 'package:bootstrap/ui/components/custom_bottom_navigation_bar.dart';
import 'package:bootstrap/ui/components/custom_text_form_field.dart';
import 'package:bootstrap/utils/formatters.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:bootstrap/utils/image_util.dart';
import 'package:bootstrap/utils/validators.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'login_with_sms_viewmodel.dart';

class LoginWithSmsView extends StackedView<LoginWithSmsViewModel> {
  const LoginWithSmsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginWithSmsViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ImageUtil(
                  ImageEnum.logo,
                  width: 96,
                ),
                heightSeparator(8),
                styledText(
                  text: 'Instrutor Direção',
                  fontSize: 20,
                  fontWeightEnum: FontWeightEnum.bold,
                ),
                heightSeparator(8),
                styledText(
                  textAlign: TextAlign.center,
                  text: 'Aproxima quem ensina de quem quer dirigir',
                  fontSize: 12,
                  fontWeightEnum: FontWeightEnum.semiBold,
                ),
                heightSeparator(46),
                Form(
                  key: viewModel.formKey,
                  child: CustomTextFormField(
                    floatLabel: 'Número do celular',
                    inputFormatters: [phoneMaskFormatter],
                    controller: viewModel.phoneController,
                    keyboardType: TextInputType.phone,
                    //label: 'Celular',
                    validator: Validators.phone,
                    hintText: 'DDD + número',
                  ),
                ),
                heightSeparator(24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppButton(
                      text: 'Continuar',
                      onPressed: viewModel.login,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottonNavigationBar(
          widget: AppRichText(
            textAlign: TextAlign.center,
            children: [
              const TextSpan(
                text: 'Ao fazer login você concorda com\nos nossos ',
                style: TextStyle(
                  height: 16 / 12,
                  fontSize: 12,
                  letterSpacing: 0.5,
                  color: Colors.black,
                  fontFamily: "Montserrat",
                ),
              ),
              TextSpan(
                text: 'Termos de Uso',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                  height: 16 / 12,
                  letterSpacing: 0.5,
                  color: Colors.black,
                  fontFamily: "Montserrat",
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = viewModel.navigateToTerms,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  LoginWithSmsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginWithSmsViewModel();
}
