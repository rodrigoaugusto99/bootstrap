import 'package:shared_preferences/shared_preferences.dart';

enum SharedPreferencesKeys {
  sawOnboarding,
}

Future<void> setBoolSharedPreferences({
  required SharedPreferencesKeys key,
  required bool value,
}) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool(key.name, value);
}

Future<bool> getBoolSharedPreferences(SharedPreferencesKeys value) async {
  final prefs = await SharedPreferences.getInstance();
  final valueToReturn = prefs.getBool(value.name) ?? false;
  return valueToReturn;
}

Future<void> setStringSharedPreferences({
  required SharedPreferencesKeys key,
  required String value,
}) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString(key.name, value);
}

Future<String?> getStringSharedPreferences(SharedPreferencesKeys value) async {
  final prefs = await SharedPreferences.getInstance();
  final valueToReturn = prefs.getString(value.name);
  return valueToReturn;
}
