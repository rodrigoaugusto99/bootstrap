enum SexEnum {
  male,
  female,
}

enum FruitEnum {
  apple,
  banana,
  kiwi,
}

String translateEnum(
  dynamic enumValue, {
  bool isAbbreviated = false,
}) {
  final Map<dynamic, String> translations = {
    SexEnum.male: 'Masculino',
    SexEnum.female: 'Feminino',
    FruitEnum.apple: 'Maçã',
    FruitEnum.banana: 'Banana',
    FruitEnum.kiwi: 'Kiwi',
  };

  return translations[enumValue] ?? enumValue.toString().split('.').last;
}
