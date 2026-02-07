import 'package:bootstrap/services/location_service.dart';
import 'package:bootstrap/ui/views/complex_register/complex_register_viewmodel.dart';
import 'package:bootstrap/ui/components/custom_text_form_field.dart';
import 'package:bootstrap/utils/easy_mask.dart';
import 'package:bootstrap/utils/helpers.dart';
import 'package:bootstrap/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap/utils/popup.dart';

class SecondPage extends StatelessWidget {
  final ComplexRegisterViewModel viewModel;
  const SecondPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: viewModel.secondFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            heightSeparator(24),
            styledText(
              text: 'Informe seu endereço para definir sua área de atendimento',
              fontSize: 14,
              fontWeightEnum: FontWeightEnum.regular,
            ),
            heightSeparator(32),
            CustomTextFormField(
              floatLabel: 'CEP',
              controller: viewModel.cepController,
              hintText: 'Ex.: 00000-000',
              onChanged: (_) => viewModel.onCepChanged(),
              validator: Validators.cep,
              keyboardType: TextInputType.number,
              inputFormatters: [
                cepMaskFormatter,
              ],
            ),
            heightSeparator(32),
            CustomTextFormField(
              enabled: viewModel.enableStreet,
              floatLabel: 'Endereço completo',
              controller: viewModel.enderecoCompletoController,
              hintText: 'Ex.: Rua das Flores, 120',
              validator: Validators.generic,
            ),
            heightSeparator(24),
            CustomTextFormField(
              enabled: viewModel.enableNeighborhood,
              floatLabel: 'Bairro',
              controller: viewModel.bairroController,
              hintText: 'Ex.: Centro',
              validator: Validators.generic,
            ),

            heightSeparator(24),
            CustomTextFormField(
              enabled: viewModel.enableCity,
              floatLabel: 'Cidade',
              controller: viewModel.cidadeSelecionadaController,
              hintText: 'Ex.: São Paulo',
              validator: Validators.generic,
            ),
            heightSeparator(24),
            CustomTextFormField(
              hasArrowDown: true,
              arrowDownSize: 14,
              onTapDown: (details) {
                if (!viewModel.enableState) return;
                showStatePopup(
                  context: context,
                  offset: details.globalPosition,
                  initialList: estadosParaUF.entries
                      .map((entry) => entry.value)
                      .toList(),
                  onSelected: (String state) =>
                      viewModel.handleSelectState(state),
                );
              },
              enabled: false,
              floatLabel: 'Estado(UF)',
              hintText: 'Selecione o estado',
              controller: viewModel.estadoSelecionadoController,
              validator: (value) => Validators.generic(
                value,
                emptyErrorMessage: 'Selecione um tipo de chave',
              ),
            ),

            heightSeparator(84),
            // AppButton(
            //   text: 'Continuar',
            //   onPressed: viewModel.nextPage,
            // ),
            // heightSeparator(getBottomPadding(context) + 32),
          ],
        ),
      ),
    );
  }
}
