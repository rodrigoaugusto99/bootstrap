import 'package:bootstrap/ui/views/complex_register/complex_register_viewmodel.dart';
import 'package:bootstrap/ui/views/components/custom_text_form_field.dart';
import 'package:bootstrap/utils/easy_mask.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:bootstrap/utils/validators.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  final ComplexRegisterViewModel viewModel;
  const FirstPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: viewModel.firstFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            heightSeparator(24),
            CustomTextFormField(
              floatLabel: 'Nome completo',
              controller: viewModel.fullNameController,
              validator: Validators.fullName,
              hintText: 'Informe seu nome completo',
            ),
            heightSeparator(24),
            CustomTextFormField(
              floatLabel: 'Celular (WhatsApp)',
              keyboardType: TextInputType.phone,
              inputFormatters: [phoneMaskFormatter],
              controller: viewModel.celularController,
              validator: Validators.phone,
              enabled: false,
              // hasGreyLabelAndBorder: true,
              isGrey: true,
            ),
            heightSeparator(84),
            // AppButton(
            //   text: viewModel.buttonText,
            //   onPressed: viewModel.nextPage,
            // ),
            // heightSeparator(getBottomPadding(context) + 32),
          ],
        ),
      ),
    );
  }
}
