---
name: flutter-shared-preferences
description: Implements local storage with SharedPreferences. Use when storing simple flags, preferences, onboarding state, or when the user mentions SharedPreferences, local storage, persistent flags, or app preferences.
---

# SharedPreferences Pattern

## Objetivo

SharedPreferences armazena dados simples e persistentes no dispositivo.

## Uso Apropriado

### ✅ Use para:
- Controle de onboarding
- Flags de primeira execução
- Preferências simples de UI

### ❌ Não Use para:
- Entidades de domínio
- Dados críticos de negócio
- Substituir banco de dados ou Firestore

## Padronização de Keys

**SEMPRE** use enums para keys. **NUNCA** use strings soltas.

```dart
enum SharedPreferencesKeys {
  sawOnboarding,
  isDarkMode,
  lastLoginDate,
}
```

## Exemplo: Checar Onboarding

```dart
bool sawOnboarding = await getBoolSharedPreferences(
  SharedPreferencesKeys.sawOnboarding,
);

if (!sawOnboarding) {
  _navigationService.replaceWithOnBoardingView();
  return;
}
```

## Exemplo: Salvar Flag

```dart
await setBoolSharedPreferences(
  key: SharedPreferencesKeys.sawOnboarding,
  value: true,
);
```

## Funções Disponíveis

Funções wrapper estão em `lib/utils/shared_preferences.dart`:

- `getBoolSharedPreferences(key)`
- `setBoolSharedPreferences(key, value)`
- `getStringSharedPreferences(key)`
- `setStringSharedPreferences(key, value)`
- `getIntSharedPreferences(key)`
- `setIntSharedPreferences(key, value)`

## Regras Importantes

- Declare todas as keys em `SharedPreferencesKeys` enum
- Use funções wrapper em `utils/shared_preferences.dart`
- Não armazene dados complexos ou críticos
- SharedPreferences é para dados simples apenas
