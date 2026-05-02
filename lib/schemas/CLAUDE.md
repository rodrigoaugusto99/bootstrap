# Schemas (DTOs)

DTOs para estruturar troca de dados entre camadas ou agrupar parâmetros de funções.

## Diferença em relação a Models

| Schema | Model |
|--------|-------|
| Temporário/contratual | Entidade de domínio persistida |
| Criado na ViewModel, consumido pelo Service | Retornado pelo Firestore, vivem no Service |
| `toMap()` para enviar ao Firestore/API | `fromMap()` + `toMap()` para serialização bidirecional |

## Padrão

```dart
class UserRegistrationSchema {
  UserRegistrationSchema({required this.name, required this.phone});

  final String name;
  final String phone;

  Map<String, dynamic> toMap() => {'name': name, 'phone': phone};
}
```

Uso na ViewModel:

```dart
final schema = UserRegistrationSchema(
  name: nameController.text,
  phone: phoneController.text,
);
await _userService.updateUserRegistration(schema);
```

→ [.claude/schemas/references/ex_schemas.dart](../../.claude/schemas/references/ex_schemas.dart)
