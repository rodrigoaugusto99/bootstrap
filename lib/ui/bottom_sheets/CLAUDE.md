# Bottom Sheets

Bottom sheets ficam em `lib/ui/bottom_sheets/`. Funcionam exatamente como dialogs, com três substituições:

| Dialog | Bottom Sheet |
|--------|-------------|
| `DialogResponse` | `SheetResponse` |
| `showCustomDialog` | `showCustomSheet` |
| `DialogType` | `BottomSheetType` |

## Regras

- **Nunca altere o construtor** da View de bottom sheet — os parâmetros `request` e `completer` são obrigatórios e fixos.
- Chame bottom sheets sempre via ViewModel: `final _sheetService = locator<BottomSheetService>()`.
- Dados customizados vão no campo `data` do `showCustomSheet` como schema.

## Padrão

```dart
// ── View (NUNCA altere o construtor) ─────────────────────────────────────────
class NoticeSheet extends StackedView<NoticeSheetModel> {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const NoticeSheet({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(BuildContext context, NoticeSheetModel viewModel, Widget? child) {
    final data = request.data as AppSheetSchema;
    return Container(
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
  NoticeSheetModel viewModelBuilder(BuildContext context) =>
      NoticeSheetModel(completer: completer);
}

// ── ViewModel ────────────────────────────────────────────────────────────────
class NoticeSheetModel extends BaseViewModel {
  final Function(SheetResponse)? completer;
  NoticeSheetModel({this.completer});

  void onConfirm() => completer!(SheetResponse(confirmed: true));
}

// ── Como chamar (na ViewModel da tela) ───────────────────────────────────────
Future<void> showNotice() async {
  final response = await _sheetService.showCustomSheet(
    variant: BottomSheetType.notice,
    barrierDismissible: true,
    data: AppSheetSchema(title: 'Atenção'),
  );

  if (response == null || !response.confirmed) return;
  // continuar após confirmação
}
```
