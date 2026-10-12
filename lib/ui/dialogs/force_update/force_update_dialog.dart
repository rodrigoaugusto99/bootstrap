import 'package:bootstrap/ui/common/app_colors.dart';
import 'package:bootstrap/ui/dialogs/force_update/force_update_dialog_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForceUpdateDialog extends StackedView<ForceUpdateDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ForceUpdateDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ForceUpdateDialogModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Atualização necessária',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Esta versão do app não funciona mais. Atualize pela loja para continuar.',
                style: TextStyle(fontSize: 14, color: kcMediumGrey),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: viewModel.handleUpdate,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Atualizar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ForceUpdateDialogModel viewModelBuilder(BuildContext context) =>
      ForceUpdateDialogModel();
}
