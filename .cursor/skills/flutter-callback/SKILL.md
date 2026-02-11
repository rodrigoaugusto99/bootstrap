---
name: flutter-callback
description: Implements callback pattern in Flutter with Stacked. Use when passing functions between views, implementing callbacks, or when the user mentions callback, Function parameter, or passing functions to screens in Stacked.
---

# Flutter Callback Pattern with Stacked

## Padrão de Implementação

Callbacks são usados para passar funções entre views, permitindo comunicação de retorno.

## Estrutura Completa

### View

```dart
class DependentRegisterView extends StackedView<DependentRegisterViewModel> {
  final Function(DependentModel)? registerCallback;
  
  const DependentRegisterView({
    Key? key,
    this.registerCallback,
  }) : super(key: key);

  @override
  DependentRegisterViewModel viewModelBuilder(
    BuildContext context,
  ) => DependentRegisterViewModel(registerCallback);
}
```

### ViewModel

```dart
class DependentRegisterViewModel extends BaseViewModel {
  final Function(DependentModel)? registerCallback;
  
  DependentRegisterViewModel(this.registerCallback);
  
  void someAction() {
    if (registerCallback != null) {
      registerCallback!(dependentModel);
    }
  }
}
```

### Chamando a Tela com Callback

```dart
_navigationService.navigateToDependentRegisterView(
  registerCallback: (dependent) => handleRegistration(dependent),
);

void handleRegistration(DependentModel dependent) {
  // processar o dependent
}
```

## Regras Importantes

- Sempre declare o callback como opcional (`?`)
- Passe o callback do construtor da View para o construtor da ViewModel
- Verifique se o callback não é null antes de chamar
- Use callbacks para comunicação de retorno entre telas
