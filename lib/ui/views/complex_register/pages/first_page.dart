import 'package:bootstrap/ui/components/custom_check_box.dart';
import 'package:bootstrap/ui/components/custom_radio_ball.dart';
import 'package:bootstrap/ui/views/complex_register/complex_register_viewmodel.dart';
import 'package:bootstrap/ui/components/custom_text_form_field.dart';
import 'package:bootstrap/utils/easy_mask.dart';
import 'package:bootstrap/utils/enums.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:bootstrap/utils/validators.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  final ComplexRegisterViewModel viewModel;
  const FirstPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    Widget buildSexRadioSelection() {
      return Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => viewModel.handleToggleSex(SexEnum.male),
            child: Row(
              children: [
                CustomRadioBall(
                  isSelected: viewModel.sexSelected == SexEnum.male,
                ),
                widthSeparator(8),
                styledText(
                  text: 'Masculino',
                  fontSize: 16,
                  fontWeightEnum: viewModel.sexSelected == SexEnum.male
                      ? FontWeightEnum.semiBold
                      : FontWeightEnum.regular,
                ),
              ],
            ),
          ),
          widthSeparator(32),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => viewModel.handleToggleSex(SexEnum.female),
            child: Row(
              children: [
                CustomRadioBall(
                  isSelected: viewModel.sexSelected == SexEnum.female,
                ),
                widthSeparator(8),
                styledText(
                  text: 'Feminino',
                  fontSize: 16,
                  fontWeightEnum: viewModel.sexSelected == SexEnum.female
                      ? FontWeightEnum.semiBold
                      : FontWeightEnum.regular,
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget buildLetterSelection() {
      return Row(
        children: [
          CustomCheckBox(
            text: translateEnum(FruitEnum.apple),
            isSelected: viewModel.fruitsSelected.contains(FruitEnum.apple),
            onTap: () => viewModel.handleSelectFruit(FruitEnum.apple),
          ),
          widthSeparator(32),
          CustomCheckBox(
            text: translateEnum(FruitEnum.banana),
            isSelected: viewModel.fruitsSelected.contains(FruitEnum.banana),
            onTap: () => viewModel.handleSelectFruit(FruitEnum.banana),
          ),
          widthSeparator(32),
          CustomCheckBox(
            text: translateEnum(FruitEnum.kiwi),
            isSelected: viewModel.fruitsSelected.contains(FruitEnum.kiwi),
            onTap: () => viewModel.handleSelectFruit(FruitEnum.kiwi),
          ),
        ],
      );
    }

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
              isGrey: true,
            ),
            heightSeparator(24),
            buildSexRadioSelection(),
            heightSeparator(24),
            buildLetterSelection(),
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
