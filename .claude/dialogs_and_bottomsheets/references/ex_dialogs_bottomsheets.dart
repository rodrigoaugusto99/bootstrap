// ── Dialog ────────────────────────────────────────────────────────────────────

// View (NUNCA altere o construtor)
class ConfirmationDialog extends StackedView<ConfirmationDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ConfirmationDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(BuildContext context, ConfirmationDialogModel viewModel, Widget? child) {
    final data = request.data as AppDialogSchema;
    return Dialog(
      child: Column(children: [
        Text(data.title),
        ElevatedButton(
          onPressed: viewModel.onConfirm,
          child: const Text('OK'),
        ),
      ]),
    );
  }

  @override
  ConfirmationDialogModel viewModelBuilder(BuildContext context) =>
      ConfirmationDialogModel(completer: completer);
}

// ViewModel
class ConfirmationDialogModel extends BaseViewModel {
  final Function(DialogResponse)? completer;
  ConfirmationDialogModel({this.completer});

  void onConfirm() => completer!(DialogResponse(confirmed: true, data: ''));
}

// Como chamar
Future<void> showConfirmation() async {
  final response = await _dialogService.showCustomDialog(
    variant: DialogType.confirmation,
    barrierDismissible: true,
    data: AppDialogSchema(
      title: 'Sair da conta',
      description: 'Tem certeza que deseja sair?',
      firstButtonText: 'Não',
      secondButtonText: 'Sim',
    ),
  );

  if (response == null || !response.confirmed) return;
  // continuar após confirmação
}


// ── Bottom Sheet ──────────────────────────────────────────────────────────────
// Igual ao dialog, mas:
//   DialogResponse  → SheetResponse
//   showCustomDialog → showCustomSheet
//   DialogType      → BottomSheetType
