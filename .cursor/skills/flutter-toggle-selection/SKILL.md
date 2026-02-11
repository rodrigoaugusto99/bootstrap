---
name: flutter-toggle-selection
description: Implements radio buttons and checkbox patterns with Stacked. Use when creating radio selections, checkboxes, multiple selections, toggle options, or when the user mentions radio buttons, checkboxes, or selection UI.
---

# Toggle e Seleção Pattern

## Radio Button (Seleção Única)

### View

```dart
Widget buildSexRadioSelection() {
  return Row(
    children: [
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => viewModel.handleToggleSex(SexEnum.male),
        child: Row(
          children: [
            CustomRadioBall(
              isSelected: viewModel.sexSelected == SexEnum.male,
            ),
            widthSeparator(8),
            styledText(
              text: 'Masculino',
              fontSize: 16,
              fontWeightEnum: viewModel.sexSelected == SexEnum.male
                  ? FontWeightEnum.semiBold
                  : FontWeightEnum.regular,
            ),
          ],
        ),
      ),
      widthSeparator(32),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => viewModel.handleToggleSex(SexEnum.female),
        child: Row(
          children: [
            CustomRadioBall(
              isSelected: viewModel.sexSelected == SexEnum.female,
            ),
            widthSeparator(8),
            styledText(
              text: 'Feminino',
              fontSize: 16,
              fontWeightEnum: viewModel.sexSelected == SexEnum.female
                  ? FontWeightEnum.semiBold
                  : FontWeightEnum.regular,
            ),
          ],
        ),
      ),
    ],
  );
}
```

### ViewModel

```dart
SexEnum sexSelected = SexEnum.male;

void handleToggleSex(SexEnum sex) {
  sexSelected = sex;
  notifyListeners();
}
```

## Checkbox (Seleção Múltipla)

### View

```dart
Widget buildFruitSelection() {
  return Row(
    children: [
      CustomCheckBox(
        text: translateEnum(FruitEnum.apple),
        isSelected: viewModel.fruitsSelected.contains(FruitEnum.apple),
        onTap: () => viewModel.handleSelectFruit(FruitEnum.apple),
      ),
      widthSeparator(32),
      CustomCheckBox(
        text: translateEnum(FruitEnum.banana),
        isSelected: viewModel.fruitsSelected.contains(FruitEnum.banana),
        onTap: () => viewModel.handleSelectFruit(FruitEnum.banana),
      ),
      widthSeparator(32),
      CustomCheckBox(
        text: translateEnum(FruitEnum.kiwi),
        isSelected: viewModel.fruitsSelected.contains(FruitEnum.kiwi),
        onTap: () => viewModel.handleSelectFruit(FruitEnum.kiwi),
      ),
    ],
  );
}
```

### ViewModel

```dart
List<FruitEnum> fruitsSelected = [];

void handleSelectFruit(FruitEnum fruit) {
  if (fruitsSelected.contains(fruit)) {
    fruitsSelected.remove(fruit);
  } else {
    fruitsSelected.add(fruit);
  }
  notifyListeners();
}
```

## Padrões Importantes

### Radio Button
- Use uma variável única para armazenar a seleção
- Substitua o valor inteiro ao selecionar
- Compare diretamente: `sexSelected == SexEnum.male`

### Checkbox
- Use uma `List` para armazenar seleções
- Adicione/remova items com `contains`, `add`, `remove`
- Verifique com `contains()` para `isSelected`

### Ambos
- Sempre chame `notifyListeners()` após alterar estado
- Use `GestureDetector` com `behavior: HitTestBehavior.translucent` para área clicável maior
- Crie métodos separados (`handleToggle...`, `handleSelect...`) na ViewModel
