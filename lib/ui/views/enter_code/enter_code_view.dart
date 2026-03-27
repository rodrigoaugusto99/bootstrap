import 'package:bootstrap/schemas/code_sent_schema.dart';
import 'package:bootstrap/ui/components/app_button.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:bootstrap/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'enter_code_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/ui/common/app_colors.dart';
import 'package:bootstrap/ui/components/app_button.dart';
import 'package:bootstrap/ui/components/custom_bottom_navigation_bar.dart';
import 'package:bootstrap/ui/components/pin_code_field.dart';
import 'package:stacked/stacked.dart';

import 'enter_code_viewmodel.dart';

class EnterCodeView extends StackedView<EnterCodeViewModel> {
  final CodeSentParams codeSentParams;
  final String phoneNumber;
  final Function() onVerified;
  const EnterCodeView({
    super.key,
    required this.codeSentParams,
    required this.phoneNumber,
    required this.onVerified,
  });

  @override
  Widget builder(
    BuildContext context,
    EnterCodeViewModel viewModel,
    Widget? child,
  ) {
    return WillPopScope(
      onWillPop: () async {
        //viewModel.back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 100,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        bottomNavigationBar: CustomBottonNavigationBar(
          widget: AppButton(
            text: viewModel.isCounting
                ? 'Enviar novamente (${viewModel.secondsRemaining}s)'
                : 'Enviar novamente',
            onPressed: viewModel.isCounting ? () {} : viewModel.resend,
            hasBorder: viewModel.isCounting,
            backgroundColor:
                viewModel.isCounting ? Colors.white : kcPrimaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              heightSeparator(56),
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
              heightSeparator(56),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Digite o código que enviamos por sms para',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: ' $phoneNumber',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        color: Colors.black38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              heightSeparator(24),
              // TextFormField(
              //   keyboardType: TextInputType.number,
              //   maxLength: 6,
              //   onChanged: (value) {
              //     viewModel.onCompleted(value);
              //   },
              // ),
              // Semantics(
              //   label: 'my-textfield',
              //   textField: true,
              //   child: TextField(
              //     key: Key('my-textfield'),
              //   ),
              // ),
              heightSeparator(40),
              Semantics(
                label: 'codigo_telefone',
                textField: true,
                child: PinCodeField(
                  //focusNode: viewModel.focusNode,
                  key: const Key('codigo_telefone'),
                  fieldHeight: acessibilityEnabled(context) ? 80 : 44,
                  fieldWidth: acessibilityEnabled(context) ? 80 : 44,
                  onCompleted: (value) {
                    viewModel.onCompleted(value);
                  },
                  errorAnimationController: viewModel.errorAnimationController,
                ),
              ),
              heightSeparator(24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  EnterCodeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EnterCodeViewModel(
        codeSentParams: codeSentParams,
        phoneNumber: phoneNumber,
        onVerified: onVerified,
      );
}
