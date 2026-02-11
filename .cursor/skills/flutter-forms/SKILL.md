---
name: flutter-forms
description: Implements form validation and input masking in Flutter. Use when creating forms, validating inputs, applying masks to text fields, or when the user mentions Form, TextFormField, validation, input masks, or validators.
---

# Flutter Forms: Validação e Máscaras

## Localização dos Recursos

- Validações: `lib/utils/validators.dart`
- Máscaras: `lib/utils/easy_mask.dart`

## Padrão Básico com Validator

### View

```dart
Form(
  key: viewModel.formKey,
  child: Column(
    children: [
      CustomTextFormField(
        label: 'Celular (WhatsApp)',
        keyboardType: TextInputType.phone,
        inputFormatters: [phoneMaskFormatter],
        controller: viewModel.celularController,
        validator: Validators.phone,
      ),
    ],
  ),
)
```

### ViewModel

```dart
final formKey = GlobalKey<FormState>();
final celularController = TextEditingController();

void finalize() {
  if (!formKey.currentState!.validate()) {
    return;
  }
  
  // continuar com o cadastro
}
```

## Mensagem de Erro Personalizada

Use quando precisar de validação customizada sem `validator`.

### View

```dart
Form(
  key: viewModel.formKey,
  child: CustomTextFormField(
    label: 'Celular (WhatsApp)',
    keyboardType: TextInputType.phone,
    inputFormatters: [phoneMaskFormatter],
    controller: viewModel.celularController,
    validationMessage: viewModel.phoneErrorMessage,
  ),
)
```

### ViewModel

```dart
String? phoneErrorMessage;

Future<void> submit() async {
  try {
    // lógica de submissão
  } on AppError catch (e) {
    _log.e(e);
    phoneErrorMessage = e.message;
    notifyListeners();
  }
}
```

## Regras Importantes

- Sempre use `formKey` para validação
- Máscaras vão em `inputFormatters`
- Validators são métodos estáticos em `Validators`
- `validationMessage` sobrescreve a validação padrão
- Chame `formKey.currentState!.validate()` antes de submeter
