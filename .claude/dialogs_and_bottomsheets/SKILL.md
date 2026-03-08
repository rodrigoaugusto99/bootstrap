---
name: dialogs_and_bottomsheets
description: Use dialogs e bottom sheets para exibir confirmações, alertas e painéis modais com o DialogService e SheetService do Stacked
---


# Dialogs e Bottom Sheets

Nunca mexa no construtor dos arquivos de view de dialog/bottom sheet.

- Dialogs: `lib/ui/dialogs/`
- Bottom sheets: `lib/ui/bottom_sheets/`

Quando fizer um dialog ou bottomsheet, sempre crie nesses diretorios e use o `final _dialogService = locator<DialogService>()`

Bottom sheets funcionam igual aos dialogs, mas: `DialogResponse` → `SheetResponse`, `showCustomDialog` → `showCustomSheet`, `DialogType` → `BottomSheetType`. → [ex_dialogs_bottomsheets.dart](references/ex_dialogs_bottomsheets.dart)
