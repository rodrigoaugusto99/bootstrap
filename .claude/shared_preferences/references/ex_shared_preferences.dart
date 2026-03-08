// Keys sempre como enum — nunca strings soltas
enum SharedPreferencesKeys {
  sawOnboarding,
  isDarkMode,
  lastLoginDate,
}

// Ler
bool sawOnboarding = await getBoolSharedPreferences(SharedPreferencesKeys.sawOnboarding);
String? token = await getStringSharedPreferences(SharedPreferencesKeys.authToken);
int? count = await getIntSharedPreferences(SharedPreferencesKeys.loginCount);

// Salvar
await setBoolSharedPreferences(key: SharedPreferencesKeys.sawOnboarding, value: true);
await setStringSharedPreferences(key: SharedPreferencesKeys.authToken, value: token);
await setIntSharedPreferences(key: SharedPreferencesKeys.loginCount, value: 1);

// Exemplo de uso real (startup_viewmodel.dart)
Future<void> runStartupLogic() async {
  final sawOnboarding = await getBoolSharedPreferences(SharedPreferencesKeys.sawOnboarding);
  if (!sawOnboarding) {
    _navigationService.replaceWithOnBoardingView();
    return;
  }
  // continuar fluxo normal
}
