# Dialogs

Dialogs ficam em `lib/ui/dialogs/`. Use o `DialogService` do Stacked.

## Regras

- **Nunca altere o construtor** da View de dialog — os parâmetros `request` e `completer` são obrigatórios e fixos.
- Chame dialogs sempre via ViewModel: `final _dialogService = locator<DialogService>()`.
- Dados customizados vão no campo `data` do `showCustomDialog` como schema.

## Padrão

```dart
// ── View (NUNCA altere o construtor) ─────────────────────────────────────────
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

// ── ViewModel ────────────────────────────────────────────────────────────────
class ConfirmationDialogModel extends BaseViewModel {
  final Function(DialogResponse)? completer;
  ConfirmationDialogModel({this.completer});

  void onConfirm() => completer!(DialogResponse(confirmed: true, data: ''));
}

// ── Como chamar (na ViewModel da tela) ───────────────────────────────────────
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
```
