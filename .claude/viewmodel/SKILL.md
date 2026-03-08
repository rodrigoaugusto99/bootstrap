---
name: viewmodel
description: Padrões de ViewModel do Stacked: getters derivados de estado, lógica de UI condicional e como expor dados para a View
---


# ViewModel

## UI condicional via getters

Quando a View precisa exibir valores diferentes (texto, imagem, comportamento) dependendo de um estado da ViewModel, **não coloque lógica condicional na View**. Em vez disso, exponha getters que encapsulam essa decisão.

A View apenas consome — sem `if`, sem `switch`.

```dart
// View
ImageUtil(viewModel.imageEnum!),
Text(viewModel.title),
AppButton(onPressed: viewModel.handleOnPressed),
```

Na ViewModel, use getters para texto, imagem e comportamento:

- **Texto:** `String get title => switch(...)` com os valores por estado
- **Imagem:** `ImageEnum? get imageEnum` retorna null quando não há imagem
- **Ação:** `void handleOnPressed()` decide internamente qual método chamar

→ [ex_viewmodel_conditional_ui.dart](references/ex_viewmodel_conditional_ui.dart)
