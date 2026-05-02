# Componentes

Componentes reutilizáveis em múltiplas telas ficam aqui. Componentes usados só em uma tela ficam dentro da pasta da própria view.

---

## Assets (SVGs e Imagens)

Nunca referencie assets por string. Use os enums tipados.

```dart
// ── SVGs: lib/utils/svg_utils.dart ──
enum SvgEnum {
  logo('logo'),
  icon('icon');

  const SvgEnum(this.name);
  final String name;
}

// Uso na View:
SvgUtil(SvgEnum.logo)


// ── Imagens: lib/utils/image_utils.dart ──
enum ImageEnum {
  logo('logo'),
  background('background'),
  photo('photo', ext: 'jpg');

  const ImageEnum(this.name, {this.ext = 'png'});
  final String name;
  final String ext;
}

// Uso na View:
ImageUtil(ImageEnum.background)
```

---

## Toggle e Seleção

Sempre gerencie estado na ViewModel. Use sempre `GestureDetector` com `behavior: HitTestBehavior.translucent`.

**Radio (seleção única):**

```dart
// ViewModel
SexEnum sexSelected = SexEnum.male;

void handleToggleSex(SexEnum sex) {
  sexSelected = sex;
  notifyListeners();
}

// View
GestureDetector(
  behavior: HitTestBehavior.translucent,
  onTap: () => viewModel.handleToggleSex(SexEnum.male),
  child: Row(children: [
    CustomRadioBall(isSelected: viewModel.sexSelected == SexEnum.male),
    widthSeparator(8),
    styledText(text: 'Masculino', fontSize: 16),
  ]),
)
```

**Checkbox (seleção múltipla):**

```dart
// ViewModel
List<FruitEnum> fruitsSelected = [];

void handleSelectFruit(FruitEnum fruit) {
  if (fruitsSelected.contains(fruit)) {
    fruitsSelected.remove(fruit);
  } else {
    fruitsSelected.add(fruit);
  }
  notifyListeners();
}

// View
CustomCheckBox(
  text: translateEnum(FruitEnum.apple),
  isSelected: viewModel.fruitsSelected.contains(FruitEnum.apple),
  onTap: () => viewModel.handleSelectFruit(FruitEnum.apple),
)
```
