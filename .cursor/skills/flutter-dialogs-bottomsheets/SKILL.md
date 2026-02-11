---
name: flutter-dialogs-bottomsheets
description: Implements dialogs and bottom sheets with Stacked. Use when creating dialogs, bottom sheets, modal windows, confirmation dialogs, or when the user mentions showCustomDialog, showCustomSheet, DialogService, or modal interactions.
---

# Dialogs e Bottom Sheets com Stacked

## ⚠️ NUNCA mexa no construtor dos arquivos de view de bottom sheets e dialogs

## Localização

- Dialogs: `lib/ui/dialogs/`
- Bottom sheets: `lib/ui/bottom_sheets/`

## Estrutura de Dialog

### View

```dart
class ConfirmationDialog extends StackedView<ConfirmationDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ConfirmationDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ConfirmationDialogModel viewModel,
    Widget? child,
  ) {
    final data = request.data as AppDialogSchema;

    return Dialog(
      child: Column(
        children: [
          Text(data.title),
          ElevatedButton(
            onPressed: viewModel.onPressed,
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  ConfirmationDialogModel viewModelBuilder(BuildContext context) =>
      ConfirmationDialogModel(completer: completer);
}
```

### ViewModel

```dart
class ConfirmationDialogModel extends BaseViewModel {
  final Function(DialogResponse response)? completer;

  ConfirmationDialogModel({this.completer});

  void onPressed() {
    completer!(DialogResponse(confirmed: true, data: ''));
  }
}
```

## Como Chamar um Dialog

```dart
final response = await _dialogService.showCustomDialog(
  variant: DialogType.confirmation,
  barrierDismissible: true,
  data: AppDialogSchema(
    title: 'Sair da conta',
    description: 'Tem certeza que deseja sair da conta?',
    firstButtonText: 'Não, voltar',
    secondButtonText: 'Sim, sair',
  ),
);

if (response == null || !response.confirmed) return;

// código executado se confirmado
```

## Observações Importantes

- `variant` usa o nome da classe (ex: `ConfirmationDialog` → `DialogType.confirmation`)
- Use `AppDialogSchema` quando houver muitos parâmetros
- Verificação `if (response == null || !response.confirmed)` é padrão
- Chamando método da viewmodel na view: `onPressed: viewModel.onPressed` ou `onPressed: () => viewModel.onPressed()`

## Bottom Sheets

Funcionam igual aos dialogs, mas com estas diferenças:

- `DialogResponse` → `SheetResponse`
- `showCustomDialog` → `showCustomSheet`
- `DialogType` → `BottomSheetType`
