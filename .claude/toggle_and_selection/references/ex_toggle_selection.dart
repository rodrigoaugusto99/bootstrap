// ── Radio Button (seleção única) ──────────────────────────────────────────────

// ViewModel:
SexEnum sexSelected = SexEnum.male;

void handleToggleSex(SexEnum sex) {
  sexSelected = sex;
  notifyListeners();
}

// View:
GestureDetector(
  behavior: HitTestBehavior.translucent,
  onTap: () => viewModel.handleToggleSex(SexEnum.male),
  child: Row(
    children: [
      CustomRadioBall(isSelected: viewModel.sexSelected == SexEnum.male),
      widthSeparator(8),
      styledText(text: 'Masculino', fontSize: 16),
    ],
  ),
)


// ── Checkbox (seleção múltipla) ───────────────────────────────────────────────

// ViewModel:
List<FruitEnum> fruitsSelected = [];

void handleSelectFruit(FruitEnum fruit) {
  if (fruitsSelected.contains(fruit)) {
    fruitsSelected.remove(fruit);
  } else {
    fruitsSelected.add(fruit);
  }
  notifyListeners();
}

// View:
CustomCheckBox(
  text: translateEnum(FruitEnum.apple),
  isSelected: viewModel.fruitsSelected.contains(FruitEnum.apple),
  onTap: () => viewModel.handleSelectFruit(FruitEnum.apple),
)
