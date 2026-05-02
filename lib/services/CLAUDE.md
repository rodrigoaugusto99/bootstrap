# Services

Singletons registrados no locator. Intermediam a ViewModel e o Firestore.

## Regras

- Nunca acessam `BuildContext`.
- Nunca chamam `admin.firestore()` ou `FirebaseFirestore` diretamente — delegam para `lib/firestore/`.
- Usam `ValueNotifier` para estado reativo exposto à ViewModel.
- Lançam `AppError` em caso de erro — a ViewModel captura e exibe ao usuário.
- Recebem parâmetros simples ou schemas — nunca recebem Models diretamente de controllers externos.

## Padrão

```dart
class UserService with ListenableServiceMixin {
  final _firestore = UserFirestore();
  final _log = getLogger('UserService');

  ValueNotifier<UserModel?> user = ValueNotifier(null);

  Future<void> updateUserRegistration(UserRegistrationSchema schema) async {
    try {
      await _firestore.updateUser(map: schema.toMap(), userId: user.value!.id);
    } catch (e) {
      _log.e(e);
      throw AppError(message: 'Erro ao atualizar cadastro.');
    }
  }
}
```

A ViewModel captura `AppError`:

```dart
Future<void> handleSubmit() async {
  try {
    await _userService.updateUserRegistration(schema);
  } on AppError catch (e) {
    _log.e(e);
    // mostrar toast com e.message
  }
}
```

→ [examples/ex_service.dart](../../.claude/examples/ex_service.dart)
